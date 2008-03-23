#!/bin/csh
set dirlist = `ls`
foreach dir ($dirlist)
	if(-d $dir) then
		cd $dir
			echo "In Directory $dir"
			subtestall.sh
		cd ..
	endif
end
