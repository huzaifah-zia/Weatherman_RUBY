# frozen_string_literal: true

# Daily weather record class
class DailyRecord
  def initialize(record)
    @daily_record = record
    @keys = @daily_record.keys
  end

  def max_temp
    if @keys.include?('Max TemperatureC')
      [@daily_record['Max TemperatureC'].to_i, pkt]
    else
      0
    end
  end

  def min_temp
    if @keys.include?('Min TemperatureC')
      [@daily_record['Min TemperatureC'].to_i, pkt]
    else
      0
    end
  end

  def mean_humidity
    if @keys.include?(' Mean Humidity')
      @daily_record[' Mean Humidity'].to_i
    else
      0
    end
  end

  def max_humidity
    if @keys.include?('Max Humidity')
      [@daily_record['Max Humidity'].to_i, pkt]
    else
      0
    end
  end

  def pkt
    if @keys.include?('PKST')
      @daily_record['PKST']
    elsif @keys.include?('PKT')
      @daily_record['PKT']
    elsif @keys.include?('GST')
      @daily_record['GST']
    else
      0
    end
  end
end
