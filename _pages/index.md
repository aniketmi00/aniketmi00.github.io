---
layout: page
title: Home
id: home
permalink: /
---

{% assign posts = site.notes | sort: "date" | reverse %}

{% assign featured_slugs = "high-performance-llm-serving,crash-course-on-cuda,speculative-decoding,under-the-hood-of-torchcompile,distributed-model-training" | split: "," %}

<div class="intro">
  <p>I'm Aniket. I work on model inference systems for <a href="https://www.hbomax.com">HBO Max</a> @ <a href="https://www.wbd.com">Warner Bros. Discovery</a>. I write about machine learning, systems I've built, and things I'm reading.</p>
  <div class="intro-social">
    {% include social-icons.html %}
  </div>
</div>

<hr>

<div class="section-label">Featured</div>

{% for slug in featured_slugs %}
  {% assign note = posts | where: "slug", slug | first %}
  {% if note %}
  <div class="latest">
    <a class="latest-title internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
    <div class="latest-meta">{{ note.date | date: "%B %Y" }}</div>
    <p class="latest-excerpt">
      {% case note.slug %}
      {% when "high-performance-llm-serving" %}Notes from a GPU optimization workshop on quantization, latency budgets, and what it takes to serve LLMs at scale.
      {% when "crash-course-on-cuda" %}How GPUs are actually organized under the hood, and where the real performance ceiling for PyTorch comes from.
      {% when "speculative-decoding" %}Why autoregressive sampling is memory-bound, and how guessing future tokens ahead of time speeds up inference.
      {% when "under-the-hood-of-torchcompile" %}The three steps torch.compile takes to turn eager PyTorch into compiled graph execution.
      {% when "distributed-model-training" %}Model parallelism vs. data parallelism, and when it's actually time to reach for distributed training.
      {% endcase %}
    </p>
  </div>
  {% endif %}
{% endfor %}

<hr>

<div class="section-label">All notes</div>

<ul class="recent-notes">
  {% for note in posts %}
    <li>
      <span class="recent-date">{{ note.date | date: "%Y &middot; %m" }}</span>
      <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
    </li>
  {% endfor %}
</ul>
