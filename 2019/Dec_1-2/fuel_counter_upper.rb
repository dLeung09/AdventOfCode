filename = ARGV[0]

inputFile = File.open(filename, "r")
input = inputFile.read.split

sum = 0

#input.each do |num|
#  mass = num.to_i
#
#  fuel = (mass / 3).floor - 2
#
#  sum += fuel
#
#end
#
#last_fuel = sum
#
#while (last_fuel > 0)
#  fuel = (last_fuel / 3).floor - 2
#
#  break unless fuel > 0
#  sum += fuel
#  last_fuel = fuel
#
#  puts "Adding fuel: #{fuel}"
#end
#
#puts sum

input.each do |num|
  mass = num.to_i

  fuel = (mass / 3).floor - 2

  sum += fuel
  last_fuel = fuel

  while (last_fuel > 0)
    fuel = (last_fuel / 3).floor - 2

    break unless fuel > 0

    puts "Adding fuel: #{fuel}"

    sum += fuel
    last_fuel = fuel
  end

end

#last_fuel = sum
#
#while (last_fuel > 0)
#  fuel = (last_fuel / 3).floor - 2
#
#  break unless fuel > 0
#  sum += fuel
#  last_fuel = fuel
#
#  puts "Adding fuel: #{fuel}"
#end

puts sum
