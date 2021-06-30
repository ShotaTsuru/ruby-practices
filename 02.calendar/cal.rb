#!/usr/bin/env ruby

require 'optparse'
require 'Date'
require 'Paint'

def aset_week(week_day)
  week = EMPTY_WEEK.clone
  7.times do |i|
    wday = week_day.wday + i
    date = week_day.day + i
    week[wday] = date if wday <= 6 && date <= LAST_DAY.day
  end
  week
end

def two_digit_conversion(week)
  week.map do |x|
    num = ''
    if x.to_s.length != 2
      num = " #{x.to_s}"
    else
      num = x.to_s
    end
    num
  end
end

def color_inversion(array)
  array.map do |day_num|
    if day_num.to_i == Date.today.day && FIRST_WEEK_DAY.year == Date.today.year && FIRST_WEEK_DAY.month == Date.today.month
      Paint[day_num, :inverse]
    else
      day_num
    end
  end
end

today = Date.today
year = today.year
month = today.month

params = {}
params = ARGV.getopts("m:","y:")

month = params["m"] if params["m"]
year = params["y"] if params["y"]

FIRST_WEEK_DAY = Date.new(year.to_i, month.to_i, 1)
LAST_DAY = Date.new(year.to_i, month.to_i, -1)
EMPTY_WEEK = ['  ','  ','  ','  ','  ','  ','  ']
week = ['日', '月', '火', '水', '木', '金', '土']

all_weeks_array = [aset_week(FIRST_WEEK_DAY)]

5.times do |i|
  if i == 4 && all_weeks_array[i][-1].to_s.match?(/\s/) || all_weeks_array[i][-1] == LAST_DAY.day
    all_weeks_array << EMPTY_WEEK
  else
    week_end_num = FIRST_WEEK_DAY + all_weeks_array[i][-1]
    all_weeks_array << aset_week(week_end_num)
  end
end

puts "      #{month}月 #{year}"
puts week.join(' ')
all_weeks_array.each do |week|
  array = ""
  array = two_digit_conversion(week)
  puts color_inversion(array).join(' ')
end
