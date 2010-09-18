#!/usr/bin/perl

if (scalar(@ARGV) != 1) {
	print "read-jeff <source-dir>\n";
	exit(1);
}

$dir = $ARGV[0];

@list_of_files = `find "$dir" -name '*.doc'`;

while (1) {
	
	$pick = int rand(scalar(@list_of_files));
	$file = $list_of_files[$pick];
	chomp $file;

	print "$file\n";
	`espeak "$file"`;

	$temp = `mktemp`;
	chomp $temp;

	`wvText "$file" "$temp"`;

	`espeak -s 120 -f "$temp"`;
	`rm $temp`;
}
