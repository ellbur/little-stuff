
# Returns the content of ctrl.in as a string.
sub gen_ctrl_in {
    my %p = %{shift()};
    
    my $ev_per_adu   = $p{ev_per_adu};
    my $carbon_hw    = $p{carbon_hw};
    my $carbon_gap   = $p{carbon_gap};
    my $carbon_param = $p{carbon_param};
    my $fast_trig    = $p{fast_trig};
    my $fast_bigtrig = $p{fast_bigtrig};
    my $slow_trig    = $p{slow_trig};
    my $slow_bigtrig = $p{slow_bigtrig};
    my $sym          = $p{sym};
    my $dur          = $p{dur};
    my $lag          = $p{lag};

    # Conversion to funny format

    my $carbon_hw_str = ($carbon_hw - 1) . "";
    my $carbon_gap_str = ($carbon_gap - 1) . "";
    my $carbon_param_str = int($carbon_param/$ev_per_adu * $carbon_hw * 4) . "";

    sub slow_hex {
        sprintf "x%x", (0x80000000 + shift)
    }

    my $fast_trig_str = int($fast_trig/$ev_per_adu*4) . "";
    my $fast_bigtrig_str = int($fast_bigtrig/$ev_per_adu*4) . "";

    my $slow_trig_str = slow_hex(int($slow_trig/$ev_per_adu*4)) . "";
    my $slow_bigtrig_str = slow_hex(int($slow_bigtrig/$ev_per_adu*4)) . "";

    my $sym_str = $sym . "";
    my $dur_str = $dur . "";
    my $lag_str = $lag . "";

    <<__END__

# set DSP clock to 100MHz
CLOCK 	10 ns

RESET 	10
WRITE PULSE_CTRL 	x00000004
NOP 2
WRITE PULSE_CTRL 	x00000000

# set fast pileup detector
WRITE DET_TRIG 		${fast_trig_str       }  # $fast_trig eV
WRITE DET_BIGTRIG	${fast_bigtrig_str    }  # $fast_bigtrig eV
WRITE DET_RESET 	0

# set slow pileup detector
WRITE DET_TRIG 		${slow_trig_str       } # ${slow_trig} eV
WRITE DET_BIGTRIG	${slow_bigtrig_str    } # ${slow_bigtrig} eV
WRITE DET_RESET 	x80000000

# set carbon filter
# Note that this gap (and risefall) value is actually 1 less than the actual gap value.
# So, in R_VOID DppFilterConfigure(R_INT index, R_UINT halflength, R_UINT gap)
# in dpp.cpp, we see:
# *(volatile unsigned *)FPGA_FILT_RISEFALL = (index << 28) | (halflength - 1);
# *(volatile unsigned *)FPGA_FILT_GAP = (index << 28) | (gap - 1);
WRITE FILT_RISEFALL	${carbon_hw_str   } # $carbon_hw
WRITE FILT_GAP		${carbon_gap_str  } # $carbon_gap
WRITE FILT_THRESH	${carbon_param_str} # $carbon_param eV

WRITE CARB_SYM 		$sym_str          # $sym
WRITE CARB_DURATION	$dur_str          # $dur
WRITE CARB_LAG		$lag_str          # $lag

# filter1 set
WRITE FILT_RISEFALL	x10000025
WRITE FILT_GAP		x10000006
WRITE FILT_INHIBIT	x10000055

# filter2 set
WRITE FILT_RISEFALL	x20000009
WRITE FILT_GAP		x20000006
WRITE FILT_INHIBIT	x20000070

# filter enable
WRITE FILT_ENABLE 	7

# run
WRITE PULSE_DMABLOCK 	7
WRITE PULSE_CREDIT	100
WRITE PULSE_CTRL 	x00000001

# stop
#WRITE PULSE_CTRL 	x00000000
# reset
#WRITE PULSE_CTRL 	x00000004
#WAITR 200 us
#WRITE PULSE_CTRL 	x00000000

# run
#WRITE PULSE_CTRL 	x00000001


#WRITE DEAD_SEL 		0
#READ DEAD_COUNTER
#READ DEAD_COUNTER
#READ DEAD_COUNTER
#READ DEAD_COUNTER
#READ DEAD_COUNTER
#READ DEAD_COUNTER

#DO
#  INT 2
#  READ 	PULSE_DATA
#  READ 	PULSE_DATA
#  READ 	PULSE_DATA
#  READ 	PULSE_DATA
#  READ 	PULSE_DATA
#  READ 	PULSE_DATA
#  READ 	PULSE_DATA
#  READ 	PULSE_DATA
#LOOP 100
#
#NOP 5

__END__
    
}

1;

