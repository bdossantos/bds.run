---
layout: default
title: Carnet d'entrainement, récits de course, etc ...
description: Carnet d'entrainement, récits de course, photos de course.
---

<ul>
{% for post in site.posts limit:8 %}
  <li>
    <section>
      <hgroup>
        <h2>
          <a itemprop="name" href="{{ post.url }}">{{ post.title }}</a>
        </h2>
        <p>
          <time pubdate datetime="{{ page.date | date: '%Y-%m-%d' }}">
            {{ post.date | date: "%d/%m/%Y" }}
          </time>
           - {{ post.categories | join: ', ' }}
        </p>
      </hgroup>
    </section>
  </li>
{% endfor %}
</ul>
