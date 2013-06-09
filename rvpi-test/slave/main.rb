
puts ''

@main = VPI.vpi_handle_by_name('main', nil)

def dump_state
    p (breakup_memory @main.all_memory.intVal).map { |bits|
        decode_cell_bits bits
    }
    puts "master_has_control = #{@main.master_has_control.decStrVal}"
    puts "slave_read_addr    = #{@main.slave_read_addr.decStrVal}"
    puts "slave_write_addr   = #{@main.slave_write_addr.decStrVal}"
    puts "slave_write        = #{@main.slave_write.decStrVal}"
    puts "master_read_addr    = #{@main.master_read_addr.decStrVal}"
    puts "master_write_addr   = #{@main.master_write_addr.decStrVal}"
    puts "master_write        = #{@main.master_write.decStrVal}"
    puts "read_addr          = #{@main.read_addr.decStrVal}"
    puts "write_addr         = #{@main.write_addr.decStrVal}"
    puts "write              = #{@main.write.decStrVal}"
    puts "write_node         = #{@main.write_node.decStrVal}"
    puts "*read_node*        = #{@main.read_node.decStrVal}"
    puts ""
end

def breakup_memory bits
    (0...4).map do |j|
        (bits >> (j*12)) & 0b00_00000_00000
    end
end

def decode_cell_bits bits
    type = bits & 0b11_00000_00000
    car  = bits & 0b00_11111_00000
    cdr  = bits & 0b00_00000_11111
    
    "#{decode_type(type)}(#{car})(#{cdr})"
end

def decode_type type
    case (type)
    when 0b00
        'S'
    when 0b01
        'K'
    when 0b10
        '.'
    when 0b11
        'F'
    end
end

def step
    @main.clk.intVal = 0
    @main.advance_time
    @main.clk.intVal = 1
    @main.advance_time
end

def reset
    @main.reset.intVal = 0
    step
    @main.reset.intVal = 1
end

@main.reset.intVal = 1
@main.clk.intVal = 0

reset

dump_state

puts ''

