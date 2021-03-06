#!/usr/local/bin/perl -w

=head1 NAME

order2vec.pl - Convert Senseval-2 contexts into second order context vectors in Cluto format

=head1 SYNOPSIS

 order2vec.pl [OPTIONS] SVAL2 WORDVEC FEATURE_REGEX

Type C<order2vec.pl --help> for a quick summary of options.

=head1 DESCRIPTION

Creates second order context vectors by averaging word or feature vectors of 
the contextual features.

=head1 INPUT

=head2 Required Arguments:

=head3 SVAL2 

A tokenized, preprocessed and well formatted Senseval-2 instance file 
showing instances whose context vectors are to be generated.

order2vec creates a context vector for each instance in the given SVAL2 file 
by averaging the word or feature vectors of the features that appear in the 
context.

=head3 WORDVEC

Should be one of the following type of files:

=over

=item 1.

A file containing word vectors as created by program wordvec.pl 

=item 2.

A file containing feature vectors as created by order1vec.pl, using its
--transpose option.

=back

Each line in WORDVEC should show a word or feature vector of the feature 
represented by the corresponding line in the FEATURE_REGEX file. 

order2vec accepts WORDVEC in both sparse and dense formats. If WORDVEC is 
in dense format, switch --dense should be selected.

=head3 FEATURE_REGEX

Should be one of the following type of files:

=over

=item 1.

The output file generated by running nsp2regex.pl on the FEATURE file as 
generated by program wordvec.pl while creating the WORDVEC file.

=item 2. 

The TEST_REGEX file created by order1vec.pl using its --testregex option, while 
creating the feature-by-context output file using the --transpose option. 

=back

Each line in FEATURE_REGEX file should show a regular expression for a feature 
whose feature vector appears on the corresponding line in the WORDVEC file. 
FEATURE_REGEX should be formatted like the output of the nsp2regex.pl program.

Sample FEATURE_REGEX files:

=over

=item 1.

A file output by nsp2regex.pl when it is run on the file produced by --feats 
option of wordvec.pl:

 /\s(<[^>]*>)*details(<[^>]*>)*\s/ @name = details
 /\s(<[^>]*>)*weather(<[^>]*>)*\s/ @name = weather
 /\s(<[^>]*>)*test(<[^>]*>)*\s/ @name = test
 /\s(<[^>]*>)*cloth(<[^>]*>)*\s/ @name = cloth
 /\s(<[^>]*>)*health(<[^>]*>)*\s/ @name = health
 /\s(<[^>]*>)*art(<[^>]*>)*\s/ @name = art

=item 2.

A TEST_REGEX file output by order1vec.pl using its --testregex option:

 /\s(<[^>]*>)*polygonal(<[^>]*>)*\s/ @name = polygonal
 /\s(<[^>]*>)*ectoderm(<[^>]*>)*\s/ @name = ectoderm
 /\s(<[^>]*>)*fluid(<[^>]*>)*\s/ @name = fluid
 /\s(<[^>]*>)*CEMx174(<[^>]*>)*\s/ @name = CEMx174
 /\s(<[^>]*>)*adjacent(<[^>]*>)*\s/ @name = adjacent
 /\s(<[^>]*>)*mutant(<[^>]*>)*\s/ @name = mutant
 /\s(<[^>]*>)*progenitor(<[^>]*>)*\s/ @name = progenitor
 /\s(<[^>]*>)*Ganglion(<[^>]*>)*\s/ @name = Ganglion
 /\s(<[^>]*>)*MLS(<[^>]*>)*\s/ @name = MLS
 /\s(<[^>]*>)*male(<[^>]*>)*\s/ @name = male
 /\s(<[^>]*>)*mother(<[^>]*>)*\s/ @name = mother

=back

=head2 Optional Arguments:

=head3 --binary

Select this switch to create binary context vectors. Binary vectors are 
computed by taking the binary OR of the word vectors of features that are 
found in the context. By default, order2vec creates frequency score vectors 
that show arithmatic avearge of the word vectors of contextual features. 

=head3 --dense

By default, word vectors in WORDVEC are assumed to be in sparse format. Also,
the context vectors displayed by order2vec are in sparse format. 

Select --dense if the word vectors are in dense format. This will automatically
create output vectors in dense format as well.

 ****************     IMPORTANT NOTE    ************

 Dense word vectors (when --dense is ON) should be formatted i.e. each entry
 of WORDVEC should be represented using the same numeric format and should
 occupy exactly same number of spaces. Use --format option to specify the
 format of dense word vectors.

