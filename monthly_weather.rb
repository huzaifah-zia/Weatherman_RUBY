# frozen_string_literal: true

require 'date'
class MonthlyWeather
  def initialize
    @monthly_record = []
    @count = 0
  end

  def add(record)
    @monthly_record << record
    @count += 1
  end

  def monthly_max_temp
    max = @monthly_record.first.max_temp[0]
    date = @monthly_record.first.max_temp[1]
    @monthly_record.each do |day|
      if max < day.max_temp[0]
        max = day.max_temp[0]
        date = day.max_temp[1]
      end
    end
    [max, date]
  end

  def monthly_min_temp
    min = @monthly_record.first.min_temp[0]
    date = @monthly_record.first.min_temp[1]
    @monthly_record.each do |day|
      if min > day.min_temp[0]
        min = day.min_temp[0]
        date = day.min_temp[1]
      end
    end
    [min, date]
  end

  def monthly_max_humidity
    max = @monthly_record.first.max_humidity[0]
    date = @monthly_record.first.max_humidity[1]
    @monthly_record.each do |day|
      if max < day.max_humidity[0]
        max = day.max_humidity[0]
        date = day.max_humidity[1]
      end
    end
    [max, date]
  end

  def monthly_max_avg_temp
    sum_max = 0
    @monthly_record.each do |day|
      sum_max += day.max_temp[0]
    end
    (sum_max / @count).to_f
  end

  def monthly_min_avg_temp
    sum_min = 0
    @monthly_record.each do |day|
      sum_min += day.min_temp[0]
    end
    (sum_min / @count).to_f
  end

  def monthly_mean_avg_humidity
    sum_mean = 0
    @monthly_record.each do |day|
      sum_mean += day.mean_humidity
    end

    (sum_mean / @count).to_f
  end

  def print_daily_temp(date)
    puts "#{Date::ABBR_MONTHNAMES[date.split('/')[1].to_i]} #{date.split('/')[0]}"
    @monthly_record.each do |day|
      print "#{day.pkt.split('-')[2]} "
      day.max_temp[0].times { print '+'.blue }
      day.min_temp[0].times { print '+'.red }
      puts " #{day.min_temp[0]}C - #{day.max_temp[0]}C"
    end
  end
end
