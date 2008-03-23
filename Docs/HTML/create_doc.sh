#!/bin/csh

# This script file creates .html files for all .pl present in the SC's root directory
# eg: currently it creates discriminate.html for discriminate.pl and setup.html for setup.pl 
# This also calls traverse.sh script which does the same task as of this script with the difference
# that it creates .html files for .pl files of Toolkit folder.

if($#argv != 1) then
	echo "Usage: create_doc.sh  PATH_2_SENSECLUSTERS";
	exit 1;
endif

# path to SenseClusters
set SENSECLUSTERS = $1
cd $SENSECLUSTERS

set DOCS = "$SENSECLUSTERS/Docs"
if(! -e $DOCS) then
	mkdir $DOCS 
endif

set perls=`ls *.pl`
foreach perl_file ($perls)
	set program = `echo $perl_file | sed 's/\.pl//'`
	pod2html --title $perl_file $perl_file > $DOCS/HTML/$program.html
	/bin/rm pod2ht*
end

if(! -e "$DOCS/HTML/Toolkit_Docs") then
	mkdir "$DOCS/HTML/Toolkit_Docs"
endif

cd Toolkit
	traverse.sh "$DOCS/HTML/Toolkit_Docs"
cd ..