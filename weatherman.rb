# final flow of code
#   add required libraries
#   handle input from console
#   check statistical operation
#     filter file list base on operation
#     retrive data from filtered list
#       retrived data format
#       "PKT", "Max TemperatureC", "Mean TemperatureC", "Min TemperatureC", "Max Humidity", " Mean Humidity", " Min Humidity"
#     calculate and find required stats
#     print result

require 'colorize'
require 'date'
require 'csv'
#classes
#Day Class contains daily record
class Day
  @daily_record
  @keys
  def initialize(record)
    @daily_record = record
    @keys = @daily_record.keys
  end

  def max_temp #return max temperature
    if @keys.include?('Max TemperatureC')
      return @daily_record['Max TemperatureC'].to_i
    else
      return 0
    end
  end

  def min_temp #return min temperature
    if @keys.include?('Min TemperatureC')
      return @daily_record['Min TemperatureC'].to_i
    else
      return 0
    end
  end

  def mean_humidity #return mean humidity
    if @keys.include?(' Mean Humidity')
      return @daily_record[' Mean Humidity'].to_i
    else
      return 0
    end
  end

  def max_humidity #return max humidity
    if @keys.include?('Max Humidity')
      return @daily_record['Max Humidity'].to_i
    else
      return 0
    end
  end

  def pkt #return date
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

#Month Class contains array of day class
class Month
  @monthly_record
  @count #days_in_month
  def initialize
    @monthly_record = []
    @count = 0
  end

  def add(record)
    @monthly_record << record
    @count += 1
  end

  def monthly_max_temp #return highest max temperature of month
    max = @monthly_record.first.max_temp
    @monthly_record.each { |day|
      if max < day.max_temp
        max = day.max_temp
      end
    }
    return max
  end

  def monthly_min_temp #return lowst min temperature of month
    min = @monthly_record.first.min_temp
    @monthly_record.each { |day|
      if min > day.min_temp
        min = day.min_temp
      end
    }
    return min
  end

  def monthly_max_humidity #return highest max humidity of month
    max = @monthly_record.first.max_humidity
    @monthly_record.each { |day|
      if max < day.max_humidity
        max = day.max_humidity
      end
    }
    return max
  end

  def monthly_max_avg_temp #return avg max temperature of month
    sum_max = 0
    @monthly_record.each { |day|
      sum_max += day.max_temp
    }
    return (sum_max / @count).to_f
  end

  def monthly_min_avg_temp #return avg min temperature of month
    sum_min = 0
    @monthly_record.each { |day|
      sum_min += day.min_temp
    }
    return (sum_min / @count).to_f
  end

  def monthly_mean_avg_humidity #return avg mean humidity of month
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
      day.max_temp.times { print "+".blue }
      day.min_temp.times { print "+".red }
      puts " " + day.min_temp.to_s + "C - " + day.max_temp.to_s+"C"
    }
  end
end

#Year Class contains array of month class
class Year
  @yearly_record
  @count #months_in_year
  def initialize
    @yearly_record = []
    @count = 0
  end

  def add(record)
    @yearly_record << record
    @count += 1
  end

  def yearly_max_temp
    max = @yearly_record.first.monthly_max_temp
    @yearly_record.each { |month|
      if max < month.monthly_max_temp
        max = month.monthly_max_temp
      end
    }
    return max
  end

  def yearly_min_temp
    min = @yearly_record.first.monthly_min_temp
    @yearly_record.each { |month|
      if min < month.monthly_min_temp
        min = month.monthly_min_temp
      end
    }
    return min
  end

  def yearly_max_humidity
    max = @yearly_record.first.monthly_max_humidity
    @yearly_record.each { |month|
      if max < month.monthly_max_humidity
        max = month.monthly_max_humidity
      end
    }
    return max
  end


end

# handle input from console
stat_operation = ARGV[0].to_s
date = ARGV[1].to_s
file_path = ARGV[2].to_s
file_list =  Dir.entries(file_path)


def clean_file_data(path,mode: 'r')
  file = File.open(path, mode)
  data = CSV.read(path)
  temp_month = Month.new
  data.delete_if {|n| n.join.nil? || n.join.empty? || n.length == 1}

  keys = data.first

  data.drop(1).each do |row|
    temp_day = Day.new(keys.zip(row).to_h) # converting each hash
    temp_month.add(temp_day)
  end

  file.close
  return temp_month
end



if stat_operation == '-e'
# -e for a given year
#   >highest temp with date.
#   >lowest temp with date.
#   >most humid day with date.
# filter require files
  year = Year.new
  file_list.select! {|w| w.include?date}
  file_list.each { |f|
    month = clean_file_data(file_path+f)
    year.add(month)

  }
  puts "Highest: " + year.yearly_max_temp.to_s + "C on "
  puts "Lowest: " + year.yearly_min_temp.to_s + "C on "
  puts "Huimid: " + year.yearly_max_humidity.to_s + "% on "


elsif stat_operation == '-a'
# -a for a given month
#   >highest avg temp .
#   >lowest avg temp.
#   >avg humidity.
  month = Month.new
  date = date.split('/')
  date = date[0]+"_"+ Date::ABBR_MONTHNAMES[date[1].to_i]
  file_list.select! {|w| w.include?date}
  file_list.each { |f|
    month = clean_file_data(file_path+f)
  }
  puts "Highest Average: " + month.monthly_max_avg_temp.to_s + "C"
  puts "Lowest Average: " + month.monthly_min_avg_temp.to_s + "C"
  puts "Average Huimidity: " + month.monthly_mean_avg_humidity.to_s + "%"


elsif stat_operation == '-c'
# -c for a given month
#   >highest temp per day in red bar.
#   >lowest temp per day in blue bar.
#   >Bonus if both bar in the same line.
  month = Month.new
  date = date.split('/')
  date = date[0]+"_"+ Date::ABBR_MONTHNAMES[date[1].to_i]
  file_list.select! {|w| w.include?date}
  file_list.each { |f|
    month = clean_file_data(file_path+f)
  }
  month.print_daily_temp(date)
else
  puts "Operational Command not recognized."
end
