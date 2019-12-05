range_start = 172930
range_end = 683082

# It is a six-digit number.
# The value is within the range given in your puzzle input.
# Two adjacent digits are the same (like 22 in 122345).
# Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).

def contains_two_adjacent(num_str)
  num_arr = num_str.split('')

  num_arr.each_index do |idx|
    next if idx == 0

    return true if num_arr[idx] == num_arr[idx - 1]
  end

  false
end

def never_decrease(num_str)
  num_arr = num_str.split('')

  last = num_arr[0]
  num_arr.each_index do |idx|
    next if idx == 0

    return false if num_arr[idx] < last
    last = num_arr[idx]
  end

  true
end

test_num = 111123

puts "Contains two adjacent: #{contains_two_adjacent(test_num.to_s)}"
puts "Never decreases: #{never_decrease(test_num.to_s)}"

#count = 0
#
#(range_start..range_end).each do |num|
#  num_str = num.to_s
#  count += 1 if contains_two_adjacent(num_str) && never_decrease(num_str)
#end
#
#puts count
