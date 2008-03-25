# Generate a Makefile for SenseClusters. 
# $Id: Makefile.PL,v 1.71 2008/03/25 03:15:42 tpederse Exp $

# if you want to understand how Makefile.PL works, you should check out
# http://search.cpan.org/~rgarcia/perl-5.6.2/lib/ExtUtils/MakeMaker.pm

print "Welcome to SenseClusters !\n" unless -f "Makefile";

use 5.006;		# require perl 5.6

use ExtUtils::MakeMaker;

# lists that specify executables to copy into /bin

# wrappers from main dir

my @wrappers = qw (discriminate.pl);

# Now the Toolkit programs !

# preprocessors

my @toolkit_preprocess_plain = qw (text2sval.pl);

my @toolkit_preprocess_sval = qw (preprocess.pl balance.pl frequency.pl filter.pl keyconvert.pl prepare_sval2.pl windower.pl sval2plain.pl maketarget.pl);

# count 

my @toolkit_count = qw (reduce-count.pl);

# vector constructors

my @toolkit_vector = qw (nsp2regex.pl order1vec.pl order2vec.pl wordvec.pl);

# svd interface

my @toolkit_svd = qw (mat2harbo.pl svdpackout.pl);

# matrix constructors

my @toolkit_matrix = qw (simat.pl bitsimat.pl);

# evaluation programs

my @toolkit_evaluate = qw (cluto2label.pl label.pl report.pl format_clusters.pl);

# cluster labeling program

my @toolkit_cluslabel = qw (clusterlabeling.pl);

# cluster stopping program

my @toolkit_cluststop = qw (clusterstopping.pl);

# svdcompare.pl - only used for testing
## my @testing_svd_svdpackout = qw (svdcompare.pl);

