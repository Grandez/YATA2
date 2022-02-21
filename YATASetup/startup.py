'''
Created on 21 feb. 2022

@author: Javier
'''
#! /bin/python3

import os
import sys

euid = os.geteuid()
if not euid == 0:
    print("This sript must be executed as roo", file=sys.stderr)
    exit(127)

print ("Soy root")
ini_file = "YATA.cfg"
uid = os.getenv('SUDO_USER', 'root')

if len(sys.argv) > 1:
    ini_file = sys.argv[1]


print("Total arguments passed:", n)
 
# Arguments passed
print("\nName of Python script:", sys.argv[0])
 
print("\nArguments passed:", end = " ")
for i in range(1, n):
    print(sys.argv[i], end = " ")
