require 'json'

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
  vector_hash = vector_str.match /(?<direction>\w)(?<distance>\d+)/

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

  if direction.downcase == 'r'
    width_diff = distance

  elsif direction.downcase == 'l'
    width_diff = distance * -1

  elsif direction.downcase == 'u'
    height_diff = distance

  elsif direction.downcase == 'd'
    height_diff = distance * -1

  else
    puts "Unexpected direction: #{direction}"
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
  :x => l_max.abs - 1,
  :y => u_max.abs - 1
}

puts "Origin: (#{origin[:x]},#{origin[:y]})"
puts ""

def draw_line_x(grid, curr_location, dist, x_max)
  start_x = curr_location[:x]
  y = curr_location[:y]

  (start_x..start_x + dist).each do |x|

    # Point (x,y) = Arr[ origion[:x] + x + x_max * (origin[:y] + y) ]
    idx = x + x_max * y
    puts "x: #{x}, x_max: #{x_max}, y: #{y}"
    puts "plotting at: #{idx}"
    grid[idx] += 1

  end

  grid
end

def draw_line_y(grid, curr_location, dist, x_max)
  x = curr_location[:x]
  start_y = curr_location[:y]

  (start_y..start_y + dist).each do |y|

    # Point (x,y) = Arr[ origion[:x] + x + x_max * (origin[:y] + y) ]
    idx = x + x_max * y
    puts "x: #{x}, x_max: #{x_max}, y: #{y}"
    puts "plotting at: #{idx}"
    grid[idx] += 1

  end

  grid
end

def draw_line(line, grid, curr_location, origin, x_max)
  distance, direction = parse_vector(line)

  x = curr_location[:x] + origin[:x]
  y = curr_location[:y]

  start = {
    :x => x,
    :y => y
  }

  case direction.downcase
  when 'r' then
    puts "Drawing line to right from #{x} to #{x + distance}"

    grid = draw_line_x(grid, start, distance, x_max)

    curr_location = {
      :x => start[:x] + distance,
      :y => start[:y]
    }

  when 'l' then
    start[:x] = x - distance

    puts "Drawing line to left from #{start[:x]} to #{start[:x] + distance}"

    grid = draw_line_x(grid, start, distance, x_max)

    curr_location = {
      :x => start[:x] + distance,
      :y => start[:y]
    }

  when 'u' then
    start[:y] = y + distance

    puts "Drawing line up from #{start[:y]} to #{start[:y] + distance}"

    grid = draw_line_y(grid, start, distance, x_max)

    curr_location = {
      :x => start[:x],
      :y => start[:y] + distance
    }

  when 'd' then
    puts "Drawing line down from #{y} to #{y + distance}"

    grid = draw_line_y(grid, start, distance, x_max)

    curr_location = {
      :x => start[:x],
      :y => start[:y] + distance
    }

  else
    puts "Invalid line direction"
    return
  end

  [grid, curr_location]
end

puts "Max - Right: #{r_max}, Left: #{l_max}, Up: #{u_max}, Down: #{d_max}"

puts "Grid before:"
puts grid.to_json
puts ""

curr_location = origin

wire_one.each do |point|
  grid, curr_location = draw_line(point, grid, curr_location, origin, x_max)
end

puts "Grid after:"
puts grid.to_json
puts ""
