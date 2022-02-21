'''
Created on 21 feb. 2022

@author: Javier
'''
#! /bin/python3

import os
import sys

euid = os.geteuid()
if ! euid == 0:
    print("This sript must be executed as roo", file=sys.stderr)
    exit(127)

print("Usuario es root")    
