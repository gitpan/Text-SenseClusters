#!/usr/local/bin/perl -w

=head1 NAME

sval2plain.pl Convert Senseval-2 data into plain text format

=head1 SYNOPSIS

Converts a given file from Senseval-2 format into plain text format. Each 
line of the plain text files contains a single context. 

=head1 USGAE

sval2plain.pl [OPTIONS] SVAL2

=head1 INPUT

=head2 Required Arguments:

=head3 SVAL2

Input file in Senseval-2 format that is to be converted into plain text format.

=head2 Optional Arguments:

=head3 --help

Displays the summary of command line options.

=head3 --version

Displays the version information.

=head1 OUTPUT

sval2plain displays the given SVAL2 file in plain text format with the 
contextual data of each instance on a separate line. Specifically, each
i'th line displayed on STDOUT shows the context of the i'th instance in
the given SVAL2 file.

=head1 AUTHOR

Ted Pedersen, University of Minnesota, Duluth

Amruta Purandare, University of Minnesota, Duluth

=head1 COPYRIGHT

Copyright (c) 2002-2006,

 Ted Pedersen, University of Minnesota, Duluth.
 tpederse@umn.edu

 Amruta Purandare, University of Pittsburgh.
 amruta@cs.pitt.edu

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to

 The Free Software Foundation, Inc.,
 59 Temple Place - Suite 330,
 Boston, MA  02111-1307, USA.

=cut

###############################################################################

#                               THE CODE STARTS HERE

#$0 contains the program name along with
#the complete path. Extract just the program
#name and use in error messages
$0=~s/.*\/(.+)/$1/;

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

#accept the input file name
$infile=$ARGV[0];
if(!-e $infile)
{
        print STDERR "ERROR($0):
        SVAL2 file <$infile> doesn't exist...\n";
        exit;
}
open(IN,$infile) || die "Error($0):
        Error(code=$!) in opening <$infile> file.\n";

##############################################################################

$data_start=0;
$context="";
while(<IN>)
{
	chomp;
	if(/<\/context>/)
        {
		print $context . "\n";
                $data_start=0;
		$context="";
        }
	if($data_start==1)
	{
		$context.="$_ ";
	}
	if(/<context>/)
	{
		$data_start=1;
	}
}

##############################################################################

#                      ==========================
#                          SUBROUTINE SECTION
#                      ==========================

#-----------------------------------------------------------------------------
#show minimal usage message
sub showminimal()
{
        print "Usage: sval2plain.pl [OPTIONS] SVAL2";
        print "\nTYPE sval2plain.pl --help for help\n";
}

#-----------------------------------------------------------------------------
#show help
sub showhelp()
{
	print "Usage:  sval2plain.pl [OPTIONS] SVAL2

Converts a given file in Senseval-2 format to plain text format.

SVAL2
	Input file in Senseval-2 format.

OPTIONS:
--help
        Displays this message.
--version
        Displays the version information.

Type 'perldoc sval2plain.pl' to view detailed documentation of sval2plain.\n";
}

#------------------------------------------------------------------------------
#version information
sub showversion()
{
	print '$Id: sval2plain.pl,v 1.6 2008/03/24 00:56:59 tpederse Exp $';
        print "Copyright (c) 2002-2006, Ted Pedersen & Amruta Purandare\n";
#        print "sval2plain.pl      -       Version 0.01\n";
#        print "Converts a given file in Senseval-2 format into plain text format.\n";
#        print "Date of Last Update:     06/02/2004\n";
}

#############################################################################

