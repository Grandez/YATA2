#!/bin/bash
# Crea el proceso inicial
# uso: yata_linux.sh [root]

# Check git
git2 > /dev/null 2> /dev/null
if [ $? -eq 127 ] ; then
   echo "git must be installed"
   exit 127
fi
   