require 'colorize'
#list to do
# handle input from console
stat_operation = ARGV[0].to_s
date = ARGV[1].to_s
file_path = ARGV[2].to_s

puts stat_operation
puts date
puts file_path

# retieve data from file only that is require
# start with a single file
path = "/home/dev/Documents/Traning/Ruby Project/Weatherman_RUBY/Murree_weather/Murree_weather_2016_Sep.txt"
mode = "r"

p "reading using csv \n\n"
require 'csv'
file = File.open(path, mode)
data = CSV.read(path)
p data
file.close
#   create a class
#     to retieve only required data

# store data in ruby object
#     create class
#     manage data


# -e
#   >highest temp with date.
#   >lowest temp with date.
#   >most humid day with date.

# -a
#   >highest avg temp .
#   >lowest avg temp.
#   >avg humidity.

# -c
#   >highest temp per day in red bar.
#   >lowest temp per day in blue bar.
#   >Bonus if both bar in the same line.




# print functions
