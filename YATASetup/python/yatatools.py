'''
Created on 22 feb. 2022

@author: Javier
'''

import sys, os

def getUser():
    return (os.getlogin())
    
def fatal(rc, msg):
    print(msg, file=sys.stderr)
    exit(rc)

def msgnl(msg):
    print(msg, end='')
    
def msg(msg):
    print(msg)
