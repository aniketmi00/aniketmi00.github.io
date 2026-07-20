---
layout: page
title: Home
id: home
permalink: /
---

{% assign posts = site.notes | sort: "date" | reverse %}

<div class="intro">
  <div class="intro-name">{{ site.title }}</div>
  <p>i work on model inference systems for <a href="https://www.hbomax.com">HBO Max</a> @ <a href="https://www.wbd.com">Warner Bros. Discovery</a>. i write mostly about machine learning, systems i've built, and things i'm reading.</p>
  <div class="intro-social">
    {% include social-icons.html %}
  </div>
</div>

<hr>

<div class="section-label">writing</div>

<ul class="recent-notes">
  {% for note in posts %}
    <li>
      <span class="recent-date">{{ note.date | date: "%Y &middot; %m" }}</span>
      <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
    </li>
  {% endfor %}
</ul>
