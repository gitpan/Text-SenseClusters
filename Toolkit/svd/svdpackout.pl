#!/usr/local/bin/perl -w

=head1 NAME

svdpackout.pl - Reconstruct post-SVD form of matrix from singular values output by SVDPACKC

=head1 SYNOPSIS

 svdpackout.pl [OPTIONS] lav2 lao2

Type C<svdpackout.pl --help> for a quick summary of options

=head1 DESCRIPTION

Reconstructs a matrix from its singular values and singular vectors created 
by SVDPACKC. The result of this is essentially a "smoothed" matrix equal in size to 
the original pre-SVDPACKC matrix, but where the non-significant dimenions have been 
removed.

=head1 INPUT

=head2 Required Arguments:

=head3 lav2 

Binary output file created by SVDPACKC's las2

=head3 lao2

ASCII output file created by SVDPACKC's las2

=head2 Optional Arguments:

=head4 --rowonly 

Only the row vectors are reconstructed. By default, svdpackout reconstructs entire matrix. 

=head4 --format FORM

Specifies numeric format for representing output matrix values. 
The following formats are supported with --format :

=over 
=item iN - Output matrix will contain integer values each occupying N spaces

=item fM.N - Output matrix will contain real values each occupying total M spaces of which last N digits show fractional part. M spaces for each entry include the decimal point and +/- sign if any.
=back

Default format value is f16.10.

=head3 Other Options :

=head4 --help

Displays this message.

=head4 --version

Displays the version information.

=head1 OUTPUT

svdpackout.pl displays a matrix reconstructed from the Singular Triplets 
created by SVDPACKC. By default, entire matrix (product of left and right
signular vectors and singular values) is reconstructed. When --rowonly is ON, 
only the reduced row vectors are built.

=head1 SYSTEM REQUIREMENTS

=over 

=item SVDPACKC - L<http://netlib.org/svdpack/> (also available in /External)

=item PDL - L<http://search.cpan.org/dist/PDL/>

=back

=head1 AUTHORS

 Amruta Purandare, University of Pittsburgh

 Ted Pedersen, University of Minnesota, Duluth
 tpederse at d.umn.edu

=head1 COPYRIGHT

Copyright (c) 2002-2008, Amruta Purandare and Ted Pedersen

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

# $0 contains the program name along with the 
# complete path. Extract just the program
# name and use in error messages
$0=~s/.*\/(.+)/$1/;

use PDL;
use PDL::NiceSlice;
use PDL::Primitive;

###############################################################################

#                           ================================
#                            COMMAND LINE OPTIONS AND USAGE
#                           ================================

# command line options
use Getopt::Long;
GetOptions ("help","version","format=s","rowonly");
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

# formatting matrix values
if(defined $opt_format)
{
	# integer format
	if($opt_format=~/^i(\d+)$/)
	{
		$format="%$1d";
		$lower_format="-";
                while(length($lower_format)<($1-1))
                {
                        $lower_format.="9";
                }
                if($lower_format eq "-")
                {
                        $lower_format="0";
                }
                $upper_format="";
                while(length($upper_format)<($1-1))
                {
                        $upper_format.="9";
                }
	}
	# floating point format
	elsif($opt_format=~/^f(\d+)\.(\d+)$/)
	{
		$format="%$1.$2f";
		$lower_format="-";
                while(length($lower_format)<($1-$2-2))
                {
                        $lower_format.="9";
                }
                $lower_format.=".";
                while(length($lower_format)<($1-1))
                {
                        $lower_format.="9";
                }

                $upper_format="";
                while(length($upper_format)<($1-$2-2))
                {
                        $upper_format.="9";
                }
                $upper_format.=".";
                while(length($upper_format)<($1-1))
                {
                        $upper_format.="9";
                }
	}
	else
	{
		print STDERR "ERROR($0):
	Wrong format value --format=$opt_format.\n";
		exit;
	}
}
# default
else
{
#	$format="%8.3f";
	$format="%16.10f";
	$lower_format="-999.9999999999";
        $upper_format="9999.9999999999";
}

