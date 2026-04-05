#!/usr/bin/env ruby
# frozen_string_literal: true

# Simple test script to verify the activity summary generator
require_relative '../_scripts/generate_activity_summary'
require 'yaml'

puts "Testing Activity Summary Generator..."

# Test that the script can handle the actual CSV
generator = ActivitySummaryGenerator.new('_data/activities.csv', '/tmp/test_summary.yml')
summary = generator.generate

# Basic validation tests
puts "✓ Script executed successfully"

raise "Summary should not be empty" if summary.empty?
puts "✓ Summary contains data"

raise "Should have total_activities" unless summary['total_activities']
puts "✓ Contains total activities: #{summary['total_activities']}"

raise "Should have activity_types" unless summary['activity_types']
puts "✓ Contains activity types: #{summary['activity_types'].keys.join(', ')}"

raise "Should have total_distance_km" unless summary['total_distance_km']
puts "✓ Contains total distance: #{summary['total_distance_km']} km"

raise "Should have total_elevation_gain_m" unless summary['total_elevation_gain_m']
puts "✓ Contains total elevation gain: #{summary['total_elevation_gain_m']} m"

raise "Should have recent activities" unless summary['recent_activities']
puts "✓ Contains recent activities"

raise "Should have yearly stats" unless summary['yearly_stats']
puts "✓ Contains yearly stats"

# New data fields
raise "Should have activity_type_details" unless summary['activity_type_details']
puts "✓ Contains activity type details: #{summary['activity_type_details'].keys.length} types"

raise "Should have averages" unless summary['averages']
puts "✓ Contains averages: HR=#{summary['averages']['heartrate']}, speed=#{summary['averages']['speed_mps']} m/s"

raise "Should have date_range" unless summary['date_range']
puts "✓ Contains date range: #{summary['date_range']['earliest']} to #{summary['date_range']['latest']}"

raise "Should have monthly_trends" unless summary['monthly_trends']
puts "✓ Contains monthly trends: #{summary['monthly_trends'].keys.length} months"

raise "Should have personal_records" unless summary['personal_records']
puts "✓ Contains personal records: #{summary['personal_records'].keys.join(', ')}"

raise "Should have recent_summary" unless summary['recent_summary']
puts "✓ Contains recent summary (last 30 days)"

raise "Should have totals" unless summary['totals']
puts "✓ Contains totals summary"

raise "Should have daily_counts" unless summary['daily_counts']
puts "✓ Contains daily counts: #{summary['daily_counts'].keys.length} days"

# Test YAML output
yaml_content = YAML.load_file('/tmp/test_summary.yml')
raise "YAML output should match summary" unless yaml_content == summary
puts "✓ YAML output is valid and matches"

# Clean up
File.delete('/tmp/test_summary.yml')

puts "\nAll tests passed! 🎉"
puts "Generated summary for #{summary['total_activities']} activities"
puts "Total distance: #{summary['total_distance_km']} km"
puts "Total elevation gain: #{summary['total_elevation_gain_m']} m"
puts "Activity types: #{summary['activity_types'].keys.join(', ')}"