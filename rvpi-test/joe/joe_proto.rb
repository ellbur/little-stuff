if RubyVPI::USE_PROTOTYPE
  always do
    wait until DUT.YOUR_CLOCK_SIGNAL_HERE.posedge?

    # discard old outputs
          DUT.c.x!
    
    # process new inputs
          # some_interesting_process( DUT.a )
          # some_interesting_process( DUT.b )
    
    # produce new outputs
          # DUT.c = some interesting output
      end
end
