require 'date'

filename = ARGV[0]

inputFile = File.open(filename, "r")
input = inputFile.read.split("\n")

guard_list = []
data_array = []

input.each do |entry|
  guard_switch = entry.match(/^\[([\d-]+)\s(\d+):(\d+)\]\sGuard\s#(\d+)\sbegins\sshift$/i)
  guard_wake = entry.match(/^\[([\d-]+)\s(\d+):(\d+)\]\swakes\sup$/i)
  guard_sleep = entry.match(/^\[([\d-]+)\s(\d+):(\d+)\]\sfalls\sasleep$/i)

  unless guard_switch.nil?
    date_only, hour, min, id = guard_switch.captures

    if hour.to_i > 0
      hour = 0
      min = 0
      date_only = (Date.parse(date_only) + 1).to_s
    end

    date = "#{date_only} #{hour}:#{min}"
    obj = {
      :date => DateTime.parse(date),
      :hour => hour,
      :min => min,
      :event => :start,
      :guard => id
    }
    data_array.push(obj)

    guard_list.push(id) unless guard_list.include? id

    #puts "Date: #{date}, id: #{id}"
  end

  unless guard_wake.nil?
    date_only, hour, min = guard_wake.captures
    date = "#{date_only} #{hour}:#{min}"
    obj = {
      :date => DateTime.parse(date),
      :hour => hour,
      :min => min,
      :event => :wake
    }
    data_array.push(obj)

    #puts "Date: #{date}"
  end

  unless guard_sleep.nil?
    date_only, hour, min = guard_sleep.captures
    date = "#{date_only} #{hour}:#{min}"
    obj = {
      :date => DateTime.parse(date),
      :hour => hour,
      :min => min,
      :event => :sleep
    }
    data_array.push(obj)

    #puts "Date: #{date}"
  end

end

data_array.sort! { |x,y|
  x[:date] <=> y[:date]
}

data_map = {}

## Data map
# {
#   "<date>": {
#     "id": "<id",
#     "state": [ .... ]   // length = 60
#   }
# }

puts data_array.inspect
puts

## Minute count
# {
#   "<id>": [ 0, ..., 0] // length = 60
# }
minute_count = {}
guard_list.each do |id|
  minute_count[id] = Array.new(60, 0)
end

current_state = :awake
last_state_min = 0
current_guard = nil
data_array.each do |event|
  date = event[:date].to_date

  if data_map[date].nil?
    data_map[date] = {
      :state => Array.new(60, :wake)
    }
  end

  last_state_min = 0 if event[:event] == :start

  if event[:guard]
    data_map[date][:id] = event[:guard]
    current_guard = event[:guard]
  end

  next if event[:event] == :start || event[:event] == current_state

  minute = event[:min].to_i
  #puts "Minute: #{minute}"
  #puts "Last time: #{last_state_min}"

  i = last_state_min
  while i < minute
    #puts "Setting state at time #{i} to #{current_state}"
    data_map[date][:state][i] = current_state
    minute_count[current_guard][i] += 1 if current_state == :sleep

    i += 1
  end
  last_state_min = minute

  #puts "Current state: #{current_state}"
  #puts "Next state: #{event[:event]}"
  current_state = event[:event]

end

guard_count = { }

data_map.each do |key, value|
  guard = value[:id]
  g_arr = value[:state]
  guard_count[guard] = 0 if guard_count[guard].nil?

  guard_count[guard] += g_arr.count { |x| x == :sleep }

end

#puts data_map.inspect

#puts guard_count.inspect

max_count = 0
selected_guard = ""
guard_count.each do |key, value|
  if value > max_count
    selected_guard = key
    max_count = value
  end
end

#puts selected_guard

#puts minute_count.inspect


max_minute = -1
max_minute_idx = -1
selected_guard = ''
minute_count.each do |key, arr|
  #arr = minute_count[selected_guard]
  arr.each_index do |idx|
    value = arr[idx]
    if value > max_minute
      max_minute = value
      max_minute_idx = idx
      selected_guard = key
    end
  end
end

puts max_minute_idx
puts selected_guard

puts max_minute_idx.to_i * selected_guard.to_i

