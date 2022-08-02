class Daily_record
  def initialize(record)
    @daily_record = record
    @keys = @daily_record.keys
  end

  def max_temp
    if @keys.include?('Max TemperatureC')
      return [@daily_record['Max TemperatureC'].to_i,self.pkt]
    else
      return 0
    end
  end

  def min_temp
    if @keys.include?('Min TemperatureC')
      return [@daily_record['Min TemperatureC'].to_i,self.pkt]
    else
      return 0
    end
  end

  def mean_humidity
    if @keys.include?(' Mean Humidity')
      return @daily_record[' Mean Humidity'].to_i
    else
      return 0
    end
  end

  def max_humidity
    if @keys.include?('Max Humidity')
      return [@daily_record['Max Humidity'].to_i,self.pkt]
    else
      return 0
    end
  end

  def pkt
    if @keys.include?('PKST')
      return @daily_record['PKST']
    elsif @keys.include?('PKT')
      return @daily_record['PKT']
    elsif @keys.include?('GST')
      return @daily_record['GST']
    else
      return 0
    end
  end
end
