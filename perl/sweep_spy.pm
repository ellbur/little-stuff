
# Tools for spying on the result of a simulation.

use Verilog::VCD qw(parse_vcd);
use Data::Dumper;

sub load_vcd {
    my $path = shift;
    print "opening $path\n";
    organize_vcd(parse_vcd(path));
}

# Organizes the funny structure returned from parse_vcd
sub organize_vcd {
    my $vcd = shift;
    print Dumper($vcd);
    $vcd
}

sub num_edges_detected {
    my $vcd = shift;
}

1;

