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
      <p class="meta">
        <time pubdate datetime="{{ page.date | date: '%Y-%m-%d' }}">
          {{ post.date | date: "%d/%m/%Y" }}
        </time>
         - {{ post.categories | join: ', ' }}
      </p>
    </article>
  </li>
{% endfor %}
</ul>
