---
title: speculative decoding
date: '2024-06-10 18:30:00+00:00'
---

![Speculative Decoding](https://media.licdn.com/dms/image/v2/D5622AQE3YG2yAVvxuw/feedshare-shrink_800/feedshare-shrink_800/0/1731787719280?e=2147483647&v=beta&t=bz2ce4T7CL2UWr_2mNarirqZyJ0nOtIDPQgrVHA4nK8)
_Image by Hongliang Liu_

Speculative decoding is an optimization technique for llms at inference time. In spec decode, we actually make guesses about future tokens while generating the current one, all within a single forward pass.

## Autoregressive Sampling

In autoregressive sampling(standard way of generating text), we sample *Nth* token based on what we sample at step *N-1*. So there's a dependency.

Sampling is heavily memory-bound. Most of the work is reading weights of the transformer for processing. So GPUs remain underutilized.

We do not need all the parameters (e.g. 100B) of a model to generate fairly easy tokens (e.g. pronouns).

## Speculative Decoding

In speculative decoding, there are two models:

1. A smaller, faster, cheaper *draft model* (e.g. meta-llama/Llama-3-8b)
2. A larger, slower *target model* (e.g. meta-llama/Meta-Llama-3-70B)

The idea behind spec decode is that the draft model generates a sequence of candidates of *K* future tokens, and the target model then decides how many of these tokens should be accepted.

## How does the algorithm work?

1. The draft model to decode a candidate sequence of K tokens in an autoregressive manner
2. Then we feed all this together to the large model
3. Then we go from left to right over the logits predicted by the model and sample tokens
4. We compare the target and draft model probabilities to determine how many of the tokens we want to keep based on some **rejection criteria/heuristics**
5. If a token is rejected, we **resample** it using a combination of the two distributions $(q(x) - p(x)_+)$ and don't accept any more tokens
6. If all the tokens are accepted, we can sample an additional final token from the target model's probability output

Instead of sampling just one single token, speculative sampling decodes 1 to *K+1* tokens. If tokens are not accepted, we resample. If all tokens are accepted, we sample a final token(already have probability distributions of the target model). So in total we get *K+1* tokens.

## Example
If the sequence is "action speaks louder than words" and K=2 then given the phrase "action speaks":

1. The draft model generates output to be "louder than" (2 tokens)
2. The target model accepts both the words, also sample a *K+1* token (final token) to be "words"

The alternative is that the target model decides only to accept "louder" and rejects the rest.

## Why does it work?

The reason this works in practice is that most of the time the tokens by draft model get accepted as they are easy(common phrases, pronouns, punctuation, etc) and the draft model can predict these faster instead having the larger model do all the work.

So as long as the draft model is faster than the target model while also the token acceptance rate is fairly high, spec decode will speedup the inference of LLMs.

Andrej Karpathy has a [tweet](https://x.com/karpathy/status/1697318534555336961) explaining spec decode.
