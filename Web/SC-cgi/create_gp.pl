#!/usr/local/bin/perl

# This script creates gnuplot file (*.gp file)

$prefix = shift;
$crfun = shift;

open (FP,">$prefix.gp") || die "Error opening the output file!!\n";

$prefix =~ s/_/\\_/g;

# common setting
print FP "set terminal latex 8\n";
print FP "set size 1.2,1.3\n";
print FP "set style line 99 lt -1 pt 22\n";
print FP "set style line 98 pt 23\n";
print FP "set xtics 1,2\n";
print FP "set key left top\n";


# crfun
print FP "set output \"$prefix.cr.tex\"\n";
print FP "plot \"$prefix.cr.dat\" title \" $crfun vs m\" w linespoints ls 99\n\n";

if(-e "$prefix.gap.dat")
{
    # cr & exp	
    print FP "set output \"$prefix.exp-cr.tex\"\n";
    print FP "plot \"$prefix.cr.dat\" title \" $crfun(obs) vs m\" w linespoints ls 99, \"$prefix.exp.dat\" title \" $crfun(exp) vs m\" w linespoints ls 98\n\n";

    print FP "set key right top\n";
    
    # gap
    print FP "set output \"$prefix.gap.tex\"\n";
    print FP "plot \"$prefix.gap.dat\" title \"Gap vs m\" w lines, \"$prefix.gap.dat\" notitle w errorbars ls 99\n\n";

}

print FP "set format y \"%.3f\"\n";
print FP "set key left top\n";
	
if(-e "$prefix.pk1.dat")
{    
    # pk1
    print FP "set output \"$prefix.pk1.tex\"\n";
    print FP "plot \"$prefix.pk1.dat\" title \"  PK1 vs m\" w linespoints ls 99\n\n";
#	print FP "plot \"$prefix.pk1.dat\" title \"  PK1 vs m\" w linespoints ls 99, \"$prefix.pk1\\_thres.dat\" notitle w linespoints ls 98\n\n";
}    

if(-e "$prefix.pk2.dat")
{    
    # pk2
    print FP "set output \"$prefix.pk2.tex\"\n";
    print FP "plot \"$prefix.pk2.dat\" title \"  PK2 vs m\" w linespoints ls 99, \"$prefix.pk2.dat\" notitle w errorbars ls 99\n\n";
}

if(-e "$prefix.pk3.dat")
{    
    # pk3
    print FP "set output \"$prefix.pk3.tex\"\n";
    print FP "plot \"$prefix.pk3.dat\" title \"  PK3 vs m\" w linespoints ls 99, \"$prefix.pk3.dat\" notitle w errorbars ls 99\n\n";
}


