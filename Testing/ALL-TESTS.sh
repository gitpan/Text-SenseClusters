#!/bin/csh

# This is the driver program for all the tests in the Testing
# directory. There are sometimes problems with the *.sh files
# not being executable, which is why I'm explicitly calling 
# them with csh, so that they run regardless of file permissions
# the directory structure is a bit complicated, and stepping
# through it is complicated and messy, so I've just hard coded
# the location of our normal-op.sh and error-op.sh scripts
# and submitted them from here...

# previously all testA*.sh scripts were run by normal-op.sh
# and all testB*.sh scripts were run by error-op.sh

# please note that this script must be run from within the Testing 
# directory, that is the directory in which ALL-TESTS.sh resides

set BACKHERE = `pwd`

echo " ----------------------------------------------------"
echo " ------------- clusterlabeling.pl -------------------"
echo " ----------------------------------------------------"
cd ./clusterlabel/clusterlabeling
	csh ./testA*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " ------------- clusterstopping.pl -------------------"
echo " ----------------------------------------------------"
cd ./clusterstop/clusterstopping
	csh ./testA*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " ---------------- reduce-count.pl -------------------"
echo " ----------------------------------------------------"
cd ./count/reduce-count
	csh ./testA*.sh
	csh ./testB*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo "---------------- cluto2label.pl ---------------------"
echo " ----------------------------------------------------"
cd ./evaluate/cluto2label
	csh ./testA*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " ------------- format_clusters.pl -------------------"
echo " ----------------------------------------------------"
cd ./evaluate/format_clusters
	csh ./testA*.sh
	csh ./testB*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " --------------------- label.pl ---------------------"
echo " ----------------------------------------------------"
cd ./evaluate/label
	csh ./testA*.sh
	csh ./testB*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " ---------------------- report.pl -------------------"
echo " ----------------------------------------------------"
cd ./evaluate/report
	csh ./testA*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " ------------------- bitsimat.pl --------------------"
echo " ----------------------------------------------------"
cd ./matrix/bitsimat
	csh ./testA*.sh
	csh ./testB*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " ------------------ simat.pl ------------------------"
echo " ----------------------------------------------------"
cd ./matrix/simat
	csh ./testA*.sh
	csh ./testB*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " ------------------ mat2harbo.pl --------------------"
echo " ----------------------------------------------------"
cd ./svd/mat2harbo
	csh ./testA*.sh
	csh ./testB*.sh
cd $BACKHERE


echo " ----------------------------------------------------"
echo " ------------------ svdpackout.pl -------------------"
echo " ----------------------------------------------------"
echo "note that some variation in SVD output is expected"
echo "due to differences in architectures and precision"

cd ./svd/svdpackout
	csh ./testA*.sh
	csh ./testB*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " ---------------- order1vec.pl ----------------------"
echo " ----------------------------------------------------"
cd ./vector/order1vec
	csh ./testA*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " ---------------- order2vec.pl ----------------------"
echo " ----------------------------------------------------"
cd ./vector/order2vec
	csh ./testA*.sh
	csh ./testB*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " ----------------- wordvec.pl -----------------------"
echo " ----------------------------------------------------"
cd ./vector/wordvec
	csh ./testA*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " ----------------- text2sval.pl ---------------------"
echo " ----------------------------------------------------"
cd ./preprocess/plain/text2sval
	csh ./testA*.sh
	csh ./testB*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " ------------------- balance.pl ---------------------"
echo " ----------------------------------------------------"
cd ./preprocess/sval2/balance
	csh ./testA*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " ------------------ filter.pl ------------------------"
echo " ----------------------------------------------------"
cd ./preprocess/sval2/filter
	csh ./testA*.sh
	csh ./testB*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " ------------------ frequency.pl --------------------"
echo " ----------------------------------------------------"
cd ./preprocess/sval2/frequency
	csh ./testA*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " ---------------- keyconvert.pl ---------------------"
echo " ----------------------------------------------------"
cd ./preprocess/sval2/keyconvert
	csh ./testA*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " ---------------- maketarget.pl ---------------------"
echo " ----------------------------------------------------"
cd ./preprocess/sval2/maketarget
	csh ./testA*.sh
	csh ./testB*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " --------------- prepare_sval2.pl -------------------"
echo " ----------------------------------------------------"
cd ./preprocess/sval2/prepare_sval2
	csh ./testA*.sh
	csh ./testB*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " ----------------- sval2plain.pl --------------------"
echo " ----------------------------------------------------"
cd ./preprocess/sval2/sval2plain
	csh ./testA*.sh
	csh ./testB*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " ----------------- windower.pl ----------------------"
echo " ----------------------------------------------------"
cd ./preprocess/sval2/windower
	csh ./testA*.sh
	csh ./testB*.sh
cd $BACKHERE

# these test cases originally come from SenseTools, so they
# use a different naming convention, just test-1.sh, etc. 

echo " ----------------------------------------------------"
echo " ----------------- nsp2regex.pl ---------------------"
echo " ----------------------------------------------------"
cd ./vector/nsp2regex
	csh ./test-*.sh
cd $BACKHERE

echo " ----------------------------------------------------"
echo " ----------------- preprocess.pl --------------------"
echo " ----------------------------------------------------"
cd ./preprocess/sval2/preprocess
	csh ./test-*.sh
cd $BACKHERE


