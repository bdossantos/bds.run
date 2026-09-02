---
layout: default
title: Carnet d'entrainement, récits de course, etc ...
description: Carnet d'entrainement, récits de course, photos de course.
---

{% assign summary = site.data.activity_summary %}
{% if summary and summary.total_activities and summary.total_activities > 0 %}
{% assign current_year = summary.yearly_stats | first %}
<div class="stats-grid" style="margin: 1rem 0 2rem 0;">
  {% if current_year %}
  <div class="stat-card">
    <h4>{{ current_year.distance | divided_by: 1000.0 | round: 0 }} km</h4>
    <small>Parcourus en {{ current_year.year }}</small>
  </div>
  {% endif %}
  {% if summary.recent_summary.last_30_days %}
  <div class="stat-card">
    <h4>{{ summary.recent_summary.last_30_days.count }}</h4>
    <small>Activités (30 derniers jours)</small>
  </div>
  {% endif %}
  <div class="stat-card">
    <h4>{{ summary.total_activities }}</h4>
    <small>Activités depuis {{ summary.date_range.earliest | date: "%Y" }}</small>
  </div>
</div>
<p><small><a href="/stats.html">Voir toutes les statistiques d'entraînement →</a></small></p>
{% endif %}

{% for post in site.posts limit:8 %}
<section>
  <hgroup>
    <h2>
      <a itemprop="name" href="{{ post.url }}">{{ post.title }}</a>
    </h2>
    <p>
      <time pubdate datetime="{{ post.date | date: '%Y-%m-%d' }}">
        {{ post.date | date: "%d/%m/%Y" }}
      </time>
      {% for category in post.categories %}
      <span class="badge-pill">{{ category }}</span>
      {% endfor %}
    </p>
  </hgroup>
  <p>{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
</section>
{% endfor %}

<p><a href="/archives.html">Voir tous les articles →</a></p>
