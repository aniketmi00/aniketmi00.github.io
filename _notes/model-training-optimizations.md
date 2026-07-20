---
title: tune pytorch to optimize model training using OpenMP
date: '2024-09-12 14:35:00+00:00'
---

OpenMP is a specialized library for multithreading and is used to bring better performance for parallel computation tasks.

PyTorch has OpenMP as a default backend for parallel work but you can still make some changes to extract more performance.

Run `lscpu` to get info about available physical and logical cores.

Run `torch.__config__.parallel_info()` to get info about a number of threads that can be used or the total number of cores available.

let's see why we need it in the first place: threads vs processes.

Threads communicate easily (only read/write data to memory) with each other whereas processes have to exchange queues, sockets,and messages.

So to manage these threads easily we need OpenMP framework.

How to use OpenMP with PyTorch to speed up training?
OpenMP by default uses physical and logical cores both to allocate threads but we can set some variables to control this allocation to only use physical cores as they are faster.

`OMP_PROC_BIND` - Prevent threads from moving between cores. set to TRUE.

`OMP_SCHEDULE` - Binds threads to cores. set to STATIC.

`GOMP_CPU_AFFINITY` - Binds threads to specific cores. e.g. 0-15

To optimize the Intel CPU you can use IPEX which is built natively for PyTorch.

Refer the [performance tuning guide](https://PyTorch.org/tutorials/recipes/recipes/tuning_guide.html) by PyTorch
