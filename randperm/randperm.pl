#!/usr/bin/perl

@lines = ();

while (<>) {
	push(@lines, $_);
}

# Dunno why but the shuffle function ain't great
@lines = shuffle(@lines);
@lines = shuffle(@lines);
@lines = shuffle(@lines);
@lines = shuffle(@lines);

foreach $line (@lines) {
	print $line;
}

sub shuffle {
	my @list = @_;
	my @ranks = ( );
	my @indices = ( );
	
	for (my $i=0; $i<scalar(@list); $i++) {
		$ranks[$i]   = rand(1);
		$indices[$i] = $i
	}
	
	@indices = sort { $ranks[$a] cmp $ranks[$b] } @indices;
	
	my @out_list = ( );
	
	for (my $i=0; $i<scalar(@list); $i++) {
		@out_list[$i] = $list[$indices[$i]];
	}
	
	return @out_list;
}
