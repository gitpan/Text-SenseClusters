#!/usr/local/bin/perl -w

# This tiny perl script checks if the created xml is well-formed.
# Knowing this helps in deciding whether to display an xml formated
# file or a plain-text file.

use XML::Simple;

$inpfile = shift @ARGV;

my $xml = XMLin($inpfile);