WriteMakefile(

	'NAME'		=> 'Text::SenseClusters',
        'VERSION_FROM'      => 'lib/Text/SenseClusters.pm',   

## This lists various CPAN modules that are used and must be available
## for SenseClusters to function.

	'PREREQ_PM'	=> {'Algorithm::Munkres' => '0.07',
			    'Algorithm::RandomMatrixGeneration' => '0.04',
	  		    'Bit::Vector' => '6.3',
			    'Math::BigFloat' => '1.51',
			    'Math::SparseVector' => '0.04',
			    'Math::SparseMatrix' => '0.02',
			    'PDL' => '2.4.1',
			    'Set::Scalar' => '1.19',
			    'Text::NSP' => '1.05'},

### maybe not necessary to print out long help screen as 
### INSTALL now includes a Bundle and other helpful aids
###	'CONFIGURE'	=> \&configSub,

## if you change INSTALLDIRS from site to perl or default, some of the
## below must change too. Search for INSTALLDIRS to find where. 

	'INSTALLDIRS'	=> 'site',

# do not install any man3 documentation

	'INSTALLMAN3DIR' => 'none',

#  install man pages, we use MAN1PODS to keep all man pages in /man1

	'MAN1PODS' =>  {
# only create man pages for *.pl programs in the main line of SenseClusters
#		'doc/TODO.pod' => '$(INST_MAN1DIR)/TODO.1',
#		'doc/FAQ.pod' => '$(INST_MAN1DIR)/FAQ.1',
#		'doc/Flowcharts/README.Flowcharts.pod' => '$(INST_MAN1DIR)/README.Flowcharts.1',
#		'samples/README.Demos.pod' => '$(INST_MAN1DIR)/README.Demos.1',
#		'Testing/README.Testing.pod' => '$(INST_MAN1DIR)/README.Testing.1',
#		'Toolkit/README.Toolkit.pod' => '$(INST_MAN1DIR)/README.Toolkit.1',
#		'Web/README.Web.pod' => '$(INST_MAN1DIR)/README.Web.1',
#		'Web/SC-cgi/README.SC-cgi.pod' => '$(INST_MAN1DIR)/README.SC-cgi.1',
#		'Web/SC-htdocs/README.SC-htdocs.pod' => '$(INST_MAN1DIR)/README.SC-htdocs.1',
#		'Web/SC-cgi/user_data/README.user_data.pod' => '$(INST_MAN1DIR)/README.user_data.1',
#		'samples/setup.pl' => '$(INST_MAN1DIR)/setup.pl.1',
#		'Testing/svd/svdpackout/svdcompare.pl' => '$(INST_MAN1DIR)/svdcompare.pl.1',
		'lib/Text/SenseClusters.pm' => '$(INST_MAN1DIR)/SenseClusters.1',
		'discriminate.pl' => '$(INST_MAN1DIR)/discriminate.pl.1',
		'Toolkit/clusterlabel/clusterlabeling.pl' => '$(INST_MAN1DIR)/clusterlabeling.pl.1',
		'Toolkit/clusterstop/clusterstopping.pl' => '$(INST_MAN1DIR)/clusterstopping.pl.1',
		'Toolkit/evaluate/cluto2label.pl' => '$(INST_MAN1DIR)/cluto2label.pl.1',
		'Toolkit/evaluate/label.pl' => '$(INST_MAN1DIR)/label.pl.1',
		'Toolkit/evaluate/report.pl' => '$(INST_MAN1DIR)/report.pl.1',
		'Toolkit/evaluate/format_clusters.pl' => '$(INST_MAN1DIR)/format_clusters.pl.1',
		'Toolkit/matrix/simat.pl' => '$(INST_MAN1DIR)/simat.pl.1',
		'Toolkit/matrix/bitsimat.pl' => '$(INST_MAN1DIR)/bitsimat.pl.1',
		'Toolkit/svd/mat2harbo.pl' => '$(INST_MAN1DIR)/mat2harbo.pl.1',
		'Toolkit/svd/svdpackout.pl' => '$(INST_MAN1DIR)/svdpackout.pl.1',
		'Toolkit/count/reduce-count.pl' => '$(INST_MAN1DIR)/reduce-count.pl.1',
		'Toolkit/vector/order1vec.pl' => '$(INST_MAN1DIR)/order1vec.pl.1',
		'Toolkit/vector/order2vec.pl' => '$(INST_MAN1DIR)/order2vec.pl.1',
		'Toolkit/vector/wordvec.pl' => '$(INST_MAN1DIR)/wordvec.pl.1',
		'Toolkit/vector/nsp2regex.pl' => '$(INST_MAN1DIR)/nsp2regex.pl.1',
		'Toolkit/preprocess/plain/text2sval.pl' => '$(INST_MAN1DIR)/text2sval.pl.1',
		'Toolkit/preprocess/sval2/balance.pl' => '$(INST_MAN1DIR)/balance.pl.1',
		'Toolkit/preprocess/sval2/maketarget.pl' => '$(INST_MAN1DIR)/maketarget.pl.1',
		'Toolkit/preprocess/sval2/sval2plain.pl' => '$(INST_MAN1DIR)/sval2plain.pl.1',
		'Toolkit/preprocess/sval2/filter.pl' => '$(INST_MAN1DIR)/filter.pl.1',
		'Toolkit/preprocess/sval2/frequency.pl' => '$(INST_MAN1DIR)/frequency.pl.1',
		'Toolkit/preprocess/sval2/keyconvert.pl' => '$(INST_MAN1DIR)/keyconvert.pl.1',
		'Toolkit/preprocess/sval2/prepare_sval2.pl' => '$(INST_MAN1DIR)/prepare_sval2.pl.1',
		'Toolkit/preprocess/sval2/windower.pl' => '$(INST_MAN1DIR)/windower.pl.1',
		'Toolkit/preprocess/sval2/preprocess.pl' => '$(INST_MAN1DIR)/preprocess.pl.1',
	},

# if INSTALLBINS is changed from site, the directories mentioned below 
# of the form INSTALLSITE* must change. 

# install blib/lib and blib/bin and blib/auto back into themselves.
# we really don't want them installed, so this is the best I could
# come up with to avoid that. make clean will remove all of this
# from blib. This also has the effect of discarding .packlist, which
# is unfortunate, but there is no clear place for it to reside since
# we are only creating /bin and /man.

	'INSTALLSITEBIN'=> '$(INST_BIN)',
	'LIB'=> '$(INST_LIB)',
	'INSTALLSITEARCH'=> '$(INST_ARCHLIB)',

	'EXE_FILES'	=> [
		map ("$_", @wrappers),
##		map ("Testing/svd/svdpackout/$_",@testing_svd_svdpackout),
		map ("Toolkit/preprocess/plain/$_", @toolkit_preprocess_plain),
		map ("Toolkit/preprocess/sval2/$_", @toolkit_preprocess_sval),
		map ("Toolkit/count/$_", @toolkit_count),
		map ("Toolkit/vector/$_", @toolkit_vector),
		map ("Toolkit/svd/$_", @toolkit_svd),
		map ("Toolkit/matrix/$_", @toolkit_matrix),
		map ("Toolkit/clusterlabel/$_", @toolkit_cluslabel),
		map ("Toolkit/clusterstop/$_", @toolkit_cluststop),
		map ("Toolkit/evaluate/$_", @toolkit_evaluate),
	  ],	

 	($] >= 5.005 ?

	(ABSTRACT => 'SenseClusters - Clustering similar written contexts',
	AUTHOR => 'Ted Pedersen <tpederse at d.umn.edu>'):()), 

       # allows make dist to create .tar.gz with correct name/version
       'dist'             => {'COMPRESS' => 'gzip -9f', 'SUFFIX' => 'gz'},
       # allows for automatic creation of META.yml
       ($ExtUtils::MakeMaker::VERSION ge '6.30_00'?
       ('LICENSE' => 'gpl', ) : ()),

);

