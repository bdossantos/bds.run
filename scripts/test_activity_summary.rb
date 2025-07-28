#!/usr/bin/env ruby
# frozen_string_literal: true

# Simple test script to verify the activity summary generator
require_relative '../scripts/generate_activity_summary'
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

raise "Should have by_activity_type" unless summary['by_activity_type']
puts "✓ Contains activity types: #{summary['by_activity_type'].keys.join(', ')}"

raise "Should have totals" unless summary['totals']
puts "✓ Contains totals"

raise "Should have recent activity" unless summary['recent_activity']
puts "✓ Contains recent activity"

# Test YAML output
yaml_content = YAML.load_file('/tmp/test_summary.yml')
raise "YAML output should match summary" unless yaml_content == summary
puts "✓ YAML output is valid and matches"

# Clean up
File.delete('/tmp/test_summary.yml')

puts "\nAll tests passed! 🎉"
puts "Generated summary for #{summary['total_activities']} activities"
puts "Date range: #{summary['date_range']['earliest']} to #{summary['date_range']['latest']}"
puts "Activity types: #{summary['by_activity_type'].keys.join(', ')}"