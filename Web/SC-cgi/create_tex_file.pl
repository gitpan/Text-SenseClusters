#!/usr/local/bin/perl

$prefix = shift;

open(FP,">$prefix.CR.tex") || die "Error opening output file\n!!";

print FP "\\documentclass{article}\n";
print FP "\\usepackage{fullpage}\n";

print FP "\\begin{document}\n\n";

print FP "\\begin {figure}\n";
print FP "\\begin{center}\n";
print FP "\\leavevmode\n";
print FP "\\input{$prefix.cr.tex}\n";
print FP "\\end{center}\n";
print FP "\\end {figure}\n\n";

print FP "\\end{document}\n";

close FP;


if(-e "$prefix.pk1.tex")
{
    open(FP,">$prefix.PK1.tex") || die "Error opening output file\n!!";
    
    print FP "\\documentclass{article}\n";
    print FP "\\usepackage{fullpage}\n";

    print FP "\\begin{document}\n\n";
    
    print FP "\\begin {figure}\n";
    print FP "\\begin{center}\n";
    print FP "\\leavevmode\n";
    print FP "\\input{$prefix.pk1.tex}\n";
    print FP "\\end{center}\n";
    print FP "\\end {figure}\n\n";
    
    print FP "\\end{document}\n";

    close FP;
}

if(-e "$prefix.pk2.tex")
{
    open(FP,">$prefix.PK2.tex") || die "Error opening output file\n!!";
    
    print FP "\\documentclass{article}\n";
    print FP "\\usepackage{fullpage}\n";
    
    print FP "\\begin{document}\n\n";
    
    print FP "\\clearpage\n\n";
    
    print FP "\\begin {figure}\n";
    print FP "\\begin{center}\n";
    print FP "\\leavevmode\n";
    print FP "\\input{$prefix.pk2.tex}\n";
    print FP "\\end{center}\n";
    print FP "\\end {figure}\n\n";
    
    print FP "\\end{document}\n";
    
    close FP;
}

if(-e "$prefix.pk3.tex")
{
    open(FP,">$prefix.PK3.tex") || die "Error opening output file\n!!";
    
    print FP "\\documentclass{article}\n";
    print FP "\\usepackage{fullpage}\n";
    
    print FP "\\begin{document}\n\n";
    
    print FP "\\begin {figure}\n";
    print FP "\\begin{center}\n";
    print FP "\\leavevmode\n";
    print FP "\\input{$prefix.pk3.tex}\n";
    print FP "\\end{center}\n";
    print FP "\\end {figure}\n\n";
    
    print FP "\\end{document}\n";
    
    close FP;
}

if(-e "$prefix.exp-cr.tex")
{
    open(FP,">$prefix.Obs-Exp.tex") || die "Error opening output file\n!!";
    
    print FP "\\documentclass{article}\n";
    print FP "\\usepackage{fullpage}\n";
    
    print FP "\\begin{document}\n\n";
    
    print FP "\\begin {figure}\n";
    print FP "\\begin{center}\n";
    print FP "\\leavevmode\n";
    print FP "\\input{$prefix.exp-cr.tex}\n";
    print FP "\\end{center}\n";
    print FP "\\end {figure}\n\n";
    
    print FP "\\end{document}\n";
    
    close FP;
}

if(-e "$prefix.gap.tex")
{
    open(FP,">$prefix.GAP.tex") || die "Error opening output file\n!!";
    
    print FP "\\documentclass{article}\n";
    print FP "\\usepackage{fullpage}\n";

    print FP "\\begin{document}\n\n";
    
    print FP "\\begin {figure}\n";
    print FP "\\begin{center}\n";
    print FP "\\leavevmode\n";
    print FP "\\input{$prefix.gap.tex}\n";
    print FP "\\end{center}\n";
	print FP "\\end {figure}\n\n";
    
    print FP "\\end{document}\n";
    
    close FP;
}
