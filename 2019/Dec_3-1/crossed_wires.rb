filename = ARGV[0]

inputFile = File.open(filename, "r")
input = inputFile.read.split

if input.length != 2
  puts "Unexpected input"
  return
end

# Split input into two wires
wire_one = input[0].split(",")
wire_two = input[1].split(",")

puts "Wire one: #{wire_one}"
puts "Wire two: #{wire_two}"
puts ""

# Get grid size
r_max = 0
l_max = 0
u_max = 0
d_max = 0

def parse_vector(vector_str)
  vector_hash = vector.match /(?<direction>\w)(?<distance>\d+)/

  distance = vector_hash[:distance].to_i
  direction = vector_hash[:direction]

  [distance, direction]
end

# @param vector [String] - String of format "L#", where L is one of RLUD, and # is a number
# @returns [Array of Number] - Always of size four; containing the change in each direction [ R, L, U, D ]
def update_dimension(vector)
  #vector_hash = vector.match /(?<direction>\w)(?<distance>\d+)/

  #distance = vector_hash[:distance].to_i
  #direction = vector_hash[:direction]

  distance, direction = parse_vector(vector)

  puts "Direction: #{direction}"
  puts "Distance: #{distance}"
  puts ""

  width_diff = 0
  height_diff = 0

  if vector_hash[:direction].downcase == 'r'
    width_diff = distance

  elsif vector_hash[:direction].downcase == 'l'
    width_diff = distance * -1

  elsif vector_hash[:direction].downcase == 'u'
    height_diff = distance

  elsif vector_hash[:direction].downcase == 'd'
    height_diff = distance * -1

  else
    puts "Unexpected direction: #{vector_hash[:direction]}"
    return [0,0]
  end

  [ width_diff, height_diff ]
end

height = 0
width = 0

wire_one.each do |v|
  width_diff, height_diff = update_dimension(v)

  puts "Parsed - Width Diff: #{width_diff}, Height Diff: #{height_diff}"

  width += width_diff
  height += height_diff

  puts "Current - Width: #{width}, Height: #{height}"

  r_max = [ r_max, width ].max
  l_max = [ l_max, width ].min

  u_max = [ u_max, height ].max
  d_max = [ d_max, height ].min

  puts "Wire One Max - Right: #{r_max}, Left: #{l_max}, Up: #{u_max}, Down: #{d_max}"
  puts ""
end

height = 0
width = 0

wire_two.each do |v|
  width_diff, height_diff = update_dimension(v)

  puts "Parsed - Width Diff: #{width_diff}, Height Diff: #{height_diff}"

  width += width_diff
  height += height_diff

  puts "Current - Width: #{width}, Height: #{height}"

  r_max = [ r_max, width ].max
  l_max = [ l_max, width ].min

  u_max = [ u_max, height ].max
  d_max = [ d_max, height ].min

  puts "Wire Two Max - Right: #{r_max}, Left: #{l_max}, Up: #{u_max}, Down: #{d_max}"
  puts ""
end

x_max = r_max.abs + l_max.abs
y_max = u_max.abs + d_max.abs

# Create grid of size x_max * y_max
grid = []
(x_max * y_max).times do
  grid << 0
end

# Set origin:
#   - x is the absolute value of left max
#   - y is the absolute value of right max

origin = {
  :x => l_max.abs,
  :y => r_max.abs
}

def draw_line_x(grid, curr_location, dist)
  # Point (x,y) = Arr[ origion[:x] + x + x_max * (origin[:y] + y) ]
  (curr_location..curr_location + dist).each do |x|
    #TODO: Need to pass both coordinates to this method
  end
end

def draw_line_y(grid, curr_location, dist)
  # Point (x,y) = Arr[ origion[:x] + x + x_max * (origin[:y] + y) ]
end

def draw_line(line, grid, curr_location)
  distance, direction = parse_vector(line)

  x = curr_location[:x]
  y = curr_location[:y]

  case direction.downcase
  when 'r':
    puts "Drawing line to right from #{x} to #{x + distance}"
    grid = draw_line_x(grid, x, distance)

  when 'l':
    puts "Drawing line to left from #{x - distance} to #{x}"
    grid = draw_line_x(grid, x - distance, distance)

  when 'u':
    puts "Drawing line up from #{y - distance} to #{y}"
    grid = draw_line_y(grid, y - distance, distance)

  when 'd':
    puts "Drawing line down from #{y} to #{y + distance}"
    grid = draw_line_y(grid, y, distance)

  else
    puts "Invalid line direction"
    return
  end

  grid
end


puts "Max - Right: #{r_max}, Left: #{l_max}, Up: #{u_max}, Down: #{d_max}"
