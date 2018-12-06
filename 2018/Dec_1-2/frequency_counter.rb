filename = ARGV[0]

inputFile = File.open(filename, "r")
input = inputFile.read.split

sum = 0
freq = [0]
result = "invalid"

loop do
  input.each do |num|
    sum += num.to_i

    if freq.include? sum
      result = sum
      break
    end

    freq.push sum
  end

  break unless result == "invalid"

end

puts result
