---
layout: default
title: Photos/photos.html
description: Mes photos
permalink: /photos.html
---

<ul>
  {% for album in site.photos %}
    <li>
      <h2>{{ album.title }}</h2>

      <a href="{{ album.url }}">
        <img
          data-src="{{ album.cover | asset:'@path @magick:quality=90' }}"
          src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=="
          class='ctr img-thumbnail'
          onload="lzld(this)">
      </a>
    </li>
  {% endfor %}
</ul>
