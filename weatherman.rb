require 'colorize'
require 'date'
require 'csv'
require './recordClass.rb'
require './fileClass.rb'
require './folderClass.rb'

stat_operation = ARGV[0].to_s
date = ARGV[1].to_s
file_path = ARGV[2].to_s
file_list =  Dir.entries(file_path)


def clean_file_data(path,mode: 'r')
  file = File.open(path, mode)
  data = CSV.read(path)
  temp_month = File_record.new
  data.delete_if {|n| n.join.nil? || n.join.empty? || n.length == 1}

  keys = data.first

  data.drop(1).each do |row|
    temp_day = Record.new(keys.zip(row).to_h) # converting each hash
    temp_month.add(temp_day)
  end

  file.close
  return temp_month
end



if stat_operation == '-e'
  year = Folder.new
  file_list.select! {|w| w.include?date}
  file_list.each { |f|
    month = clean_file_data(file_path+f)
    year.add(month)

  }
  puts "Highest: " + year.yearly_max_temp[0].to_s + "C on " + Date::ABBR_MONTHNAMES[year.yearly_max_temp[1].split('-')[1].to_i] + " " + year.yearly_max_temp[1].split('-')[2]
  puts "Lowest: " + year.yearly_min_temp[0].to_s + "C on " + Date::ABBR_MONTHNAMES[year.yearly_min_temp[1].split('-')[1].to_i] + " " + year.yearly_min_temp[1].split('-')[2]
  puts "Huimid: " + year.yearly_max_humidity[0].to_s + "% on " + Date::ABBR_MONTHNAMES[year.yearly_max_humidity[1].split('-')[1].to_i] + " " + year.yearly_max_humidity[1].split('-')[2]


elsif stat_operation == '-a'
  month = File_record.new
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
  month = File_record.new
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
