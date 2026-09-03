---
layout: default
title: Statistiques d'entraînement
description: Statistiques et analyses des activités sportives
permalink: /stats.html
---

{% assign summary = site.data.activity_summary %}

## Statistiques d'entraînement

{% if summary and summary.total_activities and summary.total_activities > 0 %}

{% assign latest_epoch = summary.date_range.latest | date: "%s" %}
{% assign now_epoch = "now" | date: "%s" %}
{% assign days_since_last = now_epoch | minus: latest_epoch | divided_by: 86400 %}

<small class="secondary">
{% if days_since_last == 0 %}Dernière activité aujourd'hui{% elsif days_since_last == 1 %}Dernière activité hier{% else %}Dernière activité il y a {{ days_since_last }} jours{% endif %}
({{ summary.date_range.latest | date: "%d/%m/%Y" }})
</small>

### Vue d'ensemble

<div class="stats-grid">
  <div class="stat-card">
    <h4>{{ summary.total_activities }}</h4>
    <small>Activités totales</small>
  </div>
  <div class="stat-card">
    <h4>{{ summary.total_distance_km }} km</h4>
    <small>Distance totale</small>
  </div>
  <div class="stat-card">
    <h4>{{ summary.total_duration_hours }}h</h4>
    <small>Temps total</small>
  </div>
  <div class="stat-card">
    <h4>{{ summary.total_calories }}</h4>
    <small>Calories brûlées</small>
  </div>
  <div class="stat-card">
    <h4>{{ summary.total_elevation_gain_m }} m</h4>
    <small>Dénivelé total</small>
  </div>
  <div class="stat-card">
    <h4>{{ summary.date_range.span_days }}</h4>
    <small>Jours d'activité</small>
  </div>
  <div class="stat-card">
    <h4 id="streak-stat">–</h4>
    <small>Série de jours actifs en cours</small>
  </div>
</div>

### 🌍 Tour du monde

{% assign cycling_km = 0 %}
{% assign foot_km = 0 %}
{% assign earth_circumference_km = 40075.0 %}
{% assign cycling_types = "Cycling,Virtual Cycling,Gravel Cycling,Indoor Cycling" | split: "," %}
{% assign foot_types = "Running,Trail Running,Treadmill Running,Walking,Hiking" | split: "," %}
{% for type in summary.activity_type_details %}
  {% if cycling_types contains type[0] %}
    {% assign cycling_km = cycling_km | plus: type[1].total_distance %}
  {% endif %}
  {% if foot_types contains type[0] %}
    {% assign foot_km = foot_km | plus: type[1].total_distance %}
  {% endif %}
{% endfor %}
{% assign cycling_km = cycling_km | divided_by: 1000.0 | round: 0 %}
{% assign foot_km = foot_km | divided_by: 1000.0 | round: 0 %}
{% assign total_laps = summary.total_distance_km | times: 1.0 | divided_by: earth_circumference_km | round: 2 %}
{% assign cycling_laps = cycling_km | times: 1.0 | divided_by: earth_circumference_km | round: 2 %}
{% assign foot_laps = foot_km | times: 1.0 | divided_by: earth_circumference_km | round: 2 %}

<div class="stats-grid stats-grid-wide">
  <div class="stat-card">
    <h4>{{ total_laps }}x 🌍</h4>
    <small>Tour(s) de la Terre au total</small>
    <div style="margin-top: 0.5rem;">
      {% assign total_laps_int = total_laps | floor %}
      {% assign total_pct = total_laps | minus: total_laps_int | times: 100 | round: 0 %}
      <div class="progress-track">
        <div class="progress-fill" style="width: {{ total_pct }}%;"></div>
      </div>
      <small style="color: var(--pico-muted-color);">{{ total_pct }}% vers le prochain tour · {{ summary.total_distance_km }} km</small>
    </div>
  </div>
  <div class="stat-card">
    <h4>{{ cycling_laps }}x 🚴</h4>
    <small>Tour(s) de la Terre en vélo</small>
    <div style="margin-top: 0.5rem;">
      {% assign cycling_laps_int = cycling_laps | floor %}
      {% assign cycling_pct = cycling_laps | minus: cycling_laps_int | times: 100 | round: 0 %}
      <div class="progress-track">
        <div class="progress-fill" style="width: {{ cycling_pct }}%;"></div>
      </div>
      <small style="color: var(--pico-muted-color);">{{ cycling_pct }}% vers le prochain tour · {{ cycling_km }} km</small>
    </div>
  </div>
  <div class="stat-card">
    <h4>{{ foot_laps }}x 🏃</h4>
    <small>Tour(s) de la Terre à pied</small>
    <div style="margin-top: 0.5rem;">
      {% assign foot_laps_int = foot_laps | floor %}
      {% assign foot_pct = foot_laps | minus: foot_laps_int | times: 100 | round: 0 %}
      <div class="progress-track">
        <div class="progress-fill" style="width: {{ foot_pct }}%;"></div>
      </div>
      <small style="color: var(--pico-muted-color);">{{ foot_pct }}% vers le prochain tour · {{ foot_km }} km</small>
    </div>
  </div>
