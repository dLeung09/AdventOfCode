require 'json'

arr = [3,225,1,225,6,6,1100,1,238,225,104,0,1102,79,14,225,1101,17,42,225,2,74,69,224,1001,224,-5733,224,4,224,1002,223,8,223,101,4,224,224,1,223,224,223,1002,191,83,224,1001,224,-2407,224,4,224,102,8,223,223,101,2,224,224,1,223,224,223,1101,18,64,225,1102,63,22,225,1101,31,91,225,1001,65,26,224,101,-44,224,224,4,224,102,8,223,223,101,3,224,224,1,224,223,223,101,78,13,224,101,-157,224,224,4,224,1002,223,8,223,1001,224,3,224,1,224,223,223,102,87,187,224,101,-4698,224,224,4,224,102,8,223,223,1001,224,4,224,1,223,224,223,1102,79,85,224,101,-6715,224,224,4,224,1002,223,8,223,1001,224,2,224,1,224,223,223,1101,43,46,224,101,-89,224,224,4,224,1002,223,8,223,101,1,224,224,1,223,224,223,1101,54,12,225,1102,29,54,225,1,17,217,224,101,-37,224,224,4,224,102,8,223,223,1001,224,3,224,1,223,224,223,1102,20,53,225,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,107,226,226,224,1002,223,2,223,1006,224,329,101,1,223,223,1108,677,226,224,1002,223,2,223,1006,224,344,101,1,223,223,7,677,226,224,102,2,223,223,1006,224,359,101,1,223,223,108,226,226,224,1002,223,2,223,1005,224,374,101,1,223,223,8,226,677,224,1002,223,2,223,1006,224,389,101,1,223,223,1108,226,226,224,102,2,223,223,1006,224,404,101,1,223,223,1007,677,677,224,1002,223,2,223,1006,224,419,101,1,223,223,8,677,677,224,1002,223,2,223,1005,224,434,1001,223,1,223,1008,226,226,224,102,2,223,223,1005,224,449,1001,223,1,223,1008,226,677,224,102,2,223,223,1006,224,464,101,1,223,223,1107,677,677,224,102,2,223,223,1006,224,479,101,1,223,223,107,677,677,224,1002,223,2,223,1005,224,494,1001,223,1,223,1107,226,677,224,1002,223,2,223,1005,224,509,101,1,223,223,1108,226,677,224,102,2,223,223,1006,224,524,101,1,223,223,7,226,226,224,1002,223,2,223,1005,224,539,101,1,223,223,108,677,677,224,1002,223,2,223,1005,224,554,101,1,223,223,8,677,226,224,1002,223,2,223,1005,224,569,1001,223,1,223,1008,677,677,224,102,2,223,223,1006,224,584,101,1,223,223,107,226,677,224,102,2,223,223,1005,224,599,1001,223,1,223,7,226,677,224,102,2,223,223,1005,224,614,101,1,223,223,1007,226,226,224,1002,223,2,223,1005,224,629,101,1,223,223,1107,677,226,224,1002,223,2,223,1006,224,644,101,1,223,223,108,226,677,224,102,2,223,223,1006,224,659,101,1,223,223,1007,677,226,224,102,2,223,223,1006,224,674,101,1,223,223,4,223,99,226]

#arr = [3,9,8,9,10,9,4,9,99,-1,8]

OP_CODE_ADD = 1.freeze
OP_CODE_MULTIPLY = 2.freeze
OP_CODE_INPUT = 3.freeze
OP_CODE_OUTPUT = 4.freeze
OP_CODE_JUMP_IF_TRUE = 5.freeze
OP_CODE_JUMP_IF_FALSE = 6.freeze
OP_CODE_LESS_THAN = 7.freeze
OP_CODE_EQUALS = 8.freeze
OP_CODE_HALT = 99.freeze

PARAM_MODE_POSITION = 0.freeze
PARAM_MODE_IMMEDIATE = 1.freeze

I_PTR_JUMP_TWO = 2.freeze
I_PTR_JUMP_THREE = 3.freeze
I_PTR_JUMP_FOUR = 4.freeze

