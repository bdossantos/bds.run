---
layout: default
title: Statistiques d'entraînement
description: Statistiques et analyses des activités sportives
permalink: /stats.html
---

{% assign summary = site.data.activity_summary %}

## Statistiques d'entraînement

### Vue d'ensemble

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1rem; margin: 2rem 0;">
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
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">{{ summary.date_range.span_days }}</h4>
    <small>Jours d'activité</small>
  </div>
</div>

### 30 derniers jours

{% if summary.recent_summary.last_30_days %}
{% assign last30 = summary.recent_summary.last_30_days %}
<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1rem; margin: 2rem 0;">
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">{{ last30.count }}</h4>
    <small>Activités</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">{{ last30.total_distance | divided_by: 1000.0 | round: 1 }} km</h4>
    <small>Distance</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">{{ last30.total_duration | divided_by: 3600.0 | round: 1 }}h</h4>
    <small>Temps</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">{{ last30.total_calories | round: 0 }}</h4>
    <small>Calories</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">{{ last30.avg_per_day }}</h4>
    <small>Activités/jour</small>
  </div>
</div>
{% endif %}

### Heatmap d'activité (dernière année)

<div id="heatmap" style="margin: 2rem 0;"></div>

### Progression annuelle

<div style="margin: 2rem 0;">
  <canvas id="yearlyChart" height="300"></canvas>
</div>

### Répartition par type d'activité

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin: 2rem 0; align-items: start;">
  <div>
    <canvas id="activityPieChart" height="300"></canvas>
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
  <canvas id="monthlyChart" height="250"></canvas>
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
<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin: 2rem 0;">
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
  {% assign pct_distance = current_year.distance | times: 100.0 | divided_by: previous_year.distance | round: 1 %}
  {% assign pct_count = current_year.count | times: 100.0 | divided_by: previous_year.count | round: 1 %}
  <small>Progression distance vs {{ previous_year.year }} :</small>
  <div style="background: var(--pico-background-color); border-radius: 0.25rem; overflow: hidden; height: 1.5rem; margin: 0.25rem 0;">
    <div style="background: var(--pico-primary-color); height: 100%; width: {% if pct_distance > 100 %}100{% else %}{{ pct_distance }}{% endif %}%; display: flex; align-items: center; justify-content: center;">
      <small style="color: white; font-weight: bold;">{{ pct_distance }}%</small>
    </div>
  </div>
  <small>Progression activités vs {{ previous_year.year }} :</small>
  <div style="background: var(--pico-background-color); border-radius: 0.25rem; overflow: hidden; height: 1.5rem; margin: 0.25rem 0;">
    <div style="background: var(--pico-primary-color); height: 100%; width: {% if pct_count > 100 %}100{% else %}{{ pct_count }}{% endif %}%; display: flex; align-items: center; justify-content: center;">
      <small style="color: white; font-weight: bold;">{{ pct_count }}%</small>
    </div>
  </div>
</div>
{% endif %}

### Moyennes par activité

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1rem; margin: 2rem 0;">
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">
      {{ summary.averages.distance_meters | divided_by: 1000.0 | round: 1 }} km
    </h4>
    <small>Distance moyenne</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">
      {{ summary.averages.duration_seconds | divided_by: 60.0 | round: 0 }} min
    </h4>
    <small>Durée moyenne</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">
      {{ summary.averages.calories | round: 0 }}
    </h4>
    <small>Calories moyennes</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">
      {{ summary.averages.heartrate | round: 0 }} bpm
    </h4>
    <small>FC moyenne</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">
      {{ summary.averages.speed_mps | times: 3.6 | round: 1 }} km/h
    </h4>
    <small>Vitesse moyenne</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">
      {{ summary.averages.elevation_gain_meters | round: 0 }} m
    </h4>
    <small>D+ moyen</small>
  </div>
</div>

### Records et statistiques avancées

{% assign years_active = summary.yearly_stats | size %}
{% assign total_weeks = summary.date_range.span_days | divided_by: 7.0 %}
{% assign activities_per_week = summary.total_activities | divided_by: total_weeks | round: 1 %}

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1rem; margin: 2rem 0;">
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">{{ years_active }}</h4>
    <small>Années d'activité</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">{{ summary.total_activities | divided_by: years_active | round: 0 }}</h4>
    <small>Activités/an</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">{{ activities_per_week }}</h4>
    <small>Activités/semaine</small>
  </div>
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem; text-align: center;">
    <h4 style="margin: 0 0 0.5rem 0; color: var(--pico-primary-color);">{{ summary.totals.max_elevation_in_activity }} m</h4>
    <small>Altitude max atteinte</small>
  </div>
</div>

### Records personnels

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1rem; margin: 2rem 0;">
{% for record in summary.personal_records %}
  {% assign sport = record[0] %}
  {% assign data = record[1] %}
  <div style="background: var(--pico-background-color); padding: 1rem; border-radius: 0.25rem;">
    <h5 style="margin: 0 0 0.5rem 0;">
      {% if sport == "Running" %}🏃{% elsif sport == "Trail Running" %}🏔️{% elsif sport == "Cycling" %}🚴{% elsif sport == "Walking" %}🚶{% elsif sport == "Hiking" %}🥾{% elsif sport == "Swimming" %}🏊{% endif %}
      {{ sport }}
    </h5>
    <table style="margin: 0;">
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
<div id="race-map" style="height: 400px; border-radius: 0.25rem; margin: 2rem 0; z-index: 0;"></div>