=head3 --rlabel RLABELFILE 

Creates a RLABELFILE containing row labels for Cluto's --rlabelfile option.
Each line in RLABELFILE shows an instance id of the instance whose context
vector appears on the corresponding line on STDOUT.

Instance ids are extracted from the SVAL2 file by matching regex

                /<instance id\s*=\s*"IID"/>/

where 'IID' is an instance id of the <context> that follows this <instance> 
tag.

=head3 --rclass RCLASSFILE

Creates RCLASSFILE for Cluto's --rclassfile option. Each line in the
RCLASSFILE shows the true sense id of the instance whose context vector 
appears on the corresponding line on STDOUT.

Sense ids are extracted from the SVAL2 file by matching regex

                /sense\s*id\s*=\s*"SID"\/>/

where SID shows the true sense tag of the instance whose IID is recently
extracted by matching

                /<instance id\s*=\s*"IID"/>/

=head3 --showkey 

Displays the name of the system generated KEY file on the first line of STDOUT.
KEY file preserves the instance ids and sense tags of the instances in the
given SVAL2 file. This information will be automatically used by some of the
clustering and evaluation programs in SenseClusters that operate on purely
numeric instance formats. The option should be selected if the user is planning
to run SenseClusters' clustering code.

=head2 Other Options :

=head3 --format FORM

If --dense is ON, input WORD VECtors need to be formatted i.e. should be
represented using same numeric format and occupy same number of digit spaces.
If wordvec.pl was run using its --format option, then the value of --format
to order2vec.pl should be same as that specified in wordvec.pl's --format
option.

Format should be represented as 

 iN   -> integer format where each entry occupies total N bytes/digits 

 fN.M -> floating point format where each entry occupies total N bytes/digits
         of which last M digits show the fractional part

When --binary is ON, default format is i2 that assumes 2 digit space for each
entry. When --binary is OFF, default format is f16.10 that assumes each
entry is fractional occupying total 16 digit equivalent spaces of which last 10
digits show the fractional part.

Output context vectors (sparse or dense) will be represented using the 
specified format value or default f16.10.

=head3 --help

Displays this message.

=head3 --version

Displays the version information.

=head1 OUTPUT

Output shows a single context vector on each line. 
Context vectors represent instances in the same order as they appear in the 
given SVAL2 file i.e. each ith vector on STDOUT shows a context vector of the
ith instance in the SVAL2 file.

Each context vector is an average of the WORD VECtors of the features 
that are found in the context using FEATURE_REGEX.

=head2 Sample Sparse Output 

Input Sval2 file => test.sval2

 <corpus lang="english">
 <lexelt item="LEXELT">
 <instance id="hard-a.sjm-098_3:">
 <answer instance="hard-a.sjm-098_3:" senseid="HARD1"/>
 <context>
 someone has to kill him to defeat him and that s <head>HARD</head> to do
 </context>
 </instance>
 <instance id="hard-a.w8_038:">
 <answer instance="hard-a.w8_038:" senseid="HARD3"/>
 <context>
 I find it <head>HARD</head> to believe that you don't believe me
 </context>
 </instance>
 <instance id="hard-a.sjm-255_13:">
 <answer instance="hard-a.sjm-255_13:" senseid="HARD3"/>
 <context>
 when you get bad credit data or are confused with another person your life gets  <head>HARD</head>
 </context>
 </instance>
 <instance id="hard-a.sjm-231_3:">
 <answer instance="hard-a.sjm-231_3:" senseid="HARD2"/>
 <context>
 Our life is <head>HARDER</head> now yes but it is better to live hungry and free life
 </context>
 </instance>
 <instance id="hard-a.sjm-096_2:">
 <answer instance="hard-a.sjm-096_2:" senseid="HARD1"/>
 <context>
 Ray who told his colleagues We have to face the <head>HARD</head> facts of life due to bad credit
 </context>
 </instance>
 </lexelt>
 </corpus>

