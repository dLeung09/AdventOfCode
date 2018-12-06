filename = ARGV[0]

inputFile = File.open(filename, "r")
input = inputFile.read.split

two_count = 0
three_count = 0

input.each do |str|
  letter_count = {}

  chars = str.split('')

  chars.each do |char|

    if !letter_count.include? char
      letter_count[char] = 1
      next
    end

    letter_count[char] += 1
  end

  if letter_count.has_value? 2
    two_count += 1
  end

  if letter_count.has_value? 3
    three_count += 1
  end

end

puts two_count * three_count
