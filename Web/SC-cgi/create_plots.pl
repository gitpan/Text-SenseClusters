#!/usr/local/bin/perl -w

$prefix = shift;
$crfun = shift;

system("../../create_gp.pl $prefix $crfun");

system("gnuplot $prefix.gp");

system("../../create_tex_file.pl $prefix");

system("latex $prefix.CR.tex");
system("latex $prefix.CR.tex");
system("dvips -Ppdf -G0 -t letter $prefix.CR.dvi");
system("ps2pdf $prefix.CR.ps");

if(-e "$prefix.PK1.tex")
{
    system("latex $prefix.PK1.tex");
    system("latex $prefix.PK1.tex");

    system("dvips -Ppdf -G0 -t letter $prefix.PK1.dvi");
    system("ps2pdf $prefix.PK1.ps");
}

if(-e "$prefix.PK2.tex")
{
    system("latex $prefix.PK2.tex");
    system("latex $prefix.PK2.tex");

    system("dvips -Ppdf -G0 -t letter $prefix.PK2.dvi");
    system("ps2pdf $prefix.PK2.ps");
}

if(-e "$prefix.PK3.tex")
{
    system("latex $prefix.PK3.tex");
    system("latex $prefix.PK3.tex");

    system("dvips -Ppdf -G0 -t letter $prefix.PK3.dvi");
    system("ps2pdf $prefix.PK3.ps");
}

if(-e "$prefix.Obs-Exp.tex")
{
    system("latex $prefix.Obs-Exp.tex");
    system("latex $prefix.Obs-Exp.tex");

    system("dvips -Ppdf -G0 -t letter $prefix.Obs-Exp.dvi");
    system("ps2pdf $prefix.Obs-Exp.ps");
}

if(-e "$prefix.GAP.tex")
{
    system("latex $prefix.GAP.tex");
    system("latex $prefix.GAP.tex");

    system("dvips -Ppdf -G0 -t letter $prefix.GAP.dvi");
    system("ps2pdf $prefix.GAP.ps");
}

system("rm -f $prefix.*.ps $prefix.*.dvi $prefix.*.aux $prefix.*.tex");
