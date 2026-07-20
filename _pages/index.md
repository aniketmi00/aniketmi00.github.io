---
layout: page
title: Home
id: home
permalink: /
---

# Aniket Mishrikotkar

I build software and write about systems, tools, and ideas. This is my digital
garden — a set of notes I tend over time rather than a stream of dated posts.
Start with [[welcome]].

<strong>Recently updated</strong>

<ul class="recent-notes">
  {% assign recent_notes = site.notes | sort: "last_modified_at_timestamp" | reverse %}
  {% for note in recent_notes limit: 8 %}
    <li>
      <span class="recent-date">{{ note.last_modified_at | date: "%Y-%m-%d" }}</span>
      <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
    </li>
  {% endfor %}
</ul>
