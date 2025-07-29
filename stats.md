---
layout: default
title: Statistiques d'entraînement
description: Statistiques et analyses des activités sportives
permalink: /stats.html
---

## Statistiques d'entraînement

{% assign summary = site.data.activity_summary %}

### Vue d'ensemble

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin: 2rem 0;">
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">{{ summary.total_activities }}</h4>
    <small>Activités totales</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">{{ summary.total_distance_km }} km</h4>
    <small>Distance totale</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">{{ summary.total_duration_hours }}h</h4>
    <small>Temps total</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">{{ summary.total_calories }}</h4>
    <small>Calories brûlées</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">{{ summary.total_elevation_gain_m }} m</h4>
    <small>Dénivelé total</small>
  </div>
</div>

### Répartition par type d'activité

<table>
<thead>
  <tr>
    <th>Type d'activité</th>
    <th>Nombre</th>
    <th>Pourcentage</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>🚴 Cyclisme</td>
    <td>{{ summary.activity_types.Cycling }}</td>
    <td>{{ summary.activity_types.Cycling | times: 100.0 | divided_by: summary.total_activities | round: 1 }}%</td>
  </tr>
  <tr>
    <td>🏃 Course à pied</td>
    <td>{{ summary.activity_types.Running }}</td>
    <td>{{ summary.activity_types.Running | times: 100.0 | divided_by: summary.total_activities | round: 1 }}%</td>
  </tr>
  <tr>
    <td>🚶 Marche</td>
    <td>{{ summary.activity_types.Walking }}</td>
    <td>{{ summary.activity_types.Walking | times: 100.0 | divided_by: summary.total_activities | round: 1 }}%</td>
  </tr>
  <tr>
    <td>🏋️ Musculation</td>
    <td>{{ summary.activity_types["Weight Training"] }}</td>
    <td>{{ summary.activity_types["Weight Training"] | times: 100.0 | divided_by: summary.total_activities | round: 1 }}%</td>
  </tr>
  <tr>
    <td>🏠 Sport en salle</td>
    <td>{{ summary.activity_types["Indoor Sport & Fitness"] }}</td>
    <td>{{ summary.activity_types["Indoor Sport & Fitness"] | times: 100.0 | divided_by: summary.total_activities | round: 1 }}%</td>
  </tr>
  <tr>
    <td>🥾 Randonnée</td>
    <td>{{ summary.activity_types.Hiking }}</td>
    <td>{{ summary.activity_types.Hiking | times: 100.0 | divided_by: summary.total_activities | round: 1 }}%</td>
  </tr>
  <tr>
    <td>🏊 Natation</td>
    <td>{{ summary.activity_types.Swimming }}</td>
    <td>{{ summary.activity_types.Swimming | times: 100.0 | divided_by: summary.total_activities | round: 1 }}%</td>
  </tr>
  <tr>
    <td>🏃 Autres</td>
    <td>{{ summary.activity_types.Other }}</td>
    <td>{{ summary.activity_types.Other | times: 100.0 | divided_by: summary.total_activities | round: 1 }}%</td>
  </tr>
</tbody>
</table>

### Analyse par année

<table>
<thead>
  <tr>
    <th>Année</th>
    <th>Activités</th>
    <th>Distance (km)</th>
    <th>Temps (h)</th>
    <th>Calories</th>
    <th>Dénivelé (m)</th>
  </tr>
</thead>
<tbody>
{% for yeardata in summary.yearly_stats limit: 10 %}
  {% if yeardata.count > 0 %}
  <tr>
    <td>{{ yeardata.year }}</td>
    <td>{{ yeardata.count }}</td>
    <td>{{ yeardata.distance | divided_by: 1000.0 | round: 0 }}</td>
    <td>{{ yeardata.duration | divided_by: 3600.0 | round: 0 }}</td>
    <td>{{ yeardata.calories | round: 0 }}</td>
    <td>{{ yeardata.elevation_gain | round: 0 }}</td>
  </tr>
  {% endif %}
{% endfor %}
</tbody>
</table>

<!--
### Activités récentes

<table>
<thead>
  <tr>
    <th>Date</th>
    <th>Type</th>
    <th>Distance</th>
    <th>Durée</th>
    <th>Calories</th>
  </tr>
</thead>
<tbody>
{% for activity in summary.recent_activities %}
  <tr>
    <td>{{ activity.date }}</td>
    <td>{{ activity.type }}</td>
    <td>
      {% if activity.distance > 0 %}
        {{ activity.distance | divided_by: 1000.0 | round: 1 }} km
      {% else %}
        -
      {% endif %}
    </td>
    <td>
      {% if activity.duration > 0 %}
        {{ activity.duration | divided_by: 60.0 | round: 0 }} min
      {% else %}
        -
      {% endif %}
    </td>
    <td>
      {% if activity.calories > 0 %}
        {{ activity.calories | round: 0 }}
      {% else %}
        -
      {% endif %}
    </td>
  </tr>
{% endfor %}
</tbody>
</table>

### Moyennes

{% comment %} Calculate averages based on activities with data {% endcomment %}
{% assign activities_with_distance = 0 %}
{% assign activities_with_duration = 0 %}
{% assign activities_with_calories = 0 %}

{% for activity in summary.recent_activities %}
  {% if activity.distance > 0 %}
    {% assign activities_with_distance = activities_with_distance | plus: 1 %}
  {% endif %}
  {% if activity.duration > 0 %}
    {% assign activities_with_duration = activities_with_duration | plus: 1 %}
  {% endif %}
  {% if activity.calories > 0 %}
    {% assign activities_with_calories = activities_with_calories | plus: 1 %}
  {% endif %}
{% endfor %}

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin: 2rem 0;">
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">
      {{ summary.total_distance_km | divided_by: summary.total_activities | round: 1 }} km
    </h4>
    <small>Distance moyenne</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">
      {{ summary.total_duration_hours | times: 60 | divided_by: summary.total_activities | round: 0 }} min
    </h4>
    <small>Durée moyenne</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">
      {{ summary.total_calories | divided_by: summary.total_activities | round: 0 }}
    </h4>
    <small>Calories moyennes</small>
  </div>
</div>

### Records et statistiques avancées

{% comment %} Calculate some interesting stats {% endcomment %}
{% assign years_active = summary.yearly_stats | size %}
{% assign avg_activities_per_year = summary.total_activities | divided_by: years_active %}

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin: 2rem 0;">
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">{{ years_active }}</h4>
    <small>Années d'activité</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">{{ avg_activities_per_year | round: 0 }}</h4>
    <small>Activités/an (moyenne)</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">{{ summary.total_activities | divided_by: 365 | times: years_active | round: 1 }}</h4>
    <small>Activités/semaine (moyenne)</small>
  </div>
</div>
-->

---

<small class="secondary">
Données basées sur {{ summary.total_activities }} activités enregistrées depuis 2009. Dernière mise à jour : {{ "now" | date: "%d/%m/%Y" }}.
</small>
