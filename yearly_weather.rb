# frozen_string_literal: true

class YearlyWeather
  def initialize
    @yearly_record = []
    @count = 0
  end

  def add(record)
    @yearly_record << record
    @count += 1
  end

  def yearly_max_temp
    max = @yearly_record.first.monthly_max_temp[0]
    date = @yearly_record.first.monthly_max_temp[1]
    @yearly_record.each do |month|
      if max < month.monthly_max_temp[0]
        max = month.monthly_max_temp[0]
        date = month.monthly_max_temp[1]
      end
    end
    [max, date]
  end

  def yearly_min_temp
    min = @yearly_record.first.monthly_min_temp[0]
    date = @yearly_record.first.monthly_min_temp[1]
    @yearly_record.each do |month|
      if min < month.monthly_min_temp[0]
        min = month.monthly_min_temp[0]
        date = month.monthly_min_temp[1]
      end
    end
    [min, date]
  end

  def yearly_max_humidity
    max = @yearly_record.first.monthly_max_humidity[0]
    date = @yearly_record.first.monthly_max_humidity[1]
    @yearly_record.each do |month|
      if max < month.monthly_max_humidity[0]
        max = month.monthly_max_humidity[0]
        date = month.monthly_max_humidity[1]
      end
    end
    [max, date]
  end
end
