# Activity Summary Generator

This Ruby script generates a comprehensive YAML summary from activities CSV data, providing meaningful insights and statistics for fitness tracking.

## Features

- **Activity Type Analysis**: Counts, totals, and averages by activity type (Running, Cycling, Walking, etc.)
- **Temporal Trends**: Monthly and yearly activity patterns
- **Comprehensive Totals**: Duration, distance, calories, elevation gain
- **Recent Activity**: Last 30 days summary
- **Performance Averages**: Speed, heart rate, and other metrics

## Usage

### Basic Usage
```bash
ruby scripts/generate_activity_summary.rb
```

### Custom Paths
```bash
ruby scripts/generate_activity_summary.rb data/activities.csv output/summary.yml
```

### Help
```bash
ruby scripts/generate_activity_summary.rb --help
```

## Integration with Build Process

The script can be integrated with the Jekyll build process using the provided Rake task:

```bash
rake generate_activity_summary
```

## Output Format

The generated YAML file (`_data/activity_summary.yml`) contains:

```yaml
generated_at: "2025-07-28 20:50:30 UTC"
total_activities: 6916
date_range:
  earliest: "2009-02-07"
  latest: "2025-07-28"
  span_days: 6015
by_activity_type:
  Cycling:
    count: 2936
    total_duration: 6881814.59
    total_distance: 38732841.35
    total_calories: 796507.0
    avg_duration: 2343.94
    avg_distance: 13219.4
    avg_calories: 292.62
  # ... more activity types
totals:
  duration_hours: 4084.75
  distance_kilometers: 58239.12
  calories: 2372545.0
  elevation_gain_meters: 1234567.0
monthly_trends:
  "2025-07": { count: 72, total_duration: 150718.12, ... }
  # ... more months
recent_activity:
  last_30_days:
    count: 72
    avg_per_day: 2.4
    # ... more stats
```

## Input CSV Format

The script expects a CSV file with the following columns:
- `local time`: Activity timestamp
- `activity`: Activity type (Running, Cycling, etc.)
- `duration(s)`: Duration in seconds
- `distance(m)`: Distance in meters
- `calories(kcal)`: Calories burned
- `avg heartrate`: Average heart rate
- `avg speed(m/s)`: Average speed
- `elevationgain(m)`: Elevation gain in meters

## Requirements

- Ruby 3.0+
- Standard library modules: CSV, YAML, Date, FileUtils

No additional gems required.

## Error Handling

- Gracefully handles missing or invalid data
- Validates CSV file existence
- Provides helpful error messages
- Continues processing despite individual row errors

## Testing

Run the test suite:
```bash
ruby scripts/test_activity_summary.rb
```