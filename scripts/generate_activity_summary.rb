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
        min_elevation: row['min elevation(m)'].to_f,
        max_elevation: row['max elevation(m)'].to_f,
        elevation_gain: row['elevationgain(m)'].to_f,
        elevation_loss: row['elevationloss(m)'].to_f
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
      'activity_types' => activity_type_counts,
      'recent_activities' => recent_activities_list,
      'total_activities' => @activities.length,
      'total_calories' => @activities.sum { |a| a[:calories] }.round(0),
      'total_distance_km' => (@activities.sum { |a| a[:distance] } / 1000).round(1),
      'total_duration_hours' => (@activities.sum { |a| a[:duration] } / 3600).round(0),
      'total_elevation_gain_m' => @activities.sum { |a| a[:elevation_gain] }.round(0),
      'yearly_stats' => yearly_stats_original_format
    }
  end

  def activity_type_counts
    counts = {}
    @activities.group_by { |a| a[:activity] }.each do |type, activities|
      counts[type] = activities.length
    end
    counts
  end

  def recent_activities_list
    recent = @activities.sort_by { |a| a[:date] || Date.new(1900, 1, 1) }.reverse.first(20)
    recent.map do |activity|
      {
        'date' => activity[:date]&.to_s,
        'type' => activity[:activity],
        'distance' => activity[:distance].round(1),
        'duration' => activity[:duration].round(2),
        'calories' => activity[:calories].round(1),
        'elevation_gain' => activity[:elevation_gain].round(0)
      }
    end
  end

  def yearly_stats_original_format
    yearly_data = []
    @activities.group_by { |a| a[:date]&.year }.each do |year, activities|
      next if year.nil?
      
      yearly_data << {
        'year' => year.to_s,
        'count' => activities.length,
        'distance' => activities.sum { |a| a[:distance] }.round(2),
        'duration' => activities.sum { |a| a[:duration] }.round(2),
        'calories' => activities.sum { |a| a[:calories] }.round(1),
        'elevation_gain' => activities.sum { |a| a[:elevation_gain] }.round(0)
      }
    end
    # Sort by year descending
    yearly_data.sort_by { |data| -data['year'].to_i }
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
        'total_elevation_gain' => activities.sum { |a| a[:elevation_gain] }.round(2),
        'avg_duration' => (activities.sum { |a| a[:duration] } / activities.length).round(2),
        'avg_distance' => calculate_average(activities, :distance),
        'avg_calories' => calculate_average(activities, :calories),
        'avg_elevation_gain' => calculate_average(activities, :elevation_gain)
      }
    end
    
    # Sort by count descending
    summary.sort_by { |_, data| -data['count'] }.to_h
  end

  def totals_summary
    activities_with_elevation = @activities.select { |a| a[:elevation_gain] > 0 || a[:min_elevation] > 0 }
    
    {
      'duration_seconds' => @activities.sum { |a| a[:duration] }.round(2),
      'duration_hours' => (@activities.sum { |a| a[:duration] } / 3600).round(2),
      'distance_meters' => @activities.sum { |a| a[:distance] }.round(2),
      'distance_kilometers' => (@activities.sum { |a| a[:distance] } / 1000).round(2),
      'calories' => @activities.sum { |a| a[:calories] }.round(2),
      'elevation_gain_meters' => @activities.sum { |a| a[:elevation_gain] }.round(2),
      'elevation_loss_meters' => @activities.sum { |a| a[:elevation_loss] }.round(2),
      'activities_with_elevation' => activities_with_elevation.length,
      'max_elevation_in_activity' => activities_with_elevation.map { |a| a[:max_elevation] }.max&.round(2) || 0,
      'min_elevation_in_activity' => activities_with_elevation.select { |a| a[:min_elevation] > 0 }.map { |a| a[:min_elevation] }.min&.round(2) || 0
    }
  end

  def averages_summary
    activities_with_hr = @activities.select { |a| a[:avg_heartrate] > 0 }
    activities_with_elevation = @activities.select { |a| a[:elevation_gain] > 0 }
    
    {
      'duration_seconds' => calculate_average(@activities, :duration),
      'distance_meters' => calculate_average(@activities, :distance),
      'calories' => calculate_average(@activities, :calories),
      'heartrate' => activities_with_hr.empty? ? 0 : calculate_average(activities_with_hr, :avg_heartrate),
      'speed_mps' => calculate_average(@activities, :avg_speed),
      'elevation_gain_meters' => activities_with_elevation.empty? ? 0 : calculate_average(activities_with_elevation, :elevation_gain)
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
        'total_calories' => activities.sum { |a| a[:calories] }.round(2),
        'total_elevation_gain' => activities.sum { |a| a[:elevation_gain] }.round(2)
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
        'total_calories' => activities.sum { |a| a[:calories] }.round(2),
        'total_elevation_gain' => activities.sum { |a| a[:elevation_gain] }.round(2)
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
        'total_elevation_gain' => recent.sum { |a| a[:elevation_gain] }.round(2),
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