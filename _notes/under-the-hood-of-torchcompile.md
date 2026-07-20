---
title: under the hood of a powerful feature - torch.compile
date: '2024-09-06 18:30:00+00:00'
---

`torch.compile` is a way to move from eager to graph execution mode and essentially it has a compiler that does the final work.

Now to get the compiled model, `torch.compile` executes 3 steps.

1. Graph acquisition - This step is to capture model definition and transform it into a graph of ops. actually it reads python byte code before execution.

2. Graph lowering - Now it's time to simplify and optimize the graph by fusing, combining and reducing ops.

3. Graph compilation - In this step device code is generated for different architectures, vendors and devices like GPU or even TPU.

Step 1 is executed by `torchdynamo` and is built in CPython and called as the frame evaluation api.

Steps 2 and 3 are executed by the backend compiler torchinductor which uses `openmp` framework and `triton` compiler and this is configurable btw using the `backend` param in the torch.compile. There are many available backends.

@Shashank Prasanna's [super amazing post](https://towardsdatascience.com/how-pytorch-2-0-accelerates-deep-learning-with-operator-fusion-and-cpu-gpu-code-generation-35132a85bd26) about `torch.compile`.
