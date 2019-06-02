---
layout: default
title: Stats
description: En chiffre
permalink: /stats.html
---

## En chiffre

### Durée

#### {{ site.data.stats.totals.elapsed_time | divided_by: 3600 | round }} h

🏃 <progress max="{{ site.data.stats.totals.elapsed_time | divided_by: 3600 | round }}" value="{{ site.data.stats.all_run_totals.elapsed_time | divided_by: 3600 | round }}"></progress> {{ site.data.stats.all_run_totals.elapsed_time | divided_by: 3600 | round }} h

🚴 <progress max="{{ site.data.stats.totals.elapsed_time | divided_by: 3600 | round }}" value="{{ site.data.stats.all_ride_totals.elapsed_time | divided_by: 3600 | round }}"></progress> {{ site.data.stats.all_ride_totals.elapsed_time | divided_by: 3600 | round }} h

### Distance

#### {{ site.data.stats.totals.distance | divided_by: 1000 | round }} km

🏃 <progress max="{{ site.data.stats.totals.distance | divided_by: 1000 | round }}" value="{{ site.data.stats.all_run_totals.distance | divided_by: 1000 | round }}"></progress> {{ site.data.stats.all_run_totals.distance | divided_by: 1000 | round }} km

🚴 <progress max="{{ site.data.stats.totals.distance | divided_by: 1000 | round }}" value="{{ site.data.stats.all_ride_totals.distance | divided_by: 1000 | round }}"></progress> {{ site.data.stats.all_ride_totals.distance | divided_by: 1000 | round }} km

### Gain d'altitude

#### {{ site.data.stats.totals.elevation_gain }} m

🏃 <progress max="{{ site.data.stats.totals.elevation_gain }}" value="{{ site.data.stats.all_run_totals.elevation_gain }}"></progress> {{ site.data.stats.all_run_totals.elevation_gain }} m

🚴 <progress max="{{ site.data.stats.totals.elevation_gain }}" value="{{ site.data.stats.all_ride_totals.elevation_gain }}"></progress> {{ site.data.stats.all_ride_totals.elevation_gain }} m
