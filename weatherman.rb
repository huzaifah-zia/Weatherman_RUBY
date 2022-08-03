# frozen_string_literal: true

require 'colorize'
require 'date'
require 'csv'
require './daily_record'
require './monthly_weather'
require './yearly_weather'

# main class
class Weatherman
  def initialize(_arg)
    @path = ARGV[2].to_s
    @operation = ARGV[0].to_s
    @date = ARGV[1].to_s
    @months = Date::ABBR_MONTHNAMES.compact
  end

  def exceute
    file_name_intial = "#{@path.split('/').last}_#{@date.split('/').first}"
    month = @date.split('/')[1].to_i
    case @operation
    when '-e'
      print_yearly_stat(yearly_data) { |dat| "#{Date::ABBR_MONTHNAMES[dat.split('-')[1].to_i]} #{dat.split('-')[2]}" }

    when '-a'
      print_monthly_stat monthly_data "#{@path}#{file_name_intial}_#{@months[month]}.txt"

    when '-c'
      monthly_data("#{@path}#{file_name_intial}_#{@months[month]}.txt").print_daily_temp(@date)

    else
      puts 'Operational Command not recognized.'
    end
  end

  private

  def monthly_data(new_path)
    if File.exist?(new_path)
      data = CSV.read(new_path).delete_if { |n| n.join.nil? || n.join.empty? || n.length == 1 }
      temp_month = MonthlyWeather.new
      data.drop(1).each do |row|
        temp_month.add(DailyRecord.new(data.first.zip(row).to_h)) # converting each hash
      end
      temp_month
    else
      puts "File doesn't exist."
    end
  end

  def yearly_data
    data = YearlyWeather.new
    year = @date.split('/').first
    file_name = "#{@path}#{@path.split('/').last}_#{year}"
    @months.each do |month|
      data.add(monthly_data("#{file_name}_#{month}.txt"))
    end
    data
  end

  def print_yearly_stat(year)
    max_temp = year.yearly_max_temp
    min_temp = year.yearly_min_temp
    max_humidity = year.yearly_max_humidity
    puts "Highest: #{max_temp[0]}C on #{yield(max_temp[1])}"
    puts "Lowest: #{min_temp[0]}C on #{yield(min_temp[1])}"
    puts "Huimid: #{max_humidity[0]}% on #{yield(max_humidity[1])}"
  end

  def print_monthly_stat(month)
    puts "Highest Average: #{month.monthly_max_avg_temp}C"
    puts "Lowest Average: #{month.monthly_min_avg_temp}C"
    puts "Average Huimidity: #{month.monthly_mean_avg_humidity}%"
  end
end

weatherman = Weatherman.new(ARGV)
weatherman.exceute
