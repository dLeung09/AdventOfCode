require 'json'

filename = ARGV[0]

inputFile = File.open(filename, "r")
input = inputFile.read.split(%r{,\s*})

input.each_index do |idx|
  input[idx] = input[idx].to_i
end

def intcode_program(arr_orig)
  arr = []
  arr_orig.each { |e| arr << e.dup }

  puts "Array: #{arr}"

  arr.each_index do |idx|
    next unless idx % 4 == 0

    op_code = arr[idx]

    if op_code.nil? || op_code == 99
      puts "Processing finished. Returning"
      break
    end

    op_val_one_idx = arr[idx + 1]
    op_val_one = arr[op_val_one_idx]

    break if op_val_one.nil?

    op_val_two_idx = arr[idx + 2]
    op_val_two = arr[op_val_two_idx]

    break if op_val_two.nil?

    op_val_dest = arr[idx + 3]

    break if op_val_dest.nil?

    if op_code == 1
      puts "OP CODE 1: Addition (#{op_val_one} + #{op_val_two})"
      result = op_val_one + op_val_two
    elsif op_code == 2
      puts "OP CODE 2: Multiplication (#{op_val_one} x #{op_val_two})"
      result = op_val_one * op_val_two
    else
      puts "Invalid entry... breaking"
    end

    arr[op_val_dest] = result
  end

  arr
end

result = []

(0..99).each do |op_one|

  (0..99).each do |op_two|
    input[1] = op_one
    input[2] = op_two

    result = intcode_program(input)

    puts "Op one: #{op_one}, Op two: #{op_two}, Result: #{result[0]}"

    break if result[0] == 19690720
  end

  break if result[0] == 19690720
end

puts "OP one: #{result[1]}"
puts "OP two: #{result[2]}"
puts "DEST: #{result[0]}"

puts "Answer: #{ 100 * result[1] + result[2]}"
