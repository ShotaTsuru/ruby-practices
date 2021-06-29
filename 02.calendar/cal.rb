#!/usr/bin/env ruby

require 'optparse'
require 'Date'
require 'Paint'

today = Date.today
year = today.year
month = today.month


params = {}

# opt.on('-m') {|v| v }
# opt.on('-y') {|v| v }

# opt.parse!(ARGV, into: params)
params = ARGV.getopts("m:","y:")

month = params["m"] unless params["m"] == nil
year = params["y"] unless params["y"] == nil

First_week_day = Date.new(year.to_i, month.to_i, 1)
Last_day = Date.new(year.to_i, month.to_i, -1)


week = ["日", "月", "火", "水", "木", "金", "土"]
week_case = ["  ","  ","  ","  ","  ","  ","  "]

def set_case
  week_case = ["  ","  ","  ","  ","  ","  ","  "]
end

def set_week(week_day)
  week_case = ["  ","  ","  ","  ","  ","  ","  "]
  7.times do |i|
    x = week_day.wday + i
    y = week_day.day + i
    week_case[x] = y if x <= 6 && y <= Last_day.day
  end
  return week_case
end

def set_string_num(array)
  aset_array = []
  array.each do |x|

    num = ""
    if x.to_s.length != 2 
      num = " " + x.to_s 
      num = Paint[num, :inverse] if num.to_i == Date.today.day && First_week_day.year == Date.today.year && First_week_day.month == Date.today.month
     
    else
      num = x.to_s
      num = Paint[num, :inverse] if num.to_i == Date.today.day && First_week_day.year ==  Date.today.year && First_week_day.month == Date.today.month
    end
    aset_array << num  
  end
  return aset_array
end

first = set_week(First_week_day)


second_week_day = First_week_day + first[-1]
set_case
second = set_week(second_week_day)


third_week_day = First_week_day + second[-1]
set_case
third = set_week(third_week_day)


fourth_week_day = First_week_day + third[-1]
set_case
fourth = set_week(fourth_week_day)


fifth_week_day = First_week_day + fourth[-1]
set_case
fifth = set_week(fifth_week_day)

if fifth[-1].to_s =~ /^[0-9]+$/ || fifth[-1] == 31
six_week_day = First_week_day + fifth[-1] 
set_case
six = set_week(six_week_day)
end



first_w = set_string_num(first)
second_w = set_string_num(second)
third_w = set_string_num(third)
fourth_w = set_string_num(fourth)
fifth_w = set_string_num(fifth)
six_w = set_string_num(six) unless six == nil

puts "      #{month}月 #{year}"
puts week.join(" ")
puts first_w.join(" ")
puts second_w.join(" ")
puts third_w.join(" ")
puts fourth_w.join(" ")
puts fifth_w.join(" ")
puts six_w&.join(" ") 
