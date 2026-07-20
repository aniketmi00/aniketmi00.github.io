---
layout: page
title: Home
id: home
permalink: /
---

{% assign posts = site.notes | sort: "date" | reverse %}
{% assign latest = posts | first %}

<div class="section-label">Latest</div>

<div class="latest">
  <a class="latest-title internal-link" href="{{ site.baseurl }}{{ latest.url }}">{{ latest.title }}</a>
  <div class="latest-meta">{{ latest.date | date: "%B %-d, %Y" }}</div>
  <p class="latest-excerpt">{{ latest.content | strip_html | strip_newlines | truncatewords: 28 }} <a class="internal-link" href="{{ site.baseurl }}{{ latest.url }}">Keep reading &rarr;</a></p>
</div>

<hr>

<div class="section-label">Writing</div>

<ul class="recent-notes">
  {% for note in posts %}
    <li>
      <span class="recent-date">{{ note.date | date: "%Y &middot; %m" }}</span>
      <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
    </li>
  {% endfor %}
</ul>