# we no longer display this, not clear if it was really that helpful 

sub configSub {

print "#################################################################\n";
print "You are running Makefile.PL. When this finishes, remember that you\n";
print "will need to run the following to finish the install of SenseClusters:\n";
print "\n";
print "        make\n";
print "        make install\n";
print "\n";
print "if \"make install\" fails and indicates that you don\'t have proper\n";
print "permissions to install, you do have the option to install SenseClusters in\n";
print "a local directory of your own choosing. You can do this as follows:\n";
print "\n";
print "        perl Makefile.PL PREFIX=/MYPATH\n";
print "        make\n";
print "        make install\n";
print "\n";
print "where /MYPATH is a path/directory that you own and have read write\n";
print "authority. If you aren't sure what to set /MYPATH to, try \$HOME/SC\n";
print "\n";
print "After all this is done, you can run \"make clean\" to remove some\n";
print "of the files created during installation\n";
print "#################################################################\n";

return {};  
}

## postamble is run with "make install"

sub MY::postamble {

	my $postamble = <<'END';
html: 
	@echo "*****************************************************"
	@echo "Installing SenseClusters Package, V $(VERSION)..."
	@echo "into $(PREFIX) "
	@echo "Make sure that the following are in your PATH:"
	@echo "     $(INSTALLSCRIPT)"
	@echo "and that the following is in your MANPATH:"
	@echo "     $(INSTALLSITEMAN1DIR)"
	@echo "After your paths are set, run the test scripts: "
	@echo "    cd Testing"
	@echo "    csh ./ALL-TESTS.sh"
	@echo "    cd .."
	@echo "to verify that installation is ok"
	@echo "*****************************************************"
END
	return ($postamble);
}

sub MY::install {
	my $self = shift;
	my $string = $self->MM::install;
	my $add = 'html';
	$string =~ s/(pure_install\s+)(.*)/$1 $add $2/;
	return $string;
}

