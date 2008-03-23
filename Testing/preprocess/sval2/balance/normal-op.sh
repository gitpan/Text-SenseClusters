#!/bin/csh
set dirlist = `ls test*.sh`
foreach file ($dirlist)
	$file
end
