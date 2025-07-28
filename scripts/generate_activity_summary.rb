#!/usr/bin/env ruby
# frozen_string_literal: true

require 'csv'
require 'yaml'
require 'date'
require 'fileutils'

# Script to generate activity summary from CSV data
# Parses _data/activities.csv and generates _data/activity_summary.yml
class ActivitySummaryGenerator
  def initialize(csv_path = '_data/activities.csv', output_path = '_data/activity_summary.yml')
    @csv_path = csv_path
    @output_path = output_path
    @activities = []
  end

  def generate
    puts "Parsing activities from #{@csv_path}..."
    parse_csv
    
    puts "Generating summary statistics..."
    summary = build_summary
    
    puts "Writing summary to #{@output_path}..."
    write_yaml(summary)
    
    puts "Activity summary generated successfully!"
    summary
  end

  private

  def parse_csv
    CSV.foreach(@csv_path, headers: true) do |row|
      # Skip empty rows
      next if row['activity'].nil? || row['activity'].strip.empty?
      
      activity = {
        date: parse_date(row['local time']),
        activity: row['activity'],
        source_activity: row['source activity'],
        duration: row['duration(s)'].to_f,
        distance: row['distance(m)'].to_f,
        calories: row['calories(kcal)'].to_f,
        avg_heartrate: parse_numeric(row['avg heartrate']),
        max_heartrate: parse_numeric(row['max heartrate']),
        avg_speed: row['avg speed(m/s)'].to_f,
        elevation_gain: row['elevationgain(m)'].to_f
      }
      
      @activities << activity
    end
  end

  def parse_date(date_str)
    return nil if date_str.nil? || date_str.empty?
    
    Date.parse(date_str)
  rescue Date::Error
    nil
  end

  def parse_numeric(value)
    return 0 if value.nil? || value.empty?
    value.to_f
  end

  def build_summary
    return {} if @activities.empty?

    {
      'generated_at' => Time.now.strftime('%Y-%m-%d %H:%M:%S UTC'),
      'total_activities' => @activities.length,
      'date_range' => date_range,
      'by_activity_type' => activity_type_summary,
      'totals' => totals_summary,
      'averages' => averages_summary,
      'monthly_trends' => monthly_trends,
      'yearly_trends' => yearly_trends,
      'recent_activity' => recent_activity_summary
    }
  end

  def date_range
    dates = @activities.map { |a| a[:date] }.compact
    return {} if dates.empty?

    {
      'earliest' => dates.min.to_s,
      'latest' => dates.max.to_s,
      'span_days' => (dates.max - dates.min).to_i
    }
  end

  def activity_type_summary
    summary = {}
    
    @activities.group_by { |a| a[:activity] }.each do |type, activities|
      summary[type] = {
        'count' => activities.length,
        'total_duration' => activities.sum { |a| a[:duration] }.round(2),
        'total_distance' => activities.sum { |a| a[:distance] }.round(2),
        'total_calories' => activities.sum { |a| a[:calories] }.round(2),
        'avg_duration' => (activities.sum { |a| a[:duration] } / activities.length).round(2),
        'avg_distance' => calculate_average(activities, :distance),
        'avg_calories' => calculate_average(activities, :calories)
      }
    end
    
    # Sort by count descending
    summary.sort_by { |_, data| -data['count'] }.to_h
  end

  def totals_summary
    {
      'duration_seconds' => @activities.sum { |a| a[:duration] }.round(2),
      'duration_hours' => (@activities.sum { |a| a[:duration] } / 3600).round(2),
      'distance_meters' => @activities.sum { |a| a[:distance] }.round(2),
      'distance_kilometers' => (@activities.sum { |a| a[:distance] } / 1000).round(2),
      'calories' => @activities.sum { |a| a[:calories] }.round(2),
      'elevation_gain_meters' => @activities.sum { |a| a[:elevation_gain] }.round(2)
    }
  end

  def averages_summary
    activities_with_hr = @activities.select { |a| a[:avg_heartrate] > 0 }
    
    {
      'duration_seconds' => calculate_average(@activities, :duration),
      'distance_meters' => calculate_average(@activities, :distance),
      'calories' => calculate_average(@activities, :calories),
      'heartrate' => activities_with_hr.empty? ? 0 : calculate_average(activities_with_hr, :avg_heartrate),
      'speed_mps' => calculate_average(@activities, :avg_speed)
    }
  end

  def monthly_trends
    trends = {}
    
    @activities.group_by { |a| a[:date]&.strftime('%Y-%m') }.each do |month, activities|
      next if month.nil?
      
      trends[month] = {
        'count' => activities.length,
        'total_duration' => activities.sum { |a| a[:duration] }.round(2),
        'total_distance' => activities.sum { |a| a[:distance] }.round(2),
        'total_calories' => activities.sum { |a| a[:calories] }.round(2)
      }
    end
    
    # Sort by month descending (most recent first)
    trends.sort_by { |month, _| month }.reverse.first(12).to_h
  end

  def yearly_trends
    trends = {}
    
    @activities.group_by { |a| a[:date]&.year }.each do |year, activities|
      next if year.nil?
      
      trends[year.to_s] = {
        'count' => activities.length,
        'total_duration' => activities.sum { |a| a[:duration] }.round(2),
        'total_distance' => activities.sum { |a| a[:distance] }.round(2),
        'total_calories' => activities.sum { |a| a[:calories] }.round(2)
      }
    end
    
    # Sort by year descending
    trends.sort_by { |year, _| year }.reverse.to_h
  end

  def recent_activity_summary
    recent = @activities.select { |a| a[:date] && a[:date] >= Date.today - 30 }
    
    return {} if recent.empty?

    {
      'last_30_days' => {
        'count' => recent.length,
        'total_duration' => recent.sum { |a| a[:duration] }.round(2),
        'total_distance' => recent.sum { |a| a[:distance] }.round(2),
        'total_calories' => recent.sum { |a| a[:calories] }.round(2),
        'avg_per_day' => (recent.length / 30.0).round(2)
      }
    }
  end

  def calculate_average(activities, field)
    return 0 if activities.empty?
    
    valid_activities = activities.select { |a| a[field] > 0 }
    return 0 if valid_activities.empty?
    
    (valid_activities.sum { |a| a[field] } / valid_activities.length).round(2)
  end

  def write_yaml(summary)
    # Ensure output directory exists
    FileUtils.mkdir_p(File.dirname(@output_path))
    
    File.write(@output_path, summary.to_yaml)
  end
