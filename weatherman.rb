# frozen_string_literal: true

require 'colorize'
require 'date'
require 'csv'
require './daily_record'
require './monthly_weather'
require './yearly_weather'

class Weatherman
  def initialize(_arg)
    @path = ARGV[2].to_s
    @operation = ARGV[0].to_s
    @date = ARGV[1].to_s
    @file_list = Dir.entries(@path)
  end

  def clean_file_data(new_path)
    data = CSV.read(new_path)
    temp_month = MonthlyWeather.new
    data.delete_if { |n| n.join.nil? || n.join.empty? || n.length == 1 }
    data.drop(1).each do |row|
      temp_day = DailyRecord.new(data.first.zip(row).to_h) # converting each hash
      temp_month.add(temp_day)
    end
    temp_month
  end

  def monthly_data
    month = MonthlyWeather.new
    date = @date.split('/')
    date = "#{date[0]}_#{Date::ABBR_MONTHNAMES[date[1].to_i]}"
    @file_list.select! { |w| w.include? date }
    @file_list.each do |f|
      month = clean_file_data(@path + f)
    end
    month
  end

  def yearly_data
    year = YearlyWeather.new
    @file_list.select! { |w| w.include? @date }
    @file_list.each do |f|
      month = clean_file_data(@path + f)
      year.add(month)
    end
    year
  end

  def exceute
    case @operation
    when '-e'
      year = yearly_data
      puts "Highest: #{year.yearly_max_temp[0]}C on #{yield(year.yearly_max_temp[1])}"
      puts "Lowest: #{year.yearly_min_temp[0]}C on #{yield(year.yearly_min_temp[1])}"
      puts "Huimid: #{year.yearly_max_humidity[0]}% on #{yield(year.yearly_max_humidity[1])}"

    when '-a'
      month = monthly_data
      puts "Highest Average: #{month.monthly_max_avg_temp}C"
      puts "Lowest Average: #{month.monthly_min_avg_temp}C"
      puts "Average Huimidity: #{month.monthly_mean_avg_humidity}%"

    when '-c'
      month = monthly_data
      month.print_daily_temp(@date)

    else
      puts 'Operational Command not recognized.'
    end
  end
end

weatherman = Weatherman.new(ARGV)
weatherman.exceute { |dat| "#{Date::ABBR_MONTHNAMES[dat.split('-')[1].to_i]} #{dat.split('-')[2]}" }