Input FEATURE_REGEX file => test.regex

 /\s(<[^>]*>)*<head>HARD<\/head>(<[^>]*>)*\s/ @name = <head>HARD</head>
 /\s(<[^>]*>)*to(<[^>]*>)*\s/ @name = to
 /\s(<[^>]*>)*defeat(<[^>]*>)*\s/ @name = defeat
 /\s(<[^>]*>)*believe(<[^>]*>)*\s/ @name = believe
 /\s(<[^>]*>)*credit(<[^>]*>)*\s/ @name = credit
 /\s(<[^>]*>)*life(<[^>]*>)*\s/ @name = life
 /\s(<[^>]*>)*facts(<[^>]*>)*\s/ @name = facts
 /\s(<[^>]*>)*kill(<[^>]*>)*\s/ @name = kill

Input Saprse Word Vectors => test.sparse_wordvec

 8 10 41
 1 4.977 4 7.813 8 9.114 10 1.431
 1 5.944 2 5.728 3 2.978 5 5.604 7 9.444 9 3.680
 2 3.984 3 8.306 4 6.632 5 4.514 7 1.785 9 7.609
 2 9.147 4 3.086 5 0.325 9 1.456
 1 0.741 4 3.450 6 2.363
 1 9.549 2 3.921 3 8.131 4 4.301 5 9.059 6 8.607 10 1.138
 2 8.203 4 7.297 5 1.095 7 4.362 8 2.963 10 7.264
 2 4.296 4 9.802 7 9.268 9 8.856 10 9.723

Command => 

 order2vec.pl --format f9.4 test.sval2 test.sparse_wordvec test.regex

Output => 

 5 10 45
 1   3.8015 2   4.2440 3   2.8733 4   4.0412 5   3.5543 7   6.5642 8   1.5190 9   4.5842 10   1.8590
 1   2.7302 2   6.0055 3   0.7445 4   3.4962 5   1.5635 7   2.3610 8   2.2785 9   1.6480 10   0.3578
 1   5.0890 2   1.3070 3   2.7103 4   5.1880 5   3.0197 6   3.6567 8   3.0380 10   0.8563
 1   8.3473 2   4.5233 3   6.4133 4   2.8673 5   7.9073 6   5.7380 7   3.1480 9   1.2267 10   0.7587
 1   4.5258 2   3.9300 3   2.3478 4   3.8102 5   3.5603 6   1.8283 7   3.8750 8   2.0128 9   1.2267 10   1.6388

Explanation =>

First instance <hard-a.sjm-098_3:> contains features 

 '<head>HARD</head>' once,
 'to' thrice,
 'defeat' once,
 'kill' once.

Hence, the context vector of instance <hard-a.sjm-098_3:> shown on Line 2
on STDOUT is an average of sparse word vectors ->

 [1 4.977 4 7.813 8 9.114 10 1.431]
 3 * [1 5.944 2 5.728 3 2.978 5 5.604 7 9.444 9 3.680]
 [2 3.984 3 8.306 4 6.632 5 4.514 7 1.785 9 7.609]
 [2 4.296 4 9.802 7 9.268 9 8.856 10 9.723]

OR 

 [1 4.977 4 7.813 8 9.114 10 1.431]
 [1 17.832 2 17.184 3 8.934 5 16.812 7 28.332 9 11.04]
 [2 3.984 3 8.306 4 6.632 5 4.514 7 1.785 9 7.609]
 [2 4.296 4 9.802 7 9.268 9 8.856 10 9.723]

The Sum of above vectors is a sparse vector =>

 [1 22.809 2 25.464 3 17.24 4 24.247 5 21.326 7 39.385 8 9.114 9 27.505 10 11.154]

And the average is =>

 [1 3.8015 2 4.2440 3 2.8733 4 4.0412 5 3.5543 7 6.5642 8 1.5190 9 4.5842 10 1.8590]

Similarly, all context vectors are computed by averaging the word vectors of
features that match in the context.


=head2 Sample Dense Output

In the above example, if WORDVEC is dense => test.dense_wordvec

   8 10
   4.9770   0.0000   0.0000   7.8130   0.0000   0.0000   0.0000   9.1140   0.0000   1.4310
   5.9440   5.7280   2.9780   0.0000   5.6040   0.0000   9.4440   0.0000   3.6800   0.0000
   0.0000   3.9840   8.3060   6.6320   4.5140   0.0000   1.7850   0.0000   7.6090   0.0000
   0.0000   9.1470   0.0000   3.0860   0.3250   0.0000   0.0000   0.0000   1.4560   0.0000
   0.7410   0.0000   0.0000   3.4500   0.0000   2.3630   0.0000   0.0000   0.0000   0.0000
   9.5490   3.9210   8.1310   4.3010   9.0590   8.6070   0.0000   0.0000   0.0000   1.1380
   0.0000   8.2030   0.0000   7.2970   1.0950   0.0000   4.3620   2.9630   0.0000   7.2640
   0.0000   4.2960   0.0000   9.8020   0.0000   0.0000   9.2680   0.0000   8.8560   9.7230

