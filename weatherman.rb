# final flow of code
#   add required libraries
#   handle input from console
#   check statistical operation
#     filter file list base on operation
#     retive data from filtered list
#     calculate and find required stats
#     print result

require 'colorize'
require 'date'
require 'csv'
#list to do
# handle input from console
stat_operation = ARGV[0].to_s
date = ARGV[1].to_s
file_path = ARGV[2].to_s
file_list =  Dir.entries(file_path)


def clean_file_data(path,mode: 'r')
  file = File.open(path, mode)
  data = CSV.read(path)

  data.delete_if {|n| n.join.nil? || n.join.empty? || n.length == 1}
  data = data.transpose[0..-14].transpose[1..-1]
  data.each do |row|
    row.delete_at 4
    row.delete_at 4
    row.delete_at 4
   end
  file.close
  return data
end



if stat_operation == '-e'
# -e for a given year
#   >highest temp with date.
#   >lowest temp with date.
#   >most humid day with date.
# filter require files
  output = {:highest => 0, :h_date => "",:lowest => 100, :l_date => "", :humid => 0, :date => ""}
  file_list.select! {|w| w.include?date}
  file_list.each { |f|
    clean_data = clean_file_data(file_path+f)
    clean_data.each do |n|
      if n[1].to_i> output[:highest]
        output[:highest] = n[1].to_i
        output[:h_date] = n[0]
      end
      if n[3].to_i < output[:lowest]
        output[:lowest] = n[3].to_i
        output[:l_date] = n[0]
      end
      if n[4].to_i > output[:humid]
        output[:humid] = n[4].to_i
        output[:date] = n[0]
      end
    end
  }
  p output


elsif stat_operation == '-a'
# -a for a given month
#   >highest avg temp .
#   >lowest avg temp.
#   >avg humidity.
  output = {:highest => 0, :lowest => 100, :humid => 0}
  date = date.split('/')
  date = date[0]+"_"+ Date::ABBR_MONTHNAMES[date[1].to_i]
  file_list.select! {|w| w.include?date}
  file_list.each { |f|
    clean_data = clean_file_data(file_path+f)
    transposed_data = clean_data.transpose
    output[:highest] = transposed_data[1].map(&:to_i).sum / transposed_data.size
    output[:lowest] = transposed_data[3].map(&:to_i).sum / transposed_data.size
    output[:humid] = transposed_data[5].map(&:to_i).sum / transposed_data.size
  }
  p output


elsif stat_operation == '-c'
  # -c for a given month
#   >highest temp per day in red bar.
#   >lowest temp per day in blue bar.
#   >Bonus if both bar in the same line.
  date = date.split('/')
  date = date[0]+"_"+ Date::ABBR_MONTHNAMES[date[1].to_i]
  file_list.select! {|w| w.include?date}
  file_list.each { |f|
    clean_data = clean_file_data(file_path+f)
  }
  puts "Operational not complete."

else
  puts "Operational Command not recognized."
end

# cleaning data to pkt, temp , humidity
# file = File.open(path, mode)
# data = CSV.read(path)
# data = data.transpose[0..-14].transpose
# data.each do |row|
#   row.delete_at 4
#   row.delete_at 5
#   row.delete_at 6
#  end
# p data
# file.close
