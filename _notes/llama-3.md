---
title: the llama 3 herd of models
date: '2024-07-24 18:30:00+00:00'
---

I went through the [paper released by Meta on Llama 3 herd of models](https://ai.meta.com/research/publications/the-llama-3-herd-of-models/). It's a 92 page research paper with lots of practical know-hows including infrastructure and scaling.


_TL;DR_

- Meta released their largest open-source language model with 405B parameters.
- Context window up to 128K tokens.
- These language models (8B, 70B, 405B) support multilinguality, coding, reasoning, and tool usage.
- Trained on 15.6T tokens
- Used a standard dense transformer with grouped query attention (GQA) with 8 key-value heads, vocabulary with 128K tokens, and RoPE base frequency hyperparameter increased to 500,000
- Trained on 16K H100 GPUs.
- For fine-tuning uses SFT, followed by DPO.
- Llama 3.1 405B is cheapest on [Fireworks AI](https://fireworks.ai/models) and most expensive on IBM Watsonx.


## Introduction

Llama 3 are a set of foundation language models.

The development of foundation models has two main stages:
1. A pre-training stage where a model is trained for the next-word prediction task
2. a post-training stage where the model is tuned to improve specific capabilities like coding and reasoning.

There are three key components involved in training foundation models:
- Data
- Scale
- Managing complexity

### Data

They pre-trained Llama 3 on a corpus of _15.6T multilingual tokens_ (1.8T tokens for Llama 2).

### Scale
  
They pre-trained Llama 3 using 3.8 x 10^25 FLOPS (50x more than Llama 2).

### Managing complexity

They opted for standard transformer architecture with some modifications (no mixture-of-experts here). They also adopted a simple post-training process based on Supervised fine-tuning (SFT), Rejection sampling (RS), and Direct preference optimization (DPO).

Performance of fine-tuned Llama 3 models on key benchmark evaluations


## Overview

The development of Llama 3 has two main stages:

1. Pre-training
2. Post-training

To have rich capabilities of image, video and speech they have three additional stages:
- Multi-model encoder pre-training
- Vision adapter training
- Speech adapter training


## Pre-training

Pre-training has:

### 1. Curation of a training corpus

They used a variety of data sources containing knowledge until the end of 2023. They applied several de-duplication methods and cleaned the data.
- Removing PII and adult content.
- They process the raw HTML content and remove all markdown markers(markdown is harmful to the performance).
- They apply several rounds of URL-level, document-level and line-level de-duplication.
- They used heuristics to remove low quality documents, outliers and documents with excessive repetitions like the "dirty word" counting to remove adult content.
- They use fastText and RoBERTa-based classifiers to select high-quality tokens.

*Data mix*
They have talked about having data from different data sources in the pre-training data mix and to determine the data mix they used knowledge classification(develop classifier to categorize the types of information in the data) and scaling laws(train several models and use that to predict the performance of the model).

*Annealing data*
Annealing(a process of slowly decreasing the probability of accepting worse solutions as the solution space is explored) can boost the performance of pre-trained models.

### 2. Development of model architecture

They used a standard dense transformer architecture. Their performance gains are primarily because of high-quality data and increased training scale. Some of the modifications they did to the architecture are:

- [Grouped query attention (GQA)](https://arxiv.org/pdf/2305.13245) - improves inference speed and reduces the size of KV caches during decoding
- Attention mask - prevents self-attention between different documents within the same sequence
- Vocabulary of 128K tokens
- [RoPE](https://blog.eleuther.ai/rotary-embeddings/)(Rotary positional embeddings to understand relative position of the tokens) base frequency hyperparameter to 500,000 - supports longer contexts


### 3. Determine the model size using the scaling laws

Scaling laws are used to determine the optimal model size.

To predict downstream benchmark performance, they implemented a two-stage methodology.
- First, establish a correlation between the compute-optimal model's negative log-likelihood on downstream tasks and the training FLOPS
- Second, they correlate the negative log-likelihood on downstream tasks with task accuracy

Their experiments show that the flagship model is robust to small changes in the trade-off between model size and training tokens.

### 4. Efficient pre-training at scale

This section was my favourite and I loved reading through it.

They discuss about the training infrastructure in amazing detail.

- Compute - llama 3.1 405B is trained on 16K H100 GPUs.

- Storage - 240PB of storage out of 7500 servers, throughput ranges from 2 TB/s to 7 TB/s, and they increased checkpoint frequency

- Network - They discuss about the hardware they used, load balancing, and congestion control. I still can't wrap my head around everything explained in the network topology.

#### Parallelism for model scaling

This is what I was most excited about and the detail they go into is outstanding. To get a fair amount of understanding, read about it [here](https://openai.com/index/techniques-for-training-large-neural-networks/).


To scale training, they've used 4D parallelism - a combination of four different types of parallelism methods. It combines tensor, pipeline, context and data parallelism.

- Tensor parallelism - splits individual weight tensors into multiple chunks on different devices.
- Pipeline parallelism - partitions the model vertically into stages by layers.
- Context parallelism - divides the input context into segments.
- Data parallelism(FSDP) - shards model, optimizer, and gradients and process data in parallel on multiple GPUs and synchronize after each training step.

Some of the challenges they encountered:
- Batch size constraint - supported batch size per GPU should be divisible by the number of pipeline stages.
- Memory imbalance - The first stage consumes more memory due to embedding and the warm-up micro-batches.
- Computation imbalance - While calculating output and loss, there's an execution latency bottleneck.

I want to go in-depth on this but some other time, perhaps in a different post.

### Development of pre-training recipe

The training recipe includes:

- Initial pre-training - They use a lower batch size early in training to improve training stability, and increase it subsequently to improve efficiency. So they train with a batch size of 4M tokens and then double it to 8M after pre-training 252M tokens. Then double it to 16M after training 2.87T tokens.

- Long-context pre-training - In the final stages of pre-training, they train on long sequences to support context windows of up to 128K tokens.

- Annealing


## Post-training

They align the models by applying several rounds of post-training, or aligning the model with human feedback on top of a pre-trained checkpoint. Each round of post-training involves [supervised finetuning (SFT)](https://cameronrwolfe.substack.com/p/understanding-and-using-supervised) followed by [Direct Preference Optimization (DPO)](https://huggingface.co/blog/pref-tuning) on examples collected either via human annotations or generated synthetically.


They first train a reward model on top of the pre-trained checkpoint using human-annotated preference data. Then fine-tune pre-trained checkpoints with supervised fine-tuning (SFT), and further align the checkpoints with Direct Preference Optimization (DPO).


## Capabilities

They have discussed the capabilities of these model in detail like how are they trained, what data was used. I haven't covered them here as the concepts are very specific to the capability but anyway it's worth the read.


## Conclusion

This is arguably some of the best write-up I've ever read. They not only go in detail about the approaches they took, challenges they faced but also try to make us understand why they made such a decision.


## References

[1] They released a [blog post](https://ai.meta.com/blog/meta-llama-3-1/).

[2] You can play with Llama 3.1 [here](https://www.meta.ai).

[3] Meta is committed to open-source AI development. Read [Mark's letter](https://about.fb.com/news/2024/07/open-source-ai-is-the-path-forward/).