---

<small class="secondary">
Données basées sur {{ summary.total_activities }} activités enregistrées depuis {{ summary.date_range.earliest }}. Dernière mise à jour : {{ "now" | date: "%d/%m/%Y" }}.
</small>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.7/dist/chart.umd.min.js"></script>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>

<script>
(function() {
  var primaryColor = getComputedStyle(document.documentElement).getPropertyValue('--pico-primary-color').trim() || '#1095c1';
  var textColor = getComputedStyle(document.documentElement).getPropertyValue('--pico-color').trim() || '#333';
  var gridColor = getComputedStyle(document.documentElement).getPropertyValue('--pico-muted-border-color').trim() || '#e0e0e0';

  Chart.defaults.color = textColor;
  Chart.defaults.borderColor = gridColor;

  // --- Yearly Distance/Activities Bar Chart ---
  var yearlyLabels = [{% for y in summary.yearly_stats reversed %}"{{ y.year }}"{% unless forloop.last %},{% endunless %}{% endfor %}];
  var yearlyDistance = [{% for y in summary.yearly_stats reversed %}{{ y.distance | divided_by: 1000.0 | round: 0 }}{% unless forloop.last %},{% endunless %}{% endfor %}];
  var yearlyCount = [{% for y in summary.yearly_stats reversed %}{{ y.count }}{% unless forloop.last %},{% endunless %}{% endfor %}];
  var yearlyElevation = [{% for y in summary.yearly_stats reversed %}{{ y.elevation_gain | round: 0 }}{% unless forloop.last %},{% endunless %}{% endfor %}];

  new Chart(document.getElementById('yearlyChart'), {
    type: 'bar',
    data: {
      labels: yearlyLabels,
      datasets: [
        {
          label: 'Distance (km)',
          data: yearlyDistance,
          backgroundColor: 'rgba(16, 149, 193, 0.7)',
          borderColor: 'rgba(16, 149, 193, 1)',
          borderWidth: 1,
          yAxisID: 'y',
          order: 2
        },
        {
          label: 'Activités',
          data: yearlyCount,
          type: 'line',
          borderColor: 'rgba(255, 107, 53, 1)',
          backgroundColor: 'rgba(255, 107, 53, 0.1)',
          borderWidth: 2,
          pointRadius: 3,
          fill: false,
          yAxisID: 'y1',
          order: 1
        }
      ]
    },
    options: {
      responsive: true,
      interaction: { mode: 'index', intersect: false },
      plugins: { legend: { position: 'top' } },
      scales: {
        y: { type: 'linear', position: 'left', title: { display: true, text: 'Distance (km)' }, beginAtZero: true },
        y1: { type: 'linear', position: 'right', title: { display: true, text: 'Activités' }, beginAtZero: true, grid: { drawOnChartArea: false } }
      }
    }
  });

  // --- Activity Type Doughnut Chart ---
  var pieLabels = [{% for t in summary.activity_type_details %}{% if t[1].count > 10 %}"{{ t[0] }}",{% endif %}{% endfor %}];
  var pieData = [{% for t in summary.activity_type_details %}{% if t[1].count > 10 %}{{ t[1].count }},{% endif %}{% endfor %}];
  var pieColors = [
    'rgba(16, 149, 193, 0.8)',
    'rgba(255, 107, 53, 0.8)',
    'rgba(76, 175, 80, 0.8)',
    'rgba(156, 39, 176, 0.8)',
    'rgba(255, 193, 7, 0.8)',
    'rgba(0, 188, 212, 0.8)',
    'rgba(244, 67, 54, 0.8)',
    'rgba(63, 81, 181, 0.8)',
    'rgba(139, 195, 74, 0.8)',
    'rgba(255, 152, 0, 0.8)',
    'rgba(121, 85, 72, 0.8)',
    'rgba(233, 30, 99, 0.8)',
    'rgba(96, 125, 139, 0.8)',
    'rgba(205, 220, 57, 0.8)',
    'rgba(158, 158, 158, 0.8)'
  ];

  new Chart(document.getElementById('activityPieChart'), {
    type: 'doughnut',
    data: {
      labels: pieLabels,
      datasets: [{
        data: pieData,
        backgroundColor: pieColors.slice(0, pieLabels.length),
        borderWidth: 1
      }]
    },
    options: {
      responsive: true,
      plugins: {
        legend: { position: 'bottom', labels: { boxWidth: 12, padding: 8, font: { size: 11 } } }
      }
    }
  });

  // --- Monthly Trend Line Chart ---
  var monthlyLabels = [{% for m in summary.monthly_trends reversed %}"{{ m[0] }}",{% endfor %}];
  var monthlyDistance = [{% for m in summary.monthly_trends reversed %}{{ m[1].total_distance | divided_by: 1000.0 | round: 1 }},{% endfor %}];
  var monthlyCount = [{% for m in summary.monthly_trends reversed %}{{ m[1].count }},{% endfor %}];
  var monthlyElevation = [{% for m in summary.monthly_trends reversed %}{{ m[1].total_elevation_gain | round: 0 }},{% endfor %}];

  new Chart(document.getElementById('monthlyChart'), {
    type: 'line',
    data: {
      labels: monthlyLabels,
      datasets: [
        {
          label: 'Distance (km)',
          data: monthlyDistance,
          borderColor: 'rgba(16, 149, 193, 1)',
          backgroundColor: 'rgba(16, 149, 193, 0.1)',
          borderWidth: 2,
          fill: true,
          tension: 0.3,
          yAxisID: 'y'
        },
        {
          label: 'Dénivelé (m)',
          data: monthlyElevation,
          borderColor: 'rgba(76, 175, 80, 1)',
          backgroundColor: 'rgba(76, 175, 80, 0.1)',
          borderWidth: 2,
          fill: false,
          tension: 0.3,
          yAxisID: 'y1'
        }
      ]
    },
    options: {
      responsive: true,
      interaction: { mode: 'index', intersect: false },
      plugins: { legend: { position: 'top' } },
      scales: {
        y: { type: 'linear', position: 'left', title: { display: true, text: 'Distance (km)' }, beginAtZero: true },
        y1: { type: 'linear', position: 'right', title: { display: true, text: 'Dénivelé (m)' }, beginAtZero: true, grid: { drawOnChartArea: false } }
      }
    }
  });

  // --- Activity Heatmap ---
  var dailyCounts = { {% for dc in summary.daily_counts %}"{{ dc[0] }}": {{ dc[1] }}{% unless forloop.last %},{% endunless %}{% endfor %} };

  var heatmapEl = document.getElementById('heatmap');
  if (heatmapEl) {
    var today = new Date();
    var startDate = new Date(today);
    startDate.setDate(startDate.getDate() - 364);
    // Align to Monday
    var dayOfWeek = startDate.getDay();
    var mondayOffset = dayOfWeek === 0 ? -6 : 1 - dayOfWeek;
    startDate.setDate(startDate.getDate() + mondayOffset);

    var html = '<div style="display:flex;gap:1px;overflow-x:auto;">';
    var weekDays = ['L','M','M','J','V','S','D'];
    html += '<div style="display:flex;flex-direction:column;gap:1px;margin-right:4px;justify-content:space-around;">';
    for (var wd = 0; wd < 7; wd++) {
      html += '<div style="width:12px;height:12px;font-size:8px;line-height:12px;text-align:center;color:' + textColor + ';">' + (wd % 2 === 0 ? weekDays[wd] : '') + '</div>';
    }
    html += '</div>';

    var current = new Date(startDate);
    while (current <= today) {
      html += '<div style="display:flex;flex-direction:column;gap:1px;">';
      for (var d = 0; d < 7; d++) {
        if (current > today) {
          html += '<div style="width:12px;height:12px;"></div>';
        } else {
          var key = current.toISOString().slice(0, 10);
          var count = dailyCounts[key] || 0;
          var color;
          if (count === 0) color = gridColor;
          else if (count === 1) color = 'rgba(16, 149, 193, 0.3)';
          else if (count === 2) color = 'rgba(16, 149, 193, 0.55)';
          else if (count <= 4) color = 'rgba(16, 149, 193, 0.8)';
          else color = 'rgba(16, 149, 193, 1)';
          html += '<div title="' + key + ': ' + count + ' activité(s)" style="width:12px;height:12px;background:' + color + ';border-radius:2px;"></div>';
        }
        current.setDate(current.getDate() + 1);
      }
      html += '</div>';
    }
    html += '</div>';
    heatmapEl.innerHTML = html;
  }

  // --- Leaflet Race Map ---
  var racesData = {{ site.data.races | jsonify }};
  if (racesData && racesData.features && document.getElementById('race-map')) {
    var map = L.map('race-map').setView([46.5, 2.5], 4);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
      maxZoom: 18
    }).addTo(map);

    var bounds = [];
    racesData.features.forEach(function(feature) {
      var coords = feature.geometry.coordinates;
      if (!coords || coords[0] === null || coords[1] === null) return;
      var lat = coords[1];
      var lng = coords[0];
      var props = feature.properties;
      var popup = '<strong>' + (props['Race name'] || '') + '</strong><br>' +
                  (props['Date'] ? props['Date'].split(' ')[0] : '') + '<br>' +
                  (props['Distance (km)'] ? props['Distance (km)'] + ' km' : '') +
                  (props['Total elevation gain (m)'] ? ' · D+ ' + props['Total elevation gain (m)'] + 'm' : '');
      L.marker([lat, lng]).addTo(map).bindPopup(popup);
      bounds.push([lat, lng]);
    });
    if (bounds.length > 0) {
      map.fitBounds(bounds, { padding: [30, 30] });
    }
  }
})();
</script>
