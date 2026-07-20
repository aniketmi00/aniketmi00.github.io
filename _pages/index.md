---
layout: page
title: Home
id: home
permalink: /
---

<strong>Writing</strong>

<ul class="recent-notes">
  {% assign posts = site.notes | sort: "date" | reverse %}
  {% for note in posts %}
    <li>
      <span class="recent-date">{{ note.date | date: "%Y &middot; %m" }}</span>
      <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
    </li>
  {% endfor %}
</ul>
