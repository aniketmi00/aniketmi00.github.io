---
title: how to use automatic mixed precision in pytorch for optimizing model training
date: '2024-10-06 18:30:00+00:00'
---

Automatic mixed precision is different from the concept of quantization.

We generally use 32 bits to represent numbers (INT32 format) with 1 bit for the sign and the remaining 31 bits for the number.

INT32 also requires 4 bytes for 1 int value thus expecting more memory and compute.

Now to represent floating point numbers we use FP32 (single precision) and FP64 (double precision) and these have signs (same as above), exponent (range) and a fraction (decimal places).

Model training usually has FP32.

There are other formats like:

1. `FP16` - has 16 bits and is also called as half-precision.

2. `bfloat16` - has 16 bits but has the same range as FP32 but low-precision and pytorch supports bfloat16 only on CPUs. It was created at Google.

3. `TF32` - has 19 bits and the tensorfloat was created at Nvidia.

[Understand formats](https://moocaholic.medium.com/fp64-fp32-fp16-bfloat16-tf32-and-other-members-of-the-zoo-a1ca7897d407) in detail.

To do model training, save memory and compute (with some compromise on the precision) we can use cheaper formats like FP8.

Training with mixed precision means using low-precision formats wherever possible while keeping high-precision as the default.

This approach not only saves memory but also prevents loss of information (impacting accuracy).

PyTorch also maintains a list of operations to run at lower precision.

Automatic mixed precision by PyTorch automatically replaces an operation to run in lower precision.

We need to use `torch.autocast` but to use it on GPUs we need to do a bit more:

1. Enable backend flags for CUDA and CuDNN.

- `torch.backend.cudnn.benchmark`

- `cuda.matmul.allow_fp16_reduced_precision_reduction`

- `cuda.matmul.allow_bf16_reduced_precision_reduction`

- `torch.backend.cudnn.allow_tf32`

2. Wrap the training loop in the `torch.autocast`.

Use it as a context manager or a decorator and include the forward pass and loss calculation. It accepts `device_type`, and dtype as necessary arguments.

3. Use a gradient scaler.

To prevent loss of information on the gradient because of the low precision we need to use a gradient scaler.

Gradient scaling improves convergence for networks.

We need to wrap optimizations (`optimizer.step`) and backward pass (`loss.backward`) under the `torch.cuda.amp.GradScaler`.

Refer to a [blog](https://pytorch.org/docs/stable/notes/amp_examples.html) post from PyTorch.
