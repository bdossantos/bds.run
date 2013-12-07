---
layout: default
title: Your New Jekyll Site
---

<ul id="articles">
{% for post in site.posts %}
  <li>
    <article itemprop="blogPost" itemscope itemtype="http://schema.org/BlogPosting">
      <time datetime="{{ post.date | date_to_xmlschema }}">
        {{ post.date | date_to_string }}
      </time>
      <h2>
        <a itemprop="name" href="{{ post.url }}">{{ post.title }}</a>
      </h2>
    </article>
  </li>
{% endfor %}
</ul>
