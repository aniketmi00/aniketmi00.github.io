---
title: intro to torch compile
date: '2024-09-04 18:30:00+00:00'
---

![Torch Compile](/assets/images/torch-compile.webp){: width="1203" height="735"}

PyTorch has two execution modes:

1. eager mode - each op is executed instantly as it appears in the code (simple to understand and hack).
2. graph mode - evaluates all the ops to see if there's any chance of optimization (generally performs better but it's complicated and takes time to compile code).

By default execution mode of pytorch is eager mode but pytorch 2.0 natively supports graph mode using the compile API.

To see if you've compiled the code successfully you can either use PyTorch Profiler or set the `os.environ["TORCH_COMPILE_DEBUG"] = "1"`.

Once you have a model just do:

```python
torch.compile(resnet, mode="reduce-overhead")
```

There are three compiling modes in the API:

1. default - balances between compiling time and model performance. This works better in most cases.
2. reduce-overhead - reduces the overhead of loading batches to memory and is used for small batches.
3. max-autotune - most optimized code but takes a lot of time to optimize the code.

There's a catch, as per the pytorch docs, compile works best with GPUs of compute capability >= 7.0 (Volta and newer) and on much more complex and deep architectures with a high number of parameters.

this is what torch.compile is and what it does. we will see what's happens under the hood later.

Refer to [this tutorial](https://pytorch.org/tutorials/intermediate/torch_compile_tutorial.html) for a nice intro to `torch.compile`.
