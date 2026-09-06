---
title: how to enable high performance LLM serving
date: '2024-06-02 13:19:00+00:00'
---

![LLM Optimization](/assets/images/llm-optimization.webp){: width="1310" height="886"}

These are my notes on the GPU optimization workshop organized by Chip Huyen.

Sharan Chetlur talks about inference optimization techniques and how to achieve high performance while serving LLMs.

1. The majority of the apps are real-time(online systems) and they require acceptable latencies, should be highly accurate(helpful) and should be cost-effective as deploying these large models can be expensive.
	
2. These models will keep getting bigger and better. See chinchilla scaling laws.
	
3. So to optimize for these challenges we need a high-performant, robust and customizable solution.
	
4. Quantization came up again here as it's becoming necessary to do it(it's an all-round win with just a bit of effort) as long as you maintain accuracy.
	
5. So you can train llms in the BF16 dtype but inference can be done in lower precision dtypes like int8, int4 or even lower. This is post-training quantization and usually just needs calibration.
	
6. Post-training quantization can make compute faster, and communications between GPUs can happen with high throughput.
	
7. There are other optimization techniques as well like quantization aware training (retrain model on small dataset), sparsity.
	
8. At inference time an LLM request has 2 phases:
		
  1. Prefill - processes the prompt, generate 1st token and initialize the KV cache(this cache stores intermediate activations). This phase is compute-heavy.
		
  2. Generate - generate the next token using the last generated token and the KV cache and update the cache. This phase is memory-bound.
	
9. Compute in the attention block depends on the kind of implementation (can be compute or memory-bound).
	
10. These are compute and memory-bound phases and the serving solution should have custom CUDA kernels for high perf (e.g. flash attention). remember we need to keep our CUDA cores busy.
	
11. Static batching - traditionally, requests are accumulated over some time window, and executed as a batch until completion. This can work if we have to do a fixed amount of work but in the space of llms outputs differ massively in length(e.g. "the tallest ferry wheel" vs "explain the multiverse theory").
	
12. In-flight batching - in llm inference there are multiple forward passes per request which is kinda unknown and unbounded(we don't know how many tokens need to be generated). So in-flight batching treats an llm iteration as a single request.

	- so imagine there are 3 requests. req-1 and req-2 is in some state of generation. req-3 is a new request.
	- we check for active requests that have met the end-of-sequence token (or some end condition) and then evict that request (e.g. req-1).
	- replace it with the new one (req-3).
	- run the next iteration.
	
13. Sometimes in a single iteration there are requests that are in the generation phase whereas others are in the prefill phase. These tokens in different phases can then be concatenated for higher throughput.
	
14. Paged KV cache - traditionally these caches were contiguous in memory and this leads to wastage of memory since its based on max sequence length. Paged KV cache however is partitioned into blocks and these do not need to be contiguous. This way memory waste only happens in the last block.
	
15. KV cache reuse - now this representation allows memory sharing. For example the system prompt which might be common for 2 requests can now be cached and reused for the 2nd request. see [pagedAttention by vllm](https://blog.vllm.ai/2023/06/20/vllm.html).
	
16. Speculative decoding - makes educated guesses about future tokens while generating the current token, all within a single forward pass. See [Hitchhiker's guide to Speculative Decoding by PyTorch](https://pytorch.org/blog/hitchhikers-guide-speculative-decoding/).

17. Nvidia has a blog post on the [LLM inference optimization techniques](https://developer.nvidia.com/blog/mastering-llm-techniques-inference-optimization/).