Command => 

 order2vec.pl --format f9.4 --dense test.sval2 test.dense_wordvec test.feat 

Output =>

   5 10
   3.8015   4.2440   2.8733   4.0412   3.5543   0.0000   6.5642   1.5190   4.5842   1.8590
   2.7302   6.0055   0.7445   3.4962   1.5635   0.0000   2.3610   2.2785   1.6480   0.3578
   5.0890   1.3070   2.7103   5.1880   3.0197   3.6567   0.0000   3.0380   0.0000   0.8563
   8.3473   4.5233   6.4133   2.8673   7.9073   5.7380   3.1480   0.0000   1.2267   0.7587
   4.5258   3.9300   2.3478   3.8102   3.5603   1.8283   3.8750   2.0128   1.2267   1.6388

Shows same context vectors as shown in Sample Sparse Output section only 
with --dense ON. 

Note that, if --dense is ON, --format has to be used and must specify
the format of dense word vectors.

=head1 SYSTEM REQUIREMENTS

=over

=item PDL - L<http://search.cpan.org/dist/PDL/>

=back

=head1 AUTHORS

 Ted Pedersen, University of Minnesota, Duluth
 tpederse at d.umn.edu

 Amruta Purandare, University of Pittsburgh

 Mahesh Joshi, Carnegie-Mellon University

=head1 COPYRIGHT

Copyright (c) 2002-2008, Ted Pedersen, Amruta Purandare, Mahesh Joshi

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

#			 ==============================	
#                             THE CODE STARTS HERE
#			 ==============================

#$0 contains the program name along with
#the complete path. Extract just the program
#name and use in error messages
$0=~s/.*\/(.+)/$1/;

# use PDL for dense vectors
use PDL;
use PDL::NiceSlice;
use PDL::Primitive;

# use Math::SparseVector module for sparse vectors 
use Math::SparseVector;

###############################################################################

#                           ================================
#                            COMMAND LINE OPTIONS AND USAGE
#                           ================================

# command line options
use Getopt::Long;
GetOptions ("help","version","format=s","binary","showkey","rlabel=s","rclass=s","dense");
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

