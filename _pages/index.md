---
layout: page
title: Home
id: home
permalink: /
---

{% assign posts = site.notes | sort: "date" | reverse %}

<div class="intro">
  <p>i'm aniket. i work on ML inference systems at warner bros. discovery, serving models in production for hbo max. i write about inference internals, how these systems actually behave under real latency and cost constraints, the things i build, and what i'm learning as i go.</p>
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
