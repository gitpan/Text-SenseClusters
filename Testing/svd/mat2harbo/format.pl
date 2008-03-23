#!/usr/local/bin/perl
open(IN,$ARGV[0]);
$l1=<IN>;
print $l1;
while(<IN>)
{
	@ele=split(/\s+/);
	foreach $entry (@ele)
	{
		printf("%10.7f",$entry);
	}
	print "\n";
}
