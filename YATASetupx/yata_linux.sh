#!/bin/bash
#####################################################################
# Name:    yata_linux.sh
# Purpose: Install and prepare YATA System from scracth
# Author:  Grandez
# Use:     script [root]
#          root - Directory where install YATA
#                 Default $HOME/YATA2
# Requires: git
#
#####################################################################

# Check git
git > /dev/null 2> /dev/null
if [ $? -eq 127 ] ; then
   echo "git must be installed"
   exit 127
fi

echo "Getting YATA"
dest=${HOME}/"YATA2"
if [ $# -gt 0 ] ; then dest=$1 ; fi  
if [ -d $dest ] ; then 
   rm -rf $dest > /dev/null 2> /dev/null
   if [ $? -ne 0 ] ; then 
      echo "Error cleaning YATA directory"
      exit 127
   fi
fi

git clone https://github.com/Grandez/YATA2 $dest > /dev/null 2> /dev/null
rc=$?
if [ $rc -ne 0 ] ; then
   echo "Error " $rc " getting YATA"
   exit 127
fi   

echo "Generating yata.cfg"

cfg=$HOME/yata.cfg
echo "[base]"  > $cfg
echo root=\"$dest\" >> $cfg

distro="Linux"
os=`uname -a`
echo $os | grep -q "Ubuntu"
if [ $? -eq 0 ] ; then distro="Ubuntu" ; fi

echo distro=\"$distro\" >> $cfg     

chmod 775 ${dest}/YATASetup/${distro}/.yatasetup
. ${dest}/YATASetup/${distro}/.yatasetup `whoami` \'$dest\' "scratch" 