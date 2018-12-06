filename = ARGV[0]

inputFile = File.open(filename, "r")
input = inputFile.read.split
similar_strings = [-1, -1]
unique_char = ''

input.each_index do |i|

  input.each_index do |j|
    next if i == j

    i_chars = input[i].split('')
    j_chars = input[j].split('')

    unique = false

    k = 0
    while k < input[i].length
      if i_chars[k] != j_chars[k]

        break if unique

        unique = true
        unique_char = i_chars[k]

      end

      k += 1
    end

    if k == input[i].length
      similar_strings = [i, j]
      break
    end

  end

end

similar_chars = []

first_str = input[ similar_strings[0] ]
second_str = input[ similar_strings[1] ]

puts first_str
puts second_str
puts

first_str.split('').each_index do |idx|
  i_char = first_str[idx]
  j_char = second_str[idx]

  similar_chars.push(i_char) if i_char == j_char

end

similar_chars.each do |char|
  print char
end
puts ''