# show minimal usage message if no arguments
if($#ARGV<1)
{
        &showminimal();
        exit;
}

#############################################################################

#                       ================================
#                          INITIALIZATION AND INPUT
#                       ================================

# accept lav2 file name
$lav2=$ARGV[0];
if(!-e $lav2)
{
        print STDERR "ERROR($0):
        lav2 file <$lav2> doesn't exist...\n";
        exit;
}
open(LAV2,$lav2) || die "Error($0):
        Error(code=$!) in opening lav2 file <$lav2>.\n";

#accept lao2 file name
$lao2=$ARGV[1];
if(!-e $lao2)
{
        print STDERR "ERROR($0):
        lao2 file <$lao2> doesn't exist...\n";
        exit;
}
open(LAO2,$lao2) || die "Error($0):
        Error(code=$!) in opening lao2 file <$lao2>.\n";

##############################################################################

#			========================
#			      CODE SECTION
#			========================

# -------------------
# Reading file lao2 
# -------------------
while(<LAO2>)
{
	# e-pairs = K, reduction factor specified by the user
       	if(/MAX. NO. OF EIGENPAIRS\s*=\s*(\d+)/)
       	{
                $k=$1;
       	}
	# rows
       	if(/NO\. OF TERMS\s*\(ROWS\)\s*=\s*(\d+)/)
       	{
                $rows=$1;
                next;
       	}
	# cols
       	if(/NO\. OF DOCUMENTS\s*\(COLS\)\s*=\s*(\d+)/)
       	{
                $cols=$1;
                next;
       	}
	# nsig
       	if(/NSIG\s*=\s*(\d+)/)
       	{
                $nsig=$1;
                next;
       	}
	# after this the S-values follow
       	if(/COMPUTED S-VALUES/)
       	{
                last;
       	}
}

# check: valid values of rows, cols, k, nsig 
# are obtained from lao2
if(!defined $rows)
{
        print STDERR "ERROR($0):
	#ROWS not found in lao2 file <$lao2>.\n";
        exit;
}
if(!defined $cols)
{
	print STDERR "ERROR($0):
        #COLS not found in lao2 file <$lao2>.\n";
        exit;
}
if(!defined $nsig)
{
	print STDERR "ERROR($0):
        NSIG value not found in lao2 file <$lao2>.\n";
        exit;
}
if(!defined $k)
{
	print STDERR "ERROR($0):
        NO. OF EIGENPAIRS not found in lao2 file <$lao2>.\n";
        exit;
}

# one line is blank in lao2 after "COMPUTED S-VALUES..." line
<LAO2>;

$d=zeroes($nsig);
# reading singular values

# singular values are reverse ordered in lao2 
# such that the most significant/highest value 
# occurs last 
for ($i=$nsig-1 ; $i>=0 ; $i--)
{
        $line=<LAO2>;
	if(!defined $line)
	{
		print STDERR "ERROR($0):
	lao2 file <$lao2> doesn't have $nsig S-values.\n";
		exit;
	}
        $line=~s/^\s+//;
	# line containing S-value contains 
	# ellipses, index of S-value, S-value, RES NORMS
        ($ellipses,$ind,$sval,@rest)=split(/\s+/,$line);
	# we only need the S-value
        undef $ellipses;
        undef $ind;
        undef @rest;
       	set($d,$i,$sval);
}

# taking minimum of #nsig and k
$k=($k<$nsig) ? $k : $nsig;

# --------------------
# Reading file lav2
# --------------------

# binary file needs to specify
# binmode
binmode LAV2;

# lav2 contains some header information
# before the actual S-vectors

# the header length is length(pack(2l+d))
$longsize=length(pack("l",()));
$doubsize=length(pack("d",()));

# right S-vectors start after header
$vstart=(2*$longsize) + $doubsize;

# left S-vectors start after right S-vectors
$ustart=$vstart+($cols*$nsig*$doubsize);

# printing rows cols on first line 
if(!defined $opt_rowonly)
{
	print "$rows $cols\n";
}
else
{
	print "$rows $k\n";
}
# reconstruct full matrix
if(!defined $opt_rowonly)
{
	$u=zeroes($k);
	$v=zeroes($k);
	for($i=0;$i<$rows;$i++)
	{
		$u->inplace->zeroes;
		for($m=$nsig-1;$m>=$nsig-$k;$m--)
		{
			$index=$ustart+((($m*$rows)+$i)*$doubsize);
			seek(LAV2,$index,0);
			read(LAV2,$value,$doubsize);
			if(!defined $value)
			{
				print STDERR "ERROR($0):
	lav2 file <$lav2> doesn't have sufficient S-vectors.\n";
				exit;
			}
			#unpacking
			$value=unpack("d",$value);
			set($u,$nsig-1-$m,$value);
		}
		for($j=0;$j<$cols;$j++)
		{
			$v->inplace->zeroes;
			for($m=$nsig-1;$m>=$nsig-$k;$m--)
			{
				$index=$vstart+((($m*$cols)+$j)*$doubsize);
				seek(LAV2,$index,0);
	                        read(LAV2,$value,$doubsize);
        	                if(!defined $value)
                	        {
                        	        print STDERR "ERROR($0):
        lav2 file <$lav2> doesn't have sufficient S-vectors.\n";
                                	exit;
	                        }
        	                # unpacking
                	        $value = unpack("d", $value);
                        	set($v,$nsig-1-$m,$value);
			}
			$recon=$u * $d(0:$k-1) x transpose $v;
			$number=sprintf($format,$recon->sclr);
			# replacing -0.0+ to 0
	                if($number=~/\-(0.)?0+/)
        	        {
                	        $number=0;
                	}
			if($number<$lower_format)
			{
				print STDERR "ERROR($0):
        Floating point underflow.
        Value <$number> can't be represented with format $format.\n";
	                        exit 1;
			}
			if($number>$upper_format)
        	        {
                        	print STDERR "ERROR($0):
        Floating point overflow.
        Value <$number> can't be represented with format $format.\n";
                	        exit 1;
	                }
	                printf($format,$number);
		}
		print "\n";
	}
}
# recontruct only row vectors 
else
{
	for($i=0;$i<$rows;$i++)
	{	
		for($j=$nsig-1;$j>=$nsig-$k;$j--)
		{
			# computing index of each value from beginning of file
			$index = $ustart+((($j*$rows)+$i)*$doubsize);
			seek(LAV2,$index,0);
			read(LAV2,$value,$doubsize);
			if(!defined $value)
        	        {
                	        print STDERR "ERROR($0):
        lav2 file <$lav2> doesn't have sufficient left S-vectors.\n";
                        	exit;
	                }
        	        # unpacking
                	$value = unpack("d", $value);
			$recon = $value * sqrt at($d,$nsig-1-$j);
			$number=sprintf($format,$recon);
			# replacing -0.0+ to 0
			if($number=~/\-(0.)?0+/)
			{
				$number=0;
			}
			if($number<$lower_format)
        	        {
	                        print STDERR "ERROR($0):
        Floating point underflow.
        Value <$number> can't be represented with format $format.\n";
                        	exit 1;
                	}
        	        if($number>$upper_format)
	                {
                	        print STDERR "ERROR($0):
        Floating point overflow.
        Value <$number> can't be represented with format $format.\n";
        	                exit 1;
	                }
			printf($format,$number);
		}
		print "\n";
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
        print "Usage: svdpackout.pl [OPTIONS] LAV2 LAO2";
        print "\nTYPE svdpackout.pl --help for help\n";
}

#-----------------------------------------------------------------------------
#show help
sub showhelp()
{
	print "Usage:  svdpackout.pl [OPTIONS] LAV2 LAO2 

Reconstructs a rank-k matrix from output files LAV2 and LAO2 created by las2 
program of SVDPACKC.

LAV2
	Binary output file created by las2
	
LAO2
	ASCII output file created by las2

OPTIONS:

--rowonly 
	Reconstructs only row vectors.

--format FORM
	Specifies the format for displaying output matrix. Default is f16.10.

--help
        Displays this message.
--version
        Displays the version information.

Type 'perldoc svdpackout.pl' to view detailed documentation of svdpackout.\n";
}

#------------------------------------------------------------------------------
#version information
sub showversion()
{
#        print "svdpackout.pl      -       Version 0.04\n";
	print '$Id: svdpackout.pl,v 1.10 2008/03/30 04:19:02 tpederse Exp $';
        print "\nReconstruct a rank-k matrix from output of SVDPACKC\n";
#        print "Copyright (c) 2002-2005, Amruta Purandare & Ted Pedersen.\n";
#        print "Date of Last Update:     06/02/2004\n";
}

#############################################################################

