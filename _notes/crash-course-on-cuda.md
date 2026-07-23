---
title: crash course on CUDA
date: '2024-05-28 18:30:00+00:00'
---

![CUDA Architecture by Modal](https://modal-cdn.com/gpu-glossary/terminal-cuda-g80.svg)

These are my notes on the GPU optimization workshop organized by Chip Huyen.

Mark Saroufim talks about techniques to efficiently run PyTorch models and make them faster.

1. GPUs are expensive because of demand and supply tradeoff and they can make training and serving models faster.

2. So we don't want to underutilise them.

3. Need to just call `.cuda()` and no need to write cuda kernels but under the hood pytorch codegenerate these kernels.
	
4. PyTorch follows eager execution model which is good for debugging but bad for large ops.
	
5. CUDA kernels assign every element to a thread and for simple problems these elements are in contiguous memory for faster performance and there are different threading strategies.
	
6. For more efficiency we can use GPUs memory hierarchy like global memory (VRAM) which is slow whereas shared memory or L1 cache is faster.
	
7. Use PyTorch Profiler for visually seeing the usage of the kernels (mark recommends ncu profiler from nvidia).
	
8. Arithmetic intensity to understand if the problem you have is memory or compute bound and the formula is (number of ops/data movement). if the number is less than 1 then it is memory-bound problem(autoregressive decoding in llms) and if not it's a compute-bound problem.
	
9. Fuse more - use `torch.compile()` to fuse kernels and under the hood PyTorch generates the Triton kernels.
	
10. Use tensor cores - just set `torch.set_float32_matmul_precision("high")`.
	
11. Reduce overhead - a lot of compute goes into figuring out which kernel to run and so to avoid the overhead in GPUs is to use `torch.compile(model, mode="reduce-overhead")` as CUDA kernels are async so we can queue them up (cuda graphs).
	
12. Quantization - use int8 instead of FP16 or BF16 and it also helps in memory bounded workloads.
	
13. Use a custom kernel - use `torch.utils.cpp_extension.load_inline()` which will generate the right files for us.

14. Read the "Programming Massively Parallel Processors" book for more insights.

15. Watch CUDA mode's YouTube channel for long-form [in-depth videos](https://www.youtube.com/channel/UCJgIbYl6C5no72a0NUAPcTA) on CUDA.

16. Read Modal's [GPU Glossary](https://modal.com/gpu-glossary/device-hardware/cuda-device-architecture).