</div>

### 30 derniers jours

{% if summary.recent_summary.last_30_days %}
{% assign last30 = summary.recent_summary.last_30_days %}
<div class="stats-grid">
  <div class="stat-card">
    <h4>{{ last30.count }}</h4>
    <small>Activités</small>
  </div>
  <div class="stat-card">
    <h4>{{ last30.total_distance | divided_by: 1000.0 | round: 1 }} km</h4>
    <small>Distance</small>
  </div>
  <div class="stat-card">
    <h4>{{ last30.total_duration | divided_by: 3600.0 | round: 1 }}h</h4>
    <small>Temps</small>
  </div>
  <div class="stat-card">
    <h4>{{ last30.total_calories | round: 0 }}</h4>
    <small>Calories</small>
  </div>
  <div class="stat-card">
    <h4>{{ last30.avg_per_day }}</h4>
    <small>Activités/jour</small>
  </div>
</div>
{% endif %}

### Heatmap d'activité (dernière année)

<div id="heatmap" role="img" aria-label="Heatmap des activités quotidiennes sur les 365 derniers jours" style="margin: 2rem 0;"></div>
<p id="streak-summary" class="visually-hidden"></p>

### Progression annuelle

<div style="margin: 2rem 0;">
  <canvas id="yearlyChart" height="300" role="img" aria-label="Graphique de la distance et du nombre d'activités par année"></canvas>
</div>

### Répartition par type d'activité

<div class="stats-grid-2col">
  <div>
    <canvas id="activityPieChart" height="300" role="img" aria-label="Répartition du nombre d'activités par type"></canvas>
  </div>
  <div>
    <table>
    <thead>
      <tr>
        <th>Type</th>
        <th>Nombre</th>
        <th>%</th>
      </tr>
    </thead>
    <tbody>
    {% assign sorted_types = summary.activity_type_details %}
    {% for type in sorted_types %}
      {% if type[1].count > 10 %}
      <tr>
        <td>{{ type[0] }}</td>
        <td>{{ type[1].count }}</td>
        <td>{{ type[1].count | times: 100.0 | divided_by: summary.total_activities | round: 1 }}%</td>
      </tr>
      {% endif %}
    {% endfor %}
    </tbody>
    </table>
  </div>
</div>

### Tendance mensuelle (12 derniers mois)

<div style="margin: 2rem 0;">
  <canvas id="monthlyChart" height="250" role="img" aria-label="Tendance mensuelle de la distance et du dénivelé"></canvas>
</div>

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
{% for yeardata in summary.yearly_stats %}
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

### Progression année en cours

{% assign current_year = summary.yearly_stats | first %}
{% assign previous_year = summary.yearly_stats[1] %}

{% if current_year and previous_year %}
<div class="stats-grid-2col">
  <div>
    <h5>{{ current_year.year }} (en cours)</h5>
    <table>
      <tr><td>Activités</td><td><strong>{{ current_year.count }}</strong></td></tr>
      <tr><td>Distance</td><td><strong>{{ current_year.distance | divided_by: 1000.0 | round: 0 }} km</strong></td></tr>
      <tr><td>Temps</td><td><strong>{{ current_year.duration | divided_by: 3600.0 | round: 0 }}h</strong></td></tr>
      <tr><td>Dénivelé</td><td><strong>{{ current_year.elevation_gain | round: 0 }} m</strong></td></tr>
    </table>
  </div>
  <div>
    <h5>{{ previous_year.year }} (complet)</h5>
    <table>
      <tr><td>Activités</td><td><strong>{{ previous_year.count }}</strong></td></tr>
      <tr><td>Distance</td><td><strong>{{ previous_year.distance | divided_by: 1000.0 | round: 0 }} km</strong></td></tr>
      <tr><td>Temps</td><td><strong>{{ previous_year.duration | divided_by: 3600.0 | round: 0 }}h</strong></td></tr>
      <tr><td>Dénivelé</td><td><strong>{{ previous_year.elevation_gain | round: 0 }} m</strong></td></tr>
    </table>
  </div>
</div>

<div style="margin: 1rem 0;">
  {% if previous_year.distance and previous_year.distance > 0 %}
  {% assign pct_distance = current_year.distance | times: 100.0 | divided_by: previous_year.distance | round: 1 %}
  <small>Progression distance vs {{ previous_year.year }} :</small>
  <div class="progress-track progress-track-lg">
    <div class="progress-fill progress-fill-label" style="width: {% if pct_distance > 100 %}100{% else %}{{ pct_distance }}{% endif %}%;">
      <small>{{ pct_distance }}%</small>
    </div>
  </div>
  {% endif %}
  {% if previous_year.count and previous_year.count > 0 %}
  {% assign pct_count = current_year.count | times: 100.0 | divided_by: previous_year.count | round: 1 %}
  <small>Progression activités vs {{ previous_year.year }} :</small>
  <div class="progress-track progress-track-lg">
    <div class="progress-fill progress-fill-label" style="width: {% if pct_count > 100 %}100{% else %}{{ pct_count }}{% endif %}%;">
      <small>{{ pct_count }}%</small>
    </div>
  </div>
  {% endif %}
