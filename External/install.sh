#!/bin/csh

# this script will compile and install svdpackc (las2)
# and retrieve and install cluto (linux or solaris version)
# it will place them in whatever directory name you provide
# this directory should be in your PATH - we don't do that
# automatically since that could have unexpected consequences
# on other of your programs, so you will need to update
# your PATH if you install these programs somewhere not
# currently in your PATH

# please be warned that this script does not do much in the
# way of error checking, so please check the messages issued
# by this script and verify that your install has succeeed
# if they seem to have failed, you will need to do manual
# installs of SVDPACKC and/or Cluto as described in INSTALL

if ($#argv != 1) then
       echo "Usage: $0 install_directory"
       echo "specify directory to install svdpackc and cluto"
       echo "...directory must already exist"
       exit
endif

set CLUTOSITE = 'http://glaros.dtc.umn.edu/gkhome/fetch/sw/cluto/cluto-2.1.1.tar.gz'
set CLUTODIR = 'cluto-2.1.1'
set OSNAME = `uname -s`
set INSTALLDIR = $1
 
if (! -d $INSTALLDIR) then
        echo "$INSTALLDIR does not exist" 
	echo "please create this directory and resubmit"
	exit 1
endif

# remove any existing installations or copies of cluto 

rm -fr $INSTALLDIR/las2
rm -fr $INSTALLDIR/scluster
rm -fr $INSTALLDIR/vcluster
rm -fr $CLUTODIR*

# compile and run las2

echo "**************************************************"
echo "let's install svdpackc..."
echo "this involes compiling the las2 program and then"
echo "doing a very simple check to make sure that worked"
echo "via a diff command of output produced by your"
echo "installed version with a key we provide (lao2.key)"
echo " "

cd SVDPACKC

make
cp belladit matrix
las2

echo " "
echo "check your las2 output against our key ..."

diff lao2.key lao2

echo " "
echo "there *may* be some differences in the output of"
echo "your lao2 file compared to the key we provide" 
echo "these are due to execution time differences and"
echo "arithmetic differences on different architectures"
echo "however, as long as your lao2 file has some output"
echo "in a format similar to lao2.key then it you can"
echo "assume it has compiled and is running successfully"
echo " " 
echo "clean up a few output files..."
cp las2 $INSTALLDIR

make clean

echo " "
echo "...now installing las2 in $INSTALLDIR"

cd ..

echo "***************************************************"
echo "now let's install cluto ...."
echo "we are using wget, if you don't have that installed"
echo "or there are some problems accessing the cluto site"
echo "this could fail, in which case you would need to"
echo "visit $CLUTOSITE"
echo "and download to install (verify the url is correct)"
echo " " 

wget $CLUTOSITE

echo "...will now unzip $CLUTODIR.tar.gz"

gunzip $CLUTODIR.tar.gz

echo "...will now untar $CLUTODIR.tar"

tar -xvf $CLUTODIR.tar
rm -fr $CLUTODIR.tar

echo "it looks like you are using $OSNAME ..."

if ($OSNAME == "SunOS") then
        cp $CLUTODIR/Sun/scluster $INSTALLDIR
        cp $CLUTODIR/Sun/vcluster $INSTALLDIR
	echo "...installed scluster and vcluster in $INSTALLDIR"
	echo "...make sure $INSTALLDIR include in your PATH"
else if ($OSNAME == "Linux") then
        cp $CLUTODIR/Linux/scluster $INSTALLDIR
        cp $CLUTODIR/Linux/vcluster $INSTALLDIR
	echo "...installed scluster and vcluster in $INSTALLDIR"
	echo "...make sure $INSTALLDIR is included in your PATH"
else echo "...sorry, automatic install of Cluto isn't possible..."
echo "***************************************************"

endif

echo " " 
echo "if all has gone well, you have installed svdpackc (las2)"
echo "and cluto (scluter and vcluster) in $INSTALLDIR"
echo "let's check...you should see three files: las2 scluster vcluster"
echo " " 

ls -lg $INSTALLDIR/las2
ls -lg $INSTALLDIR/scluster
ls -lg $INSTALLDIR/vcluster

echo " " 
echo ".... end of External Software Installation for SenseClusters ...."
echo " " 
echo "if you have some problem with this script, please save the output"
echo "and send it to tpederse at d.umn.edu for further assistance"
