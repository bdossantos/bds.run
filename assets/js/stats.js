(function () {
  'use strict';

  var payloadEl = document.getElementById('stats-payload');
  if (!payloadEl) return;

  var data;
  try {
    data = JSON.parse(payloadEl.textContent);
  } catch (e) {
    return;
  }

  var primaryColor = getComputedStyle(document.documentElement).getPropertyValue('--pico-primary').trim() || '#1095c1';
  var textColor = getComputedStyle(document.documentElement).getPropertyValue('--pico-color').trim() || '#333';
  var gridColor = getComputedStyle(document.documentElement).getPropertyValue('--pico-muted-border-color').trim() || '#e0e0e0';

  if (window.Chart) {
    Chart.defaults.color = textColor;
    Chart.defaults.borderColor = gridColor;
  }

  // Lazily instantiate charts only once they are about to enter the viewport,
  // so below-the-fold charts don't compete with the initial page render.
  function whenVisible(el, callback) {
    if (!el) return;
    if (!('IntersectionObserver' in window)) {
      callback();
      return;
    }
    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          observer.unobserve(entry.target);
          callback();
        }
      });
    }, { rootMargin: '200px' });
    observer.observe(el);
  }

  function renderYearlyChart() {
    var el = document.getElementById('yearlyChart');
    if (!el || !window.Chart) return;
    var years = (data.yearlyStats || []).slice().reverse();
    var yearlyLabels = years.map(function (y) { return String(y.year); });
    var yearlyDistance = years.map(function (y) { return Math.round(y.distance / 1000); });
    var yearlyCount = years.map(function (y) { return y.count; });

    new Chart(el, {
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
  }

  function renderPieChart() {
    var el = document.getElementById('activityPieChart');
    if (!el || !window.Chart) return;
    var types = Object.keys(data.activityTypeDetails || {}).filter(function (key) {
      return data.activityTypeDetails[key].count > 10;
    });
    var pieLabels = types;
    var pieData = types.map(function (key) { return data.activityTypeDetails[key].count; });
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

    new Chart(el, {
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
  }

  function renderMonthlyChart() {
    var el = document.getElementById('monthlyChart');
    if (!el || !window.Chart) return;
    var monthlyTrends = data.monthlyTrends || {};
    var months = Object.keys(monthlyTrends).map(function (key) {
      return [key, monthlyTrends[key]];
    }).reverse();
    var monthlyLabels = months.map(function (m) { return m[0]; });
    var monthlyDistance = months.map(function (m) { return Math.round((m[1].total_distance / 1000) * 10) / 10; });
    var monthlyElevation = months.map(function (m) { return Math.round(m[1].total_elevation_gain); });

    new Chart(el, {
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
  }

  // Returns the current run of consecutive days (ending today or yesterday)
  // that have at least one recorded activity.
  function localDateKey(date) {
    var year = date.getFullYear();
    var month = String(date.getMonth() + 1).padStart(2, '0');
    var day = String(date.getDate()).padStart(2, '0');
    return year + '-' + month + '-' + day;
  }

  function computeCurrentStreak(dailyCounts) {
    var streak = 0;
    var day = new Date();
    day.setHours(0, 0, 0, 0);

    // Allow the streak to still count if today has no activity yet.
    var key = localDateKey(day);
    if (!dailyCounts[key]) {
      day.setDate(day.getDate() - 1);
    }

    while (true) {
      key = localDateKey(day);
      if (!dailyCounts[key]) break;
      streak += 1;
      day.setDate(day.getDate() - 1);
    }
    return streak;
  }

  function renderStreak() {
    var el = document.getElementById('streak-stat');
    var summaryEl = document.getElementById('streak-summary');
    var dailyCounts = data.dailyCounts || {};
    var streak = computeCurrentStreak(dailyCounts);
    if (el) {
      el.textContent = streak + (streak > 1 ? ' jours' : ' jour');
    }
    if (summaryEl) {
      summaryEl.textContent = 'Série de jours actifs en cours : ' + streak + (streak > 1 ? ' jours.' : ' jour.');
    }
  }

  function renderHeatmap() {
    var heatmapEl = document.getElementById('heatmap');
    if (!heatmapEl) return;
    var dailyCounts = data.dailyCounts || {};

    var today = new Date();
    var startDate = new Date(today);
    startDate.setDate(startDate.getDate() - 364);
    // Align to Monday
    var dayOfWeek = startDate.getDay();
    var mondayOffset = dayOfWeek === 0 ? -6 : 1 - dayOfWeek;
    startDate.setDate(startDate.getDate() + mondayOffset);

    var wrapper = document.createElement('div');
    wrapper.className = 'heatmap-wrapper';

    var weekDays = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    var dayLabels = document.createElement('div');
    dayLabels.className = 'heatmap-day-labels';
    for (var wd = 0; wd < 7; wd++) {
      var dayLabel = document.createElement('div');
      dayLabel.className = 'heatmap-day-label';
      dayLabel.textContent = wd % 2 === 0 ? weekDays[wd] : '';
      dayLabels.appendChild(dayLabel);
    }
    wrapper.appendChild(dayLabels);

    var current = new Date(startDate);
    while (current <= today) {
      var week = document.createElement('div');
      week.className = 'heatmap-week';
      for (var d = 0; d < 7; d++) {
        var cell = document.createElement('div');
        cell.className = 'heatmap-cell';
        if (current > today) {
          week.appendChild(cell);
        } else {
          var key = localDateKey(current);
          var count = dailyCounts[key] || 0;
          var color;
          if (count === 0) color = gridColor;
          else if (count === 1) color = 'rgba(16, 149, 193, 0.3)';
          else if (count === 2) color = 'rgba(16, 149, 193, 0.55)';
          else if (count <= 4) color = 'rgba(16, 149, 193, 0.8)';
          else color = 'rgba(16, 149, 193, 1)';
          cell.title = key + ': ' + count + ' activité(s)';
          cell.style.background = color;
          week.appendChild(cell);
        }
        current.setDate(current.getDate() + 1);
      }
      wrapper.appendChild(week);
    }

    heatmapEl.replaceChildren(wrapper);
  }

  function renderRaceMap() {
    var mapEl = document.getElementById('race-map');
    var racesData = data.races;
    if (!mapEl || !window.L || !racesData || !racesData.features) return;

    var map = L.map(mapEl).setView([46.5, 2.5], 4);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
      maxZoom: 18
    }).addTo(map);

    var bounds = [];
    var distances = racesData.features
      .map(function (f) { return f.properties['Distance (km)'] || 0; })
      .filter(function (d) { return d > 0; });
    var maxDist = Math.max.apply(null, distances) || 100;

    racesData.features.forEach(function (feature) {
      var coords = feature.geometry.coordinates;
      if (!coords || coords[0] === null || coords[1] === null) return;
      var lat = coords[1];
      var lng = coords[0];
      var props = feature.properties;
      var dist = props['Distance (km)'] || 0;
      var radius = 5 + (dist / maxDist) * 15;
      var popup = '<strong>' + (props['Race name'] || '') + '</strong><br>' +
                  (props['Date'] ? props['Date'].split(' ')[0] : '') + '<br>' +
                  (props['Distance (km)'] ? props['Distance (km)'] + ' km' : '') +
                  (props['Total elevation gain (m)'] ? ' · D+ ' + props['Total elevation gain (m)'] + 'm' : '');
      L.circleMarker([lat, lng], {
        radius: radius,
        fillColor: primaryColor,
        color: '#fff',
        weight: 2,
        opacity: 1,
        fillOpacity: 0.85
      }).addTo(map)
        .bindPopup(popup)
        .bindTooltip(props['Race name'] || '', { direction: 'top', offset: [0, -radius] });
      bounds.push([lat, lng]);
    });
    if (bounds.length > 0) {
      map.fitBounds(bounds, { padding: [30, 30] });
    }
  }

  // Above (or near) the fold: render immediately.
  renderStreak();
  renderHeatmap();

  // Below the fold: defer until each element is about to be scrolled into view.
  whenVisible(document.getElementById('yearlyChart'), renderYearlyChart);
  whenVisible(document.getElementById('activityPieChart'), renderPieChart);
  whenVisible(document.getElementById('monthlyChart'), renderMonthlyChart);
  whenVisible(document.getElementById('race-map'), renderRaceMap);
})();
