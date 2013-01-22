#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'XML::Simple::Tiny' ) || print "Bail out!\n";
}

diag( "Testing XML::Simple::Tiny $XML::Simple::Tiny::VERSION, Perl $], $^X" );
