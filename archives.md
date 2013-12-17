---
layout: default
title: Archives
description: Les archives du blog
---

## Archives
{% assign year = 2013 %}
{% for post in site.posts %}
  {% capture thisyear %}
    {{ post.date | date: '%Y' }}
  {% endcapture %}
  {% if year != thisyear %}
    {% assign year=thisyear %}
<h3> {{ thisyear }}</h3>
  {% endif %}
* [{{ post.title }}]({{ post.url }})
{% endfor %}
