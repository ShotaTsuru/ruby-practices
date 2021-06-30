#!/usr/bin/env ruby

require 'optparse'
require 'Date'
require 'Paint'

def aset_week(week_day)
  week_case = EMPTY_ARRAY7.clone
  7.times do |i|
    wday_num = week_day.wday + i
    date = week_day.day + i
    week_case[wday_num] = date if wday_num <= 6 && date <= LAST_DAY.day
  end
  week_case
end

def two_digit_conversion_and_color_inversion(array)
  aset_array = []
  array.each do |x|
    num = ''
    if x.to_s.length != 2
      num = " #{x.to_s}"
    else
      num = x.to_s
    end
    num = Paint[num, :inverse] if num.to_i == Date.today.day && FIRST_WEEK_DAY.year == Date.today.year && FIRST_WEEK_DAY.month == Date.today.month
    aset_array << num
  end
  aset_array
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
EMPTY_ARRAY7 = ['  ','  ','  ','  ','  ','  ','  ']
week = ['日', '月', '火', '水', '木', '金', '土']

all_week_array = [aset_week(FIRST_WEEK_DAY)]

5.times do |i|
  if i == 4 && all_week_array[i][-1].to_s.match?(/\s/) || all_week_array[i][-1] == LAST_DAY.day
    all_week_array << EMPTY_ARRAY7
  else
    week_end_num = FIRST_WEEK_DAY + all_week_array[i][-1]
    all_week_array << aset_week(week_end_num)
  end
end

puts "      #{month}月 #{year}"
puts week.join(' ')
all_week_array.each do |week_case|
  puts two_digit_conversion_and_color_inversion(week_case).join(' ') if week_case
end
