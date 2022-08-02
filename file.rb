class File_record
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
    @monthly_record.each { |day|
      if max < day.max_temp[0]
        max = day.max_temp[0]
        date = day.max_temp[1]
      end
    }
    return [max, date]
  end

  def monthly_min_temp
    min = @monthly_record.first.min_temp[0]
    date = @monthly_record.first.min_temp[1]
    @monthly_record.each { |day|
      if min > day.min_temp[0]
        min = day.min_temp[0]
        date = day.min_temp[1]
      end
    }
    return [min, date]
  end

  def monthly_max_humidity
    max = @monthly_record.first.max_humidity[0]
    date = @monthly_record.first.max_humidity[1]
    @monthly_record.each { |day|
      if max < day.max_humidity[0]
        max = day.max_humidity[0]
        date = day.max_humidity[1]
      end
    }
    return [max, date]
  end

  def monthly_max_avg_temp
    sum_max = 0
    @monthly_record.each { |day|
      sum_max += day.max_temp[0]
    }
    return (sum_max / @count).to_f
  end

  def monthly_min_avg_temp
    sum_min = 0
    @monthly_record.each { |day|
      sum_min += day.min_temp[0]
    }
    return (sum_min / @count).to_f
  end

  def monthly_mean_avg_humidity
    sum_mean = 0
    @monthly_record.each { |day|
      sum_mean += day.mean_humidity
    }

    return (sum_mean / @count).to_f
  end

  def print_daily_temp (date)
    puts date.split('_')[1]+" "+date.split('_')[0]
    @monthly_record.each{ |day|
      print "#{day.pkt.split('-')[2]} "
      day.max_temp[0].times { print "+".blue }
      day.min_temp[0].times { print "+".red }
      puts " " + day.min_temp[0].to_s + "C - " + day.max_temp[0].to_s+"C"
    }
  end
end
