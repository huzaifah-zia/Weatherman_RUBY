
require 'colorize'
#list to do
# handle input from console
stat_operation = ARGV[0].to_s
date = ARGV[1].to_s
file_path = ARGV[2].to_s
Mode = "r".freeze

puts stat_operation
puts date.split('/')
puts file_path

# retieve data from file only that is require
# start with a single file
file = "/home/dev/Documents/Traning/Ruby Project/Weatherman_RUBY/Murree_weather/"
file_list =  Dir.entries(file)



# cleaning data to pkt, temp , humidity
require 'csv'
file = File.open(path, mode)
data = CSV.read(path)
data = data.transpose[0..-14].transpose
data.each do |row|
  row.delete_at 4
  row.delete_at 5
  row.delete_at 6
 end
p data
file.close



if stat_operation == '-e'
# -e for a given year
#   >highest temp with date.
#   >lowest temp with date.
#   >most humid day with date.
# filter require files
file_list.select! {|w| w.include?date}
file_list

elsif stat_operation == '-a'
# -a for a given month
#   >highest avg temp .
#   >lowest avg temp.
#   >avg humidity.

elsif stat_operation == '-c'
  # -c for a given month
#   >highest temp per day in red bar.
#   >lowest temp per day in blue bar.
#   >Bonus if both bar in the same line.

else

end








# print functions
