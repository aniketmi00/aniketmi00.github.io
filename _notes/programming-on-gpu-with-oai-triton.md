---
title: programming on GPU with openai triton
date: '2024-06-06 18:30:00+00:00'
---

![Basic architecture of a GPU](https://images.ctfassets.net/kftzwdyauwt9/778bccdf-6cb5-4d9f-3a247ae7f2e3/9e6d1bb6bc09e1f7b3a9adc50fc776b3/gpu-architecture.svg?w=3840&q=90)
_Basic architecture of a GPU._

GPU Programming is very critical and so we need to write kernels in a low-level language like CUDA. Now, there's a language called Triton developed by Open AI which lets you write code in a higher-level and compile to GPUs.

This is one of the talks from the GPU optimization workshop by Chip Huyen and these are my notes on the topic.

Phillipe Tillet of Open AI talks about Triton.
	
1. Triton is a block-based programming language for GPUs.
	
2. Triton is an alternative to CUDA.
	
3. CUDA is very flexible and the developer can have control over almost everything (e.g. what every thread does, what goes into the memory, which data structures to use).
	
4. But this can also be a con as it kinda complicates things and can unknowingly hamper performance. Also imo CUDA has a steep learning curve.
	
5. There are graph compilers that are simpler but lack flexibility.
	
6. So Triton is the middle way out as it's simpler than CUDA but also provides a lot of flexibility.
	
7. Triton sort of works on any consumer hardware that basically follows the typical von neumann architecture(has shared cache, memory controllers, multiple cores, local cache of all the cores).
	
8. Using Triton we're basically programming these cores individually.
	
9. It's up to the compiler to decide which cache to use.
	
10. Triton code is similar to numpy or PyTorch (Python function with `@jit` compiling).
	
11. Triton is highly performant because it has improved several compiler optimizations.
		
12. Peephole optimization - compiler recognizes patterns and converts the tensor ops into code which is more performant, consumes less memory and has less code size. these ops are like redundant code removal, combining operations.
		
13. SRAM allocation - Compilers allocate not only SRAM (registers) but also shared memory.
		
14. Automatic vectorization - analyzes the efficient way to combine loops to get vectorized code from the scalar code.

To learn CUDA, my recommendation is to start with Triton and then move to CUDA for advanced/complex use-cases.

Resources to refer:
1. [Triton Puzzles](https://github.com/srush/Triton-Puzzles/tree/main) by Sasha Rush
2. [A Practitioner's Guide to Triton](https://www.youtube.com/watch?v=DdTsX6DQk24) by Umer Hayat Adil