# show minimal usage message if fewer arguments
if($#ARGV<2)
{
        &showminimal();
        exit 1;
}

#############################################################################

#                       ================================
#                          INITIALIZATION AND INPUT
#                       ================================

# ------------
# SVAL2 file
# ------------
if(!defined $ARGV[0])
{
        print STDERR "ERROR($0):
	Please specify the input SVAL2 file.\n";
        exit 1;
}
#accept the SVAL2 file name
$infile=$ARGV[0];
if(!-e $infile)
{
        print STDERR "ERROR($0):
        SVAL2 file <$infile> doesn't exist...\n";
        exit 1;
}
open(IN,$infile) || die "Error($0):
        Error(code=$!) in opening the SVAL2 file <$infile>.\n";

# -------------
# Wordvec file
# -------------
if(!defined $ARGV[1])
{
	print STDERR "ERROR($0):
		Please specify the WORDVEC file.\n";
	exit 1;
}

#accept the wordvec file name
$wordvec_file=$ARGV[1];
if(!-e $wordvec_file)
{
	print STDERR "ERROR($0):
		WORDVEC file <$wordvec_file> doesn't exist...\n";
	exit 1;
}
open(WM,$wordvec_file) || die "Error($0):
	Error(code=$!) in opening WORDVEC file <$wordvec_file>.\n";

# word vectors in dense format
if(defined $opt_dense)
{
	# first line
	$line1=<WM>;
	if($line1 !~ /^\s*(\d+)\s+(\d+)\s*$/)
	{
		print STDERR "ERROR($0):
		Line1 in WORDVEC file <$wordvec_file> should show #rows #cols
		when --dense is ON.\n";
		exit 1;
	}
	else
	{
		$header+=length($line1);
		$rows=$1;
		$cols=$2;
	}
}
# word vectors in sparse format
else
{
	# first line
	$line1=<WM>;
	if($line1 !~ /^\s*(\d+)\s+(\d+)\s+(\d+)\s*$/)
	{
		print STDERR "ERROR($0):
		Line1 in WORDVEC file <$wordvec_file> should show #rows #cols #nnz.\n";
		exit 1;
	}
	else
	{
		$rows=$1;
		$cols=$2;
		$nnz1=$3;
	}

	$line_num=1;
	while(<WM>)
	{
		$line_num++;
		chomp;
		s/^\s*//;
		s/\s*$//;
		$word_vector=Math::SparseVector->new;
		@pairs=split(/\s+/);
		for($i=0; $i<$#pairs; $i=$i+2)
		{
			$index=$pairs[$i];
			if($index > $cols)
			{
				print STDERR "ERROR($0):
		Index $index found at line <$line_num> in WORDVEC file <$wordvec_file>
		exceeds the total number of columns $cols shown on the 1st line.\n";
				exit 1;
			}
			$value=$pairs[$i+1];
			$word_vector->set($index,$value);
			$nnz++;
		}
		#	$word_vector->free;
		push @word_vectors,$word_vector;
	}
	close WM;
	if(scalar(@word_vectors) != $rows)
	{
		print STDERR "ERROR($0):
		1st line of WORDVEC file <$wordvec_file> shows #vectors = $rows while 
		the actual #vectors found in the file = " . scalar(@word_vectors) . "\n";
		exit 1;
	}

	if($nnz != $nnz1)
	{
		print STDERR "ERROR($0):
		1st line of WORDVEC file <$wordvec_file> shows #nnz = $nnz1 while
		the actual #nnz found in the file = $nnz.\n";
		exit 1;
	}
}

# ------------------
# Feature Regex file
# ------------------
if(!defined $ARGV[2])
{
        print STDERR "ERROR($0):
        Please specify the Feature Regex file.\n";
        exit 1;
}
#accept the feature regex file name
$featfile=$ARGV[2];
if(!-e $featfile)
{
        print STDERR "ERROR($0):
        Feature file <$featfile> doesn't exist...\n";
        exit 1;
}
open(FEAT,$featfile) || die "Error($0):
        Error(code=$!) in opening Feature file <$featfile>.\n";
while(<FEAT>)
{
	$line_num++;
	chomp;
	s/^\s*//;
	s/\s*$//;

	if(/(.*)\s*\@name\s*=\s*.*/)
	{
		$feature_regex=$1;

		# removing leading and lagging blank spaces
		$feature_regex=~s/^\s*//;
		$feature_regex=~s/\s*$//;

		# removing the starting and ending slashes //
		if($feature_regex=~/^\//) { $feature_regex=~s/^\///; }
		else
		{
			print STDERR "ERROR($0):
	Feature regex <$feature_regex> 
	at line <$line_num> in Feature Regex file <$featfile> should start 
	with '/'\n";
			exit;
		}
		if($feature_regex=~/\/$/) { $feature_regex=~s/\/$//; }
		else
		{
			print STDERR "ERROR($0):
	Feature regex <$feature_regex>
	at line <$line_num> in Feature Regex file <$featfile> should end
	with '/'\n";
			exit;
		}
		
		push @feature_regexes,$feature_regex;
	}
}
close FEAT;

if (scalar(@feature_regexes) != $rows) {
	print STDERR "ERROR($0):
		Unequal number of feature vectors and features provided in 
		input files. WORDVEC file <$wordvec_file> 
		specifies $rows vectors whereas FEATURE_REGEX 
		file <$featfile> contains " . 
		scalar(@feature_regexes) . " features.\n";
	exit 1;
}

# -----------
# Formatting
# -----------
# if --format is specified
if(defined $opt_format)
{
        # integer
        if($opt_format=~/^i(\d+)$/)
        {
		if(defined $opt_dense)
		{
	                $bytein=$1;
		}
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
        # float
        elsif($opt_format=~/^f(\d+)\.(\d+)$/)
        {
		if(defined $opt_dense)
		{
                	$bytein=$1;
		}
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
                exit 1;
        }
}
# default format is f16.10
else
{
	if(defined $opt_binary)
	{
		if(defined $opt_dense)
		{
			$bytein=2;
		}
		$format="%2d";

		$lower_format="0";
                $upper_format="1";
	}
	else
	{
		if(defined $opt_dense)
		{
	        	$bytein=16;
		}
		$format="%16.10f";

		$lower_format="-999.9999999999";
                $upper_format="9999.9999999999";
	}
}

##############################################################################

##############################################################################

#		=================================================
#		  Read Context words and create Context Vectors
#		=================================================

# context vectors are temporarily written into a
# TEMP file

# if the program finishes sucessfully, this TEMP file
# is printed to STDOUT and is deleted

# otherwise TEMP file is retained and stores the partial
# program output

$tempfile="tempfile" . time() . ".order2vec";

if(-e $tempfile)
{
        print STDERR "ERROR($0):
        Temporary file <$tempfile> should not already exist.\n";
        exit 1;
}

open(TEMP,">$tempfile") || die "ERROR($0):
        Error(code=$!) in opening internal temporary file <$tempfile>.\n";

# reading the SVAL2 file
$line_num=0;
if(defined $opt_dense)
{
	$context_vector=zeroes($cols);
	$word_vector=zeroes($cols);
}
else
{
	$context_vector=Math::SparseVector->new;
	$nnz=0;
}
while(<IN>)
{
	$line_num++;
	
	if(/instance id\s*=\s*\"([^"]+)\"/)
	{
		$instance=$1;
		if(defined $instance_ids{$instance})
		{
			print STDERR "ERROR($0):
		Instance Id <$instance> is repeated in the SVAL2 file <$infile>.\n";
			exit 1;
		}
		push @instances,$instance;
		$instance_ids{$instance}=1;
	}

	if(/<\/instance>/)
	{
		undef $instance;
	}

	if(/sense\s*id\s*=\s*\"([^"]+)\"/)
	{
		# no <instance> open
		if(!defined $instance)
		{
			print STDERR "ERROR($0):
		Missing <instance> tag before the <sense> tag at line <$line_num>
		in SVAL2 file <$infile>.\n";
			exit 1;
		}
		$sense=$1;
		if(defined $key_table{$instance}{$sense})
		{
			print STDERR "ERROR($0):
		<instance-id, sense-tag> pair <$instance, $sense> is repeated in the
		SVAL2 file <$infile>.\n";
			exit 1;
		}
		$key_table{$instance}{$sense}=1;
	}

	if(/<\/context>/)
	{
		undef $data_start;
		# printing the context vector
		if(defined $opt_dense)
		{
			foreach $col (0..$cols-1)
			{
				$value=sprintf $format, $context_vector->at($col);
				if($value<$lower_format)
				{
					print STDERR "ERROR($0):
		Floating point underflow.
		Value <$value> can't be represented using the specified format $format.\n";
					exit 1;
				}
		    if($value>$upper_format)
		    {
					print STDERR "ERROR($0):
		Floating point overflow.
		Value <$value> can't be represented using the specified format $format.\n";
					exit 1;
		    }
				print TEMP "$value";
			}
		}
		else
		{
			foreach $index ($context_vector->keys)
			{
				$value=sprintf $format, $context_vector->get($index);

				if($value != 0)
				{
					print TEMP "$index $value ";
					$nnz++;
				}
			}
		}
		print TEMP "\n";
	}

	# context data
	if(defined $data_start)
	{
		# handling blank lines
		if(/^\s*$/)
		{
			next;
		}

		# nsp2regex features have format 
		# /\sFEATURE\s/ which requires a space
		# on each side of the token
		s/^(\S)/ $1/;
		s/(\S)$/$1 /;
		# ---------------------------------------------------
		#  the logic of matching feature regex/s is borrowed
		#  from the xml2arff.pl program from the SenseTools
		#  package by Satanjeev Banerjee and Ted Pedersen
		# ---------------------------------------------------
		foreach $index (0..$#feature_regexes)
		{
			$feature_regex=$feature_regexes[$index];
			if(defined $opt_binary)
			{
				# match or not
				if(/$feature_regex/)
				{
					# offset of feature in FEATURE file
					$feature_offset=$index;

					# read word vector from WORDVEC file
					if(defined $opt_dense)
					{
						# offset of word vector in WORDVEC file
						$wordvec_offset=($cols*$feature_offset*$bytein)+$feature_offset+$header;
						seek(WM,$wordvec_offset,0);
						$word_vector->inplace->zeroes;
						# read cols number of elements
						foreach $col (0..$cols-1)
						{
							read(WM,$value,$bytein);
							#	print STDERR "<$value>\n";
							if(!defined $value)
							{
								print STDERR "ERROR($0):
					Insufficient column entries in Word Vector at index=$feature_offset 
					in WORD VECtor file <$wordvec_file>.\n";
								exit 1;
							}
							if($value != 0)
							{
								set($word_vector,$col,1);
							}
							else
							{
								set($word_vector,$col,0);
							}
						}
						
						$context_vector->inplace->or2($word_vector,0);
					}
					# sparse word vectors are loaded in @word_vectors
					else
					{
						$context_vector->binadd($word_vectors[$feature_offset]);
					}
				}
			}
			else
			# not binary
			{
				# number of matches
				while(/$feature_regex/g)
				{
					# offset of feature in FEATURE file
					$feature_offset=$index;

					# read word vector from WORDVEC file
					if(defined $opt_dense)
					{
						# offset of word vector in WORDVEC file
						$wordvec_offset=($cols*$feature_offset*$bytein)+$feature_offset+$header;
						seek(WM,$wordvec_offset,0);
						$word_vector->inplace->zeroes;
						# read cols number of elements
						foreach $col (0..$cols-1)
						{
							read(WM,$value,$bytein);
							#	print STDERR "<$value>\n";
							if(!defined $value)
							{
								print STDERR "ERROR($0):
					Insufficient column entries in Word Vector at index=$feature_offset 
					in WORD VECtor file <$wordvec_file>.\n";
								exit 1;
							}
							set($word_vector,$col,$value);
						}
						$context_vector->inplace->plus($word_vector,0);
						$words++;
					}
					# sparse word vectors are loaded in @word_vectors
					else
					{
						$context_vector->add($word_vectors[$feature_offset]);
						$words++;
					}
				}
			}
		}

		if(!defined $opt_binary)
		{
			if($words != 0)
			{
				if(defined $opt_dense)
				{
					$context_vector.=$context_vector/$words;
				}
				else
				{
					$context_vector->div($words);
				}
			}
		}
	}
	
	# <context> start
	if(/<context>/)
	{
		# no <instance> open
		if(!defined $instance)
		{
			print STDERR "ERROR($0):
		Missing <instance> tag before the <context> tag at line <$line_num>
		in SVAL2 file <$infile>.\n";
			exit 1;
		}

		# no sense tag for this instance
		if(!defined $key_table{$instance})
		{
			$sense="NOTAG";
			$key_table{$instance}{$sense}=1;
		}
		$data_start=1;
		if(defined $opt_dense)
		{
			$context_vector->inplace->zeroes;
		}
		else
		{
			$context_vector->free;
		}
		$words=0;
	}
}

close TEMP;


##############################################################################

#			=========================
#			      OUTPUT SECTION
#			=========================

# =====================
#  Creating KEY file
# =====================

# KEY file is automatically created by the program
# and preserves the instance ids and sense tags of the
# SVAL-2 instances

$keyfile="keyfile" . time() . ".key";
if(-e $keyfile)
{
        print STDERR "ERROR($0):
        System generated KEY file <$keyfile> should not already exist.\n";
        exit 1;
}

open(KEY,">$keyfile") || die "ERROR($0):
        Error(code=$!) in opening system generated KEY file <$keyfile>.\n";

foreach $instance (@instances)
{
        print KEY "<instance id=\"$instance\"\/> ";
        foreach $sense (sort keys %{$key_table{$instance}})
        {
                print KEY "<sense id=\"$sense\"\/> ";
        }
        print KEY "\n";
}


# =========================
#  Printing output vectors
# =========================

# first line should show the KEY filename if --showkey is ON
if(defined $opt_showkey)
{
        print "<keyfile name=\"$keyfile\"\/>\n";
	undef $opt_showkey;
}

print scalar(@instances) . " $cols";

if(!defined $opt_dense)
{
	print " $nnz";
}
print "\n";

# this is followed by the actual context vectors

open(TEMP,$tempfile) || die "ERROR($0):
        Error(code=$!) in opening internal temporary file <$tempfile>.\n";

while(<TEMP>)
{
        print;
}
close TEMP;

# deleting TEMP as the program is sucessfully finished
unlink "$tempfile";

##############################################################################

#			==========================
#			   Creating Cluto files
#			==========================

	# opening rlabel file
        if(defined $opt_rlabel)
        {
                $rlabel=$opt_rlabel;
                if(-e $rlabel)
                {
                        print STDERR "Warning($0):
        Row label file <$rlabel> already exists, overwrite (y/n)? ";
                        $ans=<STDIN>;
                }
                if(!-e $rlabel || $ans=~/Y|y/)
                {
                        open(RLAB,">$rlabel") || die "Error($0):
        Error(code=$!) in opening the Row Label file <$rlabel>.\n";
                }
                else
                {
                        undef $rlabel;
                }
        }

	# opening rclass file
        if(defined $opt_rclass)
        {
                $rclass=$opt_rclass;
                if(-e $rclass)
                {
                        print STDERR "Warning($0):
        Class label file <$rclass> already exists, overwrite (y/n)? ";
                        $ans=<STDIN>;
                }
                if(!-e $rclass || $ans=~/Y|y/)
                {
                        open(RCL,">$rclass") || die "Error($0):
        Error(code=$!) in opening the Class Label file <$rclass>.\n";
                }
                else
                {
                        undef $rclass;
                }
        }

	# printing rlabels and rclasses
        foreach $instance (@instances)
        {
                if(defined $rlabel)
                {
                        print RLAB "$instance\n";
                }
                if(defined $rclass)
                {
                        @senses=sort keys %{$key_table{$instance}};
                        if(scalar(@senses) > 1)
                        {
                                print STDERR "ERROR($0):
        Instance <$instance> can not have multiple senses in RCLASSFILE.\n";
                                exit 1;
                        }
                        print RCL "$senses[0]\n";
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
        print "Usage: order2vec.pl [OPTIONS] SVAL2 WORDVEC FEATURE_REGEX";
        print "\nTYPE order2vec.pl --help for help\n";
}

#-----------------------------------------------------------------------------
#show help
sub showhelp()
{
	print "Usage:  order2vec.pl [OPTIONS] SVAL2 WORDVEC FEATURE_REGEX

Creates second order context vectors for the instances in the given SVAL2 
file by averaging WORD VECtors of FEATUREs that appear in the contexts.

SVAL2 
	A tokenized, preprocessed and well formatted Senseval-2 instance file
	containing instances whose context vectors are to be generated.

WORDVEC
	Word vectors as created by program wordvec.pl 
	
	OR 
	
	Feature vectors as created by using the --transpose option of 
	order1vec.pl

FEATURE_REGEX
	A file created by running nsp2regex.pl on wordvec.pl's --feats option 
	output while creating the WORDVEC file 
	
	OR 
	
	A file created by using the --testregex option of order1vec.pl, when
	the WORDVEC file is created using its --transpose option.

OPTIONS:

--binary
	Creates binary context vectors by taking binary OR of the WORD VECtors
	of FEATUREs matched in the context. By default, order2vec takes
	arithmatic average of the WORD VECtors.

--dense
	By default, order2vec assumes WORDVEC in sparse format and creates 
	output context vectors in sparse format as well. Select --dense if WORD 
	VECtors are in dense format. --dense will also create output context
	vectors in dense format.

--format FORM
        Specifies the numeric format for dense WORD VECtors. If --dense is 
	selected, WORDVEC has to be formatted, meaning, all WORDVEC entries
	should be represented using exactly same numeric format and should
	occupy same number of digit spaces. Sparse word vectors need not be
	formatted.

	--format can also be used to specify the format for output vectors
	(sparse or dense).

	Default format is f16.10 when --binary is OFF and i2 when --binary 
	is ON.

--showkey
	Displays the system generated KEY file name on the first line of 
	STDOUT.

--rlabel RLABELFILE
	Writes row labels to RLABELFILE which can be given to vcluster's
        --rlabelfile option.
	
--rclass RCLASSFILE
	Writes sense ids to RCLASSFILE which can be given to vcluster's 
	--rclassfile option.

--help
        Displays this message.

--version
        Displays the version information.

Type 'perldoc order2vec.pl' to view detailed documentation of order2vec.\n";
}

#------------------------------------------------------------------------------
#version information
sub showversion()
{
	print '$Id: order2vec.pl,v 1.33 2008/03/30 23:31:16 tpederse Exp $';
	print "\nConvert Senseval-2 contexts into second order feature vectors\n";
 #       print "\nCopyright (c) 2002-2006, Ted Pedersen, Amruta Purandare, & Mahesh Joshi\n";
 #       print "order2vec.pl      -       Version 0.3\n";
 #       print "Creates second order context vectors.\n";
 #       print "Date of Last Update:     07/29/2006\n";
}

#############################################################################

