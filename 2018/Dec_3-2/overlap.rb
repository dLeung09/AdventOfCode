filename = ARGV[0]

inputFile = File.open(filename, "r")
input = inputFile.read.split("\n")

claims_hash = {}
max_width = 0
max_height = 0

unique_claim = []
input.each do |line|
  id, x_start, y_start, width, height = line.match(/^#(\d+)\s@\s(\d+),(\d+):\s(\d+)x(\d+)/i).captures

  obj = {
    :x => x_start.to_i,
    :y => y_start.to_i,
    :width => width.to_i,
    :height => height.to_i,
  }

  max_width = [ max_width, obj[:x] + obj[:width] ].max
  max_height = [ max_height, obj[:y] + obj[:height] ].max

  claims_hash[id] = obj
  unique_claim.push(id)
end

#puts "Max width: #{max_width}"
#puts "Max height: #{max_height}"
#puts ""

fabric_matrix = Array.new(max_width + 1) { Array.new(max_height + 1, "") }

claims_hash.each do |key, value|
  #puts "Processing id: #{key}"

  x = value[:x]
  width = value[:width]
  y = value[:y]

  height = value[:height]
  #puts "X: #{x}"
  #puts "Y: #{y}"
  #puts "Width: #{width}"
  #puts "Height: #{height}"

  j = 0
  while j < height && y + j < max_height + 1 do


    i = 0
    while i < width && i + x < max_width + 1 do
      #puts "(X,Y): (#{i},#{j})"

      if fabric_matrix[j+y][i+x] == ""
        fabric_matrix[j+y][i+x] = key
      else
        fabric_matrix[j+y][i+x] = [ fabric_matrix[j+y][i+x], ",", key].join
      end
      #fabric_matrix[j + y][i + x].push(key)

      i += 1
    end

    j += 1
  end
  #puts "I: #{i}, J: #{j}"
  #puts ""
end

fabric_matrix.each do |outer_array|
  #puts "Full array #{outer_array.inspect}"

  outer_array.each do |element|
    if element.match(/,/i)
      element.split(",").each do |id|
        #puts "Deleting #{id}"
        unique_claim.delete(id)
      end
    end
  end

end
#puts ""

puts "Unique: #{unique_claim}"
