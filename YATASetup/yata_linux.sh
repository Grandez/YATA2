#!/bin/bash
# Crea el proceso inicial
# uso: yata_linux.sh [root]

# Check git
git > /dev/null 2> /dev/null
if [ $? -eq 127 ] ; then
   echo "git must be installed"
   exit 127
fi

echo "Getting YATA"
dest=${HOME}/"YATA2"
if [ $# -gt 1 ] ; then dest=$1 ; fi   
git clone https://github.com/Grandez/YATA2 $dest
rc=$?
if [ $rc -ne 0 ] ; then
   echo "Error " $rc " getting YATA"
   exit 127
fi   

cfg=$HOME/yata2.cfg
echo "[base]"  > $cfg
echo root=$dest >> $cfg
    