</div>
{% endif %}

### Moyennes par activité

<div class="stats-grid">
  <div class="stat-card">
    <h4>{{ summary.averages.distance_meters | divided_by: 1000.0 | round: 1 }} km</h4>
    <small>Distance moyenne</small>
  </div>
  <div class="stat-card">
    <h4>{{ summary.averages.duration_seconds | divided_by: 60.0 | round: 0 }} min</h4>
    <small>Durée moyenne</small>
  </div>
  <div class="stat-card">
    <h4>{{ summary.averages.calories | round: 0 }}</h4>
    <small>Calories moyennes</small>
  </div>
  <div class="stat-card">
    <h4>{{ summary.averages.heartrate | round: 0 }} bpm</h4>
    <small>FC moyenne</small>
  </div>
  <div class="stat-card">
    <h4>{{ summary.averages.speed_mps | times: 3.6 | round: 1 }} km/h</h4>
    <small>Vitesse moyenne</small>
  </div>
  <div class="stat-card">
    <h4>{{ summary.averages.elevation_gain_meters | round: 0 }} m</h4>
    <small>D+ moyen</small>
  </div>
</div>

### Records et statistiques avancées

{% assign years_active = summary.yearly_stats | size %}

<div class="stats-grid">
  <div class="stat-card">
    <h4>{{ years_active }}</h4>
    <small>Années d'activité</small>
  </div>
  {% if years_active > 0 %}
  <div class="stat-card">
    <h4>{{ summary.total_activities | divided_by: years_active | round: 0 }}</h4>
    <small>Activités/an</small>
  </div>
  {% endif %}
  {% if summary.date_range.span_days and summary.date_range.span_days > 0 %}
  {% assign total_weeks = summary.date_range.span_days | divided_by: 7.0 %}
  {% assign activities_per_week = summary.total_activities | divided_by: total_weeks | round: 1 %}
  <div class="stat-card">
    <h4>{{ activities_per_week }}</h4>
    <small>Activités/semaine</small>
  </div>
  {% endif %}
  <div class="stat-card">
    <h4>{{ summary.totals.max_elevation_in_activity }} m</h4>
    <small>Altitude max atteinte</small>
  </div>
</div>

### Records personnels

<div class="stats-grid stats-grid-records">
{% for record in summary.personal_records %}
  {% assign sport = record[0] %}
  {% assign data = record[1] %}
  <div class="stat-card stat-card-left">
    <h5>
      {% if sport == "Running" %}🏃{% elsif sport == "Trail Running" %}🏔️{% elsif sport == "Cycling" %}🚴{% elsif sport == "Walking" %}🚶{% elsif sport == "Hiking" %}🥾{% elsif sport == "Swimming" %}🏊{% endif %}
      {{ sport }}
    </h5>
    <table>
      {% if data.longest_distance_km %}
        <tr><td><small>Plus longue distance</small></td><td><strong>{{ data.longest_distance_km }} km</strong> <small>({{ data.longest_distance_date }})</small></td></tr>
      {% endif %}
      {% if data.longest_duration_hours %}
        <tr><td><small>Plus longue durée</small></td><td><strong>{{ data.longest_duration_hours }}h</strong> <small>({{ data.longest_duration_date }})</small></td></tr>
      {% endif %}
      {% if data.max_elevation_gain_m %}
        <tr><td><small>Plus grand dénivelé</small></td><td><strong>{{ data.max_elevation_gain_m }} m</strong> <small>({{ data.max_elevation_gain_date }})</small></td></tr>
      {% endif %}
      {% if data.fastest_avg_speed_kmh %}
        <tr><td><small>Vitesse moy. max</small></td><td><strong>{{ data.fastest_avg_speed_kmh }} km/h</strong> <small>({{ data.fastest_avg_speed_date }})</small></td></tr>
      {% endif %}
    </table>
  </div>
{% endfor %}
</div>

### Carte des courses

<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />
<div id="race-map" role="region" aria-label="Carte des courses effectuées" style="height: 400px; border-radius: 0.25rem; margin: 2rem 0; z-index: 0;"></div>

---

<small class="secondary">
Données basées sur {{ summary.total_activities }} activités enregistrées depuis {{ summary.date_range.earliest }}. Dernière mise à jour : {{ "now" | date: "%d/%m/%Y" }}.
</small>

{% else %}

<p>Aucune donnée d'activité disponible pour le moment.</p>

{% endif %}

<script id="stats-payload" type="application/json">
{
  "yearlyStats": {{ summary.yearly_stats | jsonify }},
  "activityTypeDetails": {{ summary.activity_type_details | jsonify }},
  "monthlyTrends": {{ summary.monthly_trends | jsonify }},
  "dailyCounts": {{ summary.daily_counts | jsonify }},
  "races": {{ site.data.races | jsonify }}
}
</script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.7/dist/chart.umd.min.js" defer></script>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin="" defer></script>
<script src="/assets/js/stats.js" defer></script>
