#!/usr/local/bin/perl -w

=head1 NAME

frequency.pl Display distribution of senses in Senseval-2 file

=head1 SYNOPSIS

Displays distribution of senses in a given Senseval-2 file. 

=head1 USGAE

Usage: frequency.pl [OPTIONS] SOURCE

Type 'frequency.pl --help' for quick summary of the Options.

=head1 INPUT

=head2 Required Arguments:

=head4 SOURCE 

SOURCE should be a Senseval-2 formatted file. The sense ids are searched by 
matching a regex /sense\s*id="S"/.

An instance having multiple sense ids should appear only once with multiple
<answer> tags. e.g. If an instance IID has 2 sense ids SID1 and SID2, then
in the SOURCE file, instance IID should be formatted as -

 <instance id="IID"> 
 <answer instance="IID" senseid="SID1"/>
 <answer instance="IID" senseid="SID2"/>
 <context>
	Context Data comes here ....
 </context>
 </instance>

=head2 Optional Arguments:

=head4 --help

Displays this message.

=head4 --version

Displays the version information.

=head1 OUTPUT

Output displays 

1. Total number of instances in SOURCE 

These are counted by matching regex /instance id=\"ID\"/ for unique 
instance ids.

2. Total number of distinct sense tags found in SOURCE 

These are searched by matching a regex /sense\s*id="S"/.

3. Sense Distribution 

Output shows 

<sense id="S" percent="P"/>

for each sense id found in SOURCE. P is the percentage frequency of the 
sense S.

4. % of Majority sense

This will be the highest sense percentage found in SOURCE.

=head2 Sample Output 

 <sense id="begin%2:30:00::" percent="59.49"/>
 <sense id="begin%2:30:01::" percent="13.38"/>
 <sense id="begin%2:42:00::" percent="4.70"/>
 <sense id="begin%2:42:03::" percent="3.44"/>
 <sense id="begin%2:42:04::" percent="18.99"/>
 Total Instances = 548
 Total Distinct Senses=5
 Distribution={59.49,18.99,13.38,4.70,3.44}
 % of Majority Sense = 59.49

Shows that there are total 548 instances and 5 senses. 

The senses are distributed with frequencies 

{59.49,18.99,13.38,4.70,3.44}

where majority sense has frequency = 59.49

The <sense> tags show the frequency of each individual tag.


=head1 AUTHOR

Amruta Purandare, Ted Pedersen.
University of Minnesota, Duluth.

=head1 COPYRIGHT

Copyright (c) 2002-2005,
Amruta Purandare, University of Pittsburgh. amruta@cs.pitt.edu
Ted Pedersen, University of Minnesota, Duluth. tpederse@umn.edu

This program is free software; you can
redistribute it and/or modify it under the
terms of the GNU General Public License as
published by the Free Software Foundation;
either version 2 of the License, or (at your
option) any later version.

This program is distributed in the hope
that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty
of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE. See the GNU General Public License
for more details.

You should have received a copy of the GNU
General Public License along with this program;
if not, write to

The Free Software Foundation, Inc.,
59 Temple Place - Suite 330,
Boston, MA  02111-1307, USA.

=cut

###############################################################################

#                               THE CODE STARTS HERE

###############################################################################

#                           ================================
#                            COMMAND LINE OPTIONS AND USAGE
#                           ================================

# command line options
use Getopt::Long;
GetOptions ("help","version");
# show help option
if(defined $opt_help)
{
        $opt_help=1;
        &showhelp();
        exit;
}

# show version information
if(defined $opt_version)
{
        $opt_version=1;
        &showversion();
        exit;
}

# show minimal usage message if no arguments
if($#ARGV<0)
{
        &showminimal();
        exit;
}

#############################################################################

#                       ================================
#                          INITIALIZATION AND INPUT
#                       ================================

#$0 contains the program name along with
#the complete path. Extract just the program
#name and use in error messages
$0=~s/.*\/(.+)/$1/;

if(!defined $ARGV[0])
{
        print STDERR "ERROR($0):
        Please specify a Senseval-2 formatted Source file...\n";
        exit;
}
#accept input 
$infile=$ARGV[0];

#check if exists
if(!-e $infile)
{
	print STDERR "ERROR($0):
	Source file <$infile> doesn't exist ... \n";
	exit;
}
open(IN,$infile) || die "ERROR($0):
	Error(code=$!) in opening Source file <$infile>.\n";

##############################################################################

#			==============================
#				Get Tag Frequency
#			==============================

$total=0;
$instances=0;
$histo={};

while(<IN>)
{
	if(/instance id=\"([^\"]+)\"/)
	{
		if(defined $instance_hash{$1})
		{
			print STDERR "ERROR($0):
	Instance Id <$1> is repeated in file <$infile>.\n";
		}
		$instances++;
		$instance_hash{$1}=1;
	}
        # get the sense tag
        if(/sense\s*id=\"([^\"]+)\"/)
        {
               $histo{$1}++;
               $total++;
        }
}

# now find percentages
foreach (sort keys %histo)
{
        $histo{$_}=sprintf("%2.2f",$histo{$_}/$total*100);
        print "<sense id=\"$_\" percent=\"$histo{$_}\"\/>\n";
        push @sense_distri,$histo{$_};
	delete $histo{$_};
}
# sort frequency array in descending order 
@sorted=sort {$b <=> $a} @sense_distri;
$distinct=$#sense_distri+1;
# display
print "Total Instances = $instances\n";
print "Total Distinct Senses=$distinct\nDistribution={".join(",",@sorted)."}\n";
if(defined $sorted[0])
{
	print "% of Majority Sense = $sorted[0]\n";
}
close IN;

##############################################################################

#                      ==========================
#                          SUBROUTINE SECTION
#                      ==========================

#-----------------------------------------------------------------------------
#show minimal usage message
sub showminimal()
{
        print "Usage: frequency.pl [OPTIONS] SOURCE";
        print "\nTYPE frequency.pl --help for help\n";
}

#-----------------------------------------------------------------------------
#show help
sub showhelp()
{
	print "Usage:  frequency.pl [OPTIONS] SOURCE 

Displays total number of instances, total distinct senses, sense distribution 
and % frequency of majority sense in a given Senseval-2 formatted SOURCE file. 

SOURCE 
	Specify a Senseval-2 formatted file for which sense distribution is 
	to be shown. Sense ids for instances in SOURCE are searched by 
	matching regex /sense\\s*id=\"S\"/. 
	
OPTIONS:
--help
        Displays this message.
--version
        Displays the version information.\n";
}

#------------------------------------------------------------------------------
#version information
sub showversion()
{
        print "frequency.pl      -       Version 0.11";
        print "
Displays sense distribution in a given Senseval-2 file.";
        print "\nCopyright (c) 2002-2005, Amruta Purandare, Ted Pedersen.\n";
        print "Date of Last Update:     05/07/2003\n";
}

#############################################################################