end

# Run the script if called directly
if __FILE__ == $PROGRAM_NAME
  # Show usage if help is requested
  if ARGV.include?('--help') || ARGV.include?('-h')
    puts <<~USAGE
      Activity Summary Generator
      
      Generates a YAML summary file from activities CSV data.
      
      Usage:
        ruby #{$PROGRAM_NAME} [csv_path] [output_path]
        
      Arguments:
        csv_path    Path to the activities CSV file (default: _data/activities.csv)
        output_path Path for the output YAML file (default: _data/activity_summary.yml)
        
      Options:
        -h, --help  Show this help message
        
      Examples:
        ruby #{$PROGRAM_NAME}
        ruby #{$PROGRAM_NAME} data/my_activities.csv data/summary.yml
        
      The generated YAML contains:
        - Total activity counts and summaries
        - Breakdown by activity type
        - Monthly and yearly trends
        - Recent activity summary (last 30 days)
        - Date range and averages
    USAGE
    exit 0
  end
  
  # Parse command line arguments
  csv_path = ARGV[0] || '_data/activities.csv'
  output_path = ARGV[1] || '_data/activity_summary.yml'
  
  # Check if CSV file exists
  unless File.exist?(csv_path)
    puts "Error: CSV file not found: #{csv_path}"
    puts "Run with --help for usage information"
    exit 1
  end
  
  generator = ActivitySummaryGenerator.new(csv_path, output_path)
  generator.generate
end