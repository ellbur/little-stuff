#!/usr/bin/perl

print "object bar {\n";

my $max = 100;

for my $i (0 .. $max) {
    my $thing = '1';
    for my $j (0 .. $i) {
        $thing = "Some($thing)";
    }
    print <<__END__
    implicit def a${i} = $thing;
__END__
}

my $options = 'Int';
for my $i (0 .. ($max-2)) {
    $options = "Option[$options]";
}

print <<__END__
    def main(args: Array[String]) {
        println {
            implicitly[$options]
        }
        println(foo.z)
    }
__END__
    ;

print "}\n";

