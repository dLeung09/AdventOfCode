filename = ARGV[0]

inputFile = File.open(filename, "r")
input = inputFile.read.split

sum = 0

input.each do |num|
  mass = num.to_i

  fuel = (mass / 3).floor - 2

  sum += fuel

end

puts sum
