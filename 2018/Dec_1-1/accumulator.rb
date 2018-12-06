filename = ARGV[0]

inputFile = File.open(filename, "r")
input = inputFile.read.split

sum = 0

input.each do |num|
  sum += num.to_i
end

puts sum
