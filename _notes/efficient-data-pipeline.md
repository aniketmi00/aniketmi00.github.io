---
title: build an efficient data pipeline
date: '2024-09-22 18:30:00+00:00'
---

Before feeding data to the model for training we need to:

1. Load the data from the disk to memory.
2. Do preprocessing like normalization, data augmentation.

To build an efficient data pipeline pytorch has:

1. `Dataset` - a source of data like files and transformations.
2. `DataLoader` - interface to get the samples.

Our goal is to minimize GPU idle time and to do this we need to:

1. Minimize data transfer time between CPU and GPU.
2. Increase workers.

## Data transfer from CPU to GPU

Data never gets directly copied to the pageable memory but there's a pin memory in between. To reduce this work, we can directly use this pin memory to write our data.

```python
DataLoader(training_data, batch_size=128, pin_memory=True)
```

Request for the pinned memory can fail and there will be an increase in memory usage.
 
Refer to the [blog post by nvidia](https://developer.nvidia.com/blog/how-optimize-data-transfers-cuda-cc) to understand more.

`DataLoader` by default uses a single worker for execution.

So if we increase the number of workers, pytorch creates additional processes to handle multiple dataset samples asynchronously.

```python
DataLoader(training_data, batch_size=128, num_workers=8)
```
