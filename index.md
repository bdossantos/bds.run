---
layout: default
title: Carnet d'entrainement, récits de course, etc ...
description:
---

<ul id="articles">
{% for post in site.posts limit:8 %}
  <li>
    <article itemprop="blogPost" itemscope itemtype="http://schema.org/BlogPosting">
      <h2>
        <a itemprop="name" href="{{ post.url }}">{{ post.title }}</a>
      </h2>
      <time pubdate datetime="{{ post.date | date_to_xmlschema }}" class="quiet">
        {{ post.date | date_to_string }}
      </time>
    </article>
  </li>
{% endfor %}
</ul>
