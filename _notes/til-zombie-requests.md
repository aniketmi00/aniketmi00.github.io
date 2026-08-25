---
title: zombie requests
date: '2025-12-30 04:56:00+00:00'
---

<img src="/assets/images/cat-cancellation-stream.webp" alt="cat" width="1600" height="873">

recently i was looking at a cost spike in prod. our _requests completed_ rate had dropped, but our _GPU utilization_ stayed at 100%.

the problem were the **zombie requests** - upstream inference keeps running after downstream client is gone, so utilization stays high while _completed requests_ drops.

when a client times out or disconnects we assume the server stops working. in many web apps, we assume disconnect stops work, but that’s not a safe assumption—even more so for LLM inference. but in the world of expensive LLM inference this assumption might burn a lot of money.

```client disconnects → gateway may not notice immediately → upstream inference keeps running until you abort it```

### few ways we leak the compute

1. **detached background tasks:** if you use `BackgroundTasks` (tasks to be run after returning a response) for inference that code runs to completion regardless of the HTTP connection. so your client disconnected 30 seconds ago, but the model is still generating a 4000-token essay that no one will read.

2. **the cancellation gap:** even with streaming, python doesn't always stop your logic immediately. cancellation in Python async is cooperative; you only notice it at await points or explicit checks, so you must design your generation loop and streaming path to surface disconnect quickly.

### the fix is to have a defense

- detect: observe disconnect
- propagate: cancel upstream HTTP request and pass a cancellation token to the inference engine.
- enforce: hard caps (e.g. max tokens) so even if cancel fails you don't run forever.

buffering multiplies these requests. it delays token delivery, increases client timeouts, and turns _slow stream_ into _disconnected client + still-running GPU_.

```python
@app.post("/chat")
async def stream(request):

    1. define the generator that yields data
    2. stream from engine with a timeout
    3. check if client disconnected explicitly
    4. catch if the server cancels the task

    return StreamingResponse
```

### reality

for most real-time streaming endpoints, the only cancellation mechanism you reliably control is aborting the connection. explicit cancel endpoints usually exist for batch/async jobs (e.g. openai batch cancel, anthropic message batches cancel). 

If you self-host (vllm/TGI/llama.cpp), you should abort the engine request to free GPU/CPU immediately.

### my recommendations

* **monitor the divergence** between request completion rates and GPU/CPU utilization.
* **never use fire-and-forget** tasks for response generation.
* **trace your requests** so you know exactly which job to kill when a client disconnects.
