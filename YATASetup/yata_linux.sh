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
git clone https://github.com/Grandez/YATA2 $1
rc=$?
if [ $rc -ne 0 ] ; then
   echo "Error " $rc " getting YATA"
   exit 127
fi   
      