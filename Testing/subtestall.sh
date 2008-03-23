#!/bin/csh
if(-e "normal-op.sh") then
	normal-op.sh
endif
if(-e "error-op.sh") then
	error-op.sh
endif
set dirlist = `ls`
foreach dir ($dirlist)
	if(-d $dir) then
		cd $dir 
			echo "In Directory $dir"
			subtestall.sh
		cd ..
	endif
end
