# Simulates the design under test for one clock cycle.
def DUT.cycle!
  YOUR_CLOCK_SIGNAL_HERE.high!
  advance_time

  YOUR_CLOCK_SIGNAL_HERE.low!
  advance_time
end

# Brings the design under test into a blank state.
def DUT.reset!
  YOUR_RESET_SIGNAL_HERE.high!
  cycle!
  YOUR_RESET_SIGNAL_HERE.low!
end
