---
layout: default
title: Statistiques d'entrainement
description: Statistiques agrégées des séances d'entrainement mensuelles
permalink: /statistics.html
---

# Statistiques d'entrainement

{% comment %}
Filter posts that have category 'entrainement' and calculate statistics
{% endcomment %}
{% assign training_posts = site.posts | where: "category", "entrainement" %}
{% assign total_sessions = training_posts | size %}
{% assign total_distance = 0.0 %}
{% assign total_elevation = 0 %}
{% assign total_time_hours = 0 %}
{% assign total_time_minutes = 0 %}

{% comment %}
Calculate totals by iterating through training posts
{% endcomment %}
{% for post in training_posts %}
  {% if post.distance and post.distance != "" %}
    {% assign distance_value = post.distance | replace: " km", "" | replace: ",", "." | times: 1.0 %}
    {% assign total_distance = total_distance | plus: distance_value %}
  {% endif %}
  
  {% if post.elevation and post.elevation != "" %}
    {% assign elevation_value = post.elevation | replace: " m", "" | replace: ",", "" | plus: 0 %}
    {% assign total_elevation = total_elevation | plus: elevation_value %}
  {% endif %}
  
  {% if post.time and post.time != "" %}
    {% assign time_parts = post.time | replace: " h:m", "" | split: ":" %}
    {% if time_parts.size == 2 %}
      {% assign hours = time_parts[0] | plus: 0 %}
      {% assign minutes = time_parts[1] | plus: 0 %}
      {% assign total_time_hours = total_time_hours | plus: hours %}
      {% assign total_time_minutes = total_time_minutes | plus: minutes %}
    {% endif %}
  {% endif %}
{% endfor %}

{% comment %}
Convert total minutes to hours and minutes
{% endcomment %}
{% assign extra_hours = total_time_minutes | divided_by: 60 %}
{% assign final_minutes = total_time_minutes | modulo: 60 %}
{% assign final_hours = total_time_hours | plus: extra_hours %}

{% comment %}
Calculate average pace (km per hour)
{% endcomment %}
{% assign average_pace = 0.0 %}
{% assign total_time_decimal = final_hours | times: 1.0 %}
{% if final_minutes > 0 %}
  {% assign minute_fraction = final_minutes | divided_by: 60.0 %}
  {% assign total_time_decimal = total_time_decimal | plus: minute_fraction %}
{% endif %}
{% if total_time_decimal > 0 %}
  {% assign average_pace = total_distance | divided_by: total_time_decimal %}
{% endif %}

## Résumé général

<div class="grid">
  <article>
    <header><strong>Sessions totales</strong></header>
    <main>
      <h2>{{ total_sessions }}</h2>
      <p>séances d'entrainement</p>
    </main>
  </article>
  
  <article>
    <header><strong>Distance totale</strong></header>
    <main>
      <h2>{{ total_distance | round: 1 }} km</h2>
      <p>distance parcourue</p>
    </main>
  </article>
  
  <article>
    <header><strong>Dénivelé total</strong></header>
    <main>
      <h2>{{ total_elevation | number_with_delimiter: ' ' }} m</h2>
      <p>gain d'altitude</p>
    </main>
  </article>
  
  <article>
    <header><strong>Temps total</strong></header>
    <main>
      <h2>{{ final_hours }}h {{ final_minutes }}m</h2>
      <p>durée d'entrainement</p>
    </main>
  </article>
</div>

## Moyennes

{% if total_sessions > 0 %}
| Métrique | Valeur |
|----------|--------|
| Distance moyenne par session | {{ total_distance | divided_by: total_sessions | round: 1 }} km |
| Dénivelé moyen par session | {{ total_elevation | divided_by: total_sessions | round: 0 }} m |
| Durée moyenne par session | {{ final_hours | times: 60 | plus: final_minutes | divided_by: total_sessions | round: 0 }} minutes |
| Vitesse moyenne | {{ average_pace | round: 1 }} km/h |
{% else %}
<p><em>Aucune donnée d'entrainement disponible.</em></p>
{% endif %}

## Détail par mois

{% if total_sessions > 0 %}
<table>
  <thead>
    <tr>
      <th>Mois</th>
      <th>Distance</th>
      <th>Dénivelé</th>
      <th>Temps</th>
      <th>Vitesse moy.</th>
    </tr>
  </thead>
  <tbody>
    {% for post in training_posts %}
    {% assign distance_value = 0.0 %}
    {% assign elevation_value = 0 %}
    {% assign session_pace = 0.0 %}
    
    {% if post.distance and post.distance != "" %}
      {% assign distance_value = post.distance | replace: " km", "" | replace: ",", "." | times: 1.0 %}
    {% endif %}
    
    {% if post.elevation and post.elevation != "" %}
      {% assign elevation_value = post.elevation | replace: " m", "" | replace: ",", "" | plus: 0 %}
    {% endif %}
    
    {% if post.time and post.time != "" %}
      {% assign time_parts = post.time | replace: " h:m", "" | split: ":" %}
      {% if time_parts.size == 2 %}
        {% assign hours = time_parts[0] | plus: 0 %}
        {% assign minutes = time_parts[1] | plus: 0 %}
        {% assign session_time_decimal = hours | times: 1.0 %}
        {% assign session_minute_fraction = minutes | divided_by: 60.0 %}
        {% assign session_time_decimal = session_time_decimal | plus: session_minute_fraction %}
        {% if session_time_decimal > 0 and distance_value > 0 %}
          {% assign session_pace = distance_value | divided_by: session_time_decimal %}
        {% endif %}
      {% endif %}
    {% endif %}
    
    <tr>
      <td><a href="{{ post.url }}">{{ post.title | replace: "Entrainement ", "" }}</a></td>
      <td>{{ post.distance | default: "N/A" }}</td>
      <td>{{ post.elevation | default: "N/A" }}</td>
      <td>{{ post.time | default: "N/A" }}</td>
      <td>{% if session_pace > 0 %}{{ session_pace | round: 1 }} km/h{% else %}N/A{% endif %}</td>
    </tr>
    {% endfor %}
  </tbody>
</table>
{% else %}
<p><em>Aucune donnée d'entrainement disponible.</em></p>
{% endif %}

## Répartition par type d'activité

{% comment %}
Since all posts seem to mention "Course à pied + vélo + commute", 
we'll show this as the main activity type. In a real scenario,
we might need additional metadata to break this down further.
{% endcomment %}

<article>
  <header><strong>Types d'activité</strong></header>
  <main>
    <p><strong>Course à pied + vélo + commute :</strong> {{ total_sessions }} séances</p>
    <p>{{ total_distance | round: 1 }} km • {{ total_elevation | number_with_delimiter: ' ' }} m • {{ final_hours }}h {{ final_minutes }}m</p>
  </main>
</article>

---

<small>
  Dernière mise à jour : {{ site.time | date: "%d/%m/%Y à %H:%M" }}
  <br>
  Données agrégées automatiquement depuis les bilans mensuels d'entrainement.
</small>