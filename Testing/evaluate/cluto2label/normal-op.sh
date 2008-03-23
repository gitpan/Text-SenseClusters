#!/bin/csh
# Shell Test script to run all tests which check normal behavior of
# cluto2label.pl 
# normal-op.sh version 0.11
# By Amruta Purandare 05/09/2003

# Copyright (c) 2002-2005
# Amruta Purandare, University of Pittsburgh
# amruta@cs.pitt.edu
# Ted Pedersen, University of Minnesota, Duluth
# tpederse@umn.edu

#############################################################################
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

##############################################################################

set dirlist = `ls testA*.sh`
foreach i ($dirlist)
	$i
end
