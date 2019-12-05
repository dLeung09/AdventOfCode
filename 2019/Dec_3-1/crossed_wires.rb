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
  distance, direction = parse_vector(vector)

  #puts "Direction: #{direction}"
  #puts "Distance: #{distance}"
  #puts ""

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

  #puts "Parsed - Width Diff: #{width_diff}, Height Diff: #{height_diff}"

  width += width_diff
  height += height_diff

  #puts "Current - Width: #{width}, Height: #{height}"

  r_max = [ r_max, width ].max
  l_max = [ l_max, width ].min

  u_max = [ u_max, height ].max
  d_max = [ d_max, height ].min

  #puts "Wire One Max - Right: #{r_max}, Left: #{l_max}, Up: #{u_max}, Down: #{d_max}"
  #puts ""
end

height = 0
width = 0

wire_two.each do |v|
  width_diff, height_diff = update_dimension(v)

  #puts "Parsed - Width Diff: #{width_diff}, Height Diff: #{height_diff}"

  width += width_diff
  height += height_diff

  #puts "Current - Width: #{width}, Height: #{height}"

  r_max = [ r_max, width ].max
  l_max = [ l_max, width ].min

  u_max = [ u_max, height ].max
  d_max = [ d_max, height ].min

  #puts "Wire Two Max - Right: #{r_max}, Left: #{l_max}, Up: #{u_max}, Down: #{d_max}"
  #puts ""
end

x_max = r_max.abs + l_max.abs + 1
y_max = u_max.abs + d_max.abs + 1

#puts "Grid size - X max: #{x_max}, Y max: #{y_max}"

def print_grid(grid)
  puts "Grid:"
  grid.each do |x_grid|
    puts x_grid.to_json
  end
end

# Create grid of size x_max * y_max
grid = []

y_max.times do
  x_grid = []

  x_max.times do
    x_grid << 0
  end

  grid << x_grid
end

origin = {
  :x => l_max.abs,
  :y => u_max.abs
}

#print_grid(grid)

#puts "Origin: (#{origin[:x]},#{origin[:y]})"
#puts ""

def draw_line_x(grid, curr_location, dist, x_max)
  start_x = curr_location[:x]
  y = curr_location[:y]

  (start_x..start_x + dist).each do |x|
    #puts "plotting at: (#{x},#{y})"
    grid[y][x] += 1

    puts "Intersection at (#{x},#{y})" if grid[y][x] > 1
  end

  grid
end

def draw_line_y(grid, curr_location, dist, x_max)
  x = curr_location[:x]
  start_y = curr_location[:y]

  (start_y..start_y + dist).each do |y|
    #puts "plotting at: (#{x},#{y})"
    grid[y][x] += 1

    puts "Intersection at (#{x},#{y})" if grid[y][x] > 1
  end

  grid
end

def draw_line(line, grid, curr_location, origin, x_max)
  distance, direction = parse_vector(line)

  distance = distance - 1

  x = curr_location[:x]
  y = curr_location[:y]

  start = {
    :x => x,
    :y => y
  }

  case direction.downcase
  when 'r' then
    #puts "Drawing line to right from #{x} for #{distance}"

    start[:x] += 1

    grid = draw_line_x(grid, start, distance, x_max)

    curr_location = {
      :x => start[:x] + distance,
      :y => start[:y]
    }

  when 'l' then
    start[:x] = x - distance - 1

    #puts "Drawing line to left from #{start[:x]} for #{distance}"

    grid = draw_line_x(grid, start, distance, x_max)

    curr_location = {
      :x => start[:x],
      :y => start[:y]
    }

  when 'u' then
    start[:y] = y - distance - 1

    #puts "Drawing line up from #{start[:y]} for #{distance}"

    grid = draw_line_y(grid, start, distance, x_max)

    curr_location = {
      :x => start[:x],
      :y => start[:y]
    }

  when 'd' then
    #puts "Drawing line down from #{y} for #{distance}"

    start[:y] += 1

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

curr_location = origin

wire_one.each do |point|
  grid, curr_location = draw_line(point, grid, curr_location, origin, x_max)
  #print_grid(grid)
end

curr_location = origin

wire_two.each do |point|
  grid, curr_location = draw_line(point, grid, curr_location, origin, x_max)
  #print_grid(grid)
end

puts ""
puts wire_one.to_json
puts ""

puts ""
puts wire_two.to_json
puts ""

puts "Grid after:"
#print_grid(grid)
puts ""

#y_max.times do
#  x_grid = []
#
#  x_max.times do
#    x_grid << 0
#  end
#
#  grid << x_grid
#end

intersections = []

grid.each_index do |y_idx|
  x_grid = grid[y_idx]

  x_grid.each_index do |x_idx|
    val = x_grid[x_idx]

    intersections << { :x => x_idx, :y => y_idx } if val > 1
  end
end

puts "Intersections: #{intersections}"

min_distance = x_max + y_max

puts "Origin: (#{origin[:x]},#{origin[:y]})"

distances = []

intersections.each do |point|
  x = point[:x]
  y = point[:y]

  puts "Checking point (#{x},#{y})"

  man_distance = (x - origin[:x]).abs + (y - origin[:y]).abs

  distances << man_distance

  puts "Distance: #{man_distance}"
  puts ''

  min_distance = [man_distance, min_distance].min
end

puts "Min distance: #{min_distance}"

distances.sort!

puts "Distances: #{distances.to_json}"