def parse_instruction(instr)
  op_code = instr % 100
  op_one_mode = (instr / 100) % 10
  op_two_mode = (instr / 1000) % 10
  op_three_mode = (instr / 10000) % 10    # TODO: Unused; always assumed to be position

  jump = -1

  case op_code
  when OP_CODE_ADD, OP_CODE_MULTIPLY, OP_CODE_LESS_THAN, OP_CODE_EQUALS
    jump = I_PTR_JUMP_FOUR

  when OP_CODE_JUMP_IF_TRUE, OP_CODE_JUMP_IF_FALSE
    jump = I_PTR_JUMP_THREE

  when OP_CODE_INPUT, OP_CODE_OUTPUT
    jump = I_PTR_JUMP_TWO

  when OP_CODE_HALT
    puts "Halt instruction encountered. Exiting..."
    exit

  else
    puts "ERROR: Invalid instruction encountered (op code: #{op_code}). Exiting..."
    exit

  end

  puts "Op code: #{op_code}"
  puts "Param one mode: #{op_one_mode}"
  puts "Param two mode: #{op_two_mode}"
  puts "Param three mode: #{op_three_mode}"
  puts "Jump: #{jump}"

  [op_code, op_one_mode, op_two_mode, op_three_mode, jump]

end

def extract_param_value(val, arr, param_mode)
  ret_val = -1

  case param_mode
  when PARAM_MODE_POSITION
    puts "Using value at position: #{val}"
    ret_val = arr[val]

  when PARAM_MODE_IMMEDIATE
    ret_val = val

  else
    puts "Invalid param mode encountered: #{param_mode}. Returning -1"
  end

  puts "Val: #{ret_val}"

  ret_val
end

def intcode_program(arr_orig)
  arr = arr_orig

  puts "Array: #{arr}, length: #{arr.length}"

  i_ptr = 0

  while i_ptr < arr.length
    instr = arr[i_ptr]

    o_code, p_mode_one, p_mode_two, p_mode_three, jump = parse_instruction(instr)

    param_one = -1
    param_two = -1
    dest = -1

    if o_code == OP_CODE_ADD || o_code == OP_CODE_MULTIPLY || OP_CODE_LESS_THAN || OP_CODE_EQUALS
      # Determine first param value
      param_one = extract_param_value(arr[i_ptr + 1], arr, p_mode_one)

      # Determine second param value
      param_two = extract_param_value(arr[i_ptr + 2], arr, p_mode_two)

      # Determine destination
      dest = arr[i_ptr + 3]

    else
      dest = arr[i_ptr + 1]
    end


    # Process instruction
    case o_code
    when OP_CODE_ADD
      arr[dest] = param_one + param_two
      puts "Performing add operation (#{param_one} + #{param_two} = #{arr[dest]}) and storing at position: #{dest}"

    when OP_CODE_MULTIPLY
      arr[dest] = param_one * param_two
      puts "Performing multiplication operation (#{param_one} * #{param_two} = #{arr[dest]}) and storing at position: #{dest}"

    when OP_CODE_INPUT
      puts "Provide ID of system to test: "
      val = gets
      puts "Using system ID: #{val}"
      arr[dest] = val.to_i

    when OP_CODE_OUTPUT
      puts "\n*** TEST DIFF = #{param_one}***\n\n"
      #puts "\n*** TEST DIFF = #{arr[dest]}***\n\n"

    when OP_CODE_JUMP_IF_TRUE
      puts "Perfoming jump if #{param_one} != 0"
      jump = param_two - i_ptr if param_one != 0

    when OP_CODE_JUMP_IF_FALSE
      puts "Perfoming jump if #{param_one} == 0"
      jump = param_two - i_ptr if param_one == 0

    when OP_CODE_LESS_THAN
      val = param_one < param_two ? 1 : 0
      arr[dest] = val

    when OP_CODE_EQUALS
      val = param_one == param_two ? 1 : 0
      arr[dest] = val

    else
      puts "ERROR: Invalid instruction encountered (op code: #{op_code}). Exiting..."
    end

    puts "next instruction: #{i_ptr + jump} (jumping: #{jump})"

    i_ptr += jump
  end

  puts "\n"

  arr
end

puts "Running intcode program"
intcode_program(arr)
