#!/bin/python3

import sys
import os, pwd, subprocess
import configparser
import shutil

yataroot = os.environ.get('YATA_ROOT')
if not yataroot :
    print("Missing environment variable YATA_ROOT", file=sys.stderr)
    exit(127)

sys.path.insert(0, yataroot + '/YATASetup/python')

import yatatools as tools

def demote(user_uid, user_gid):
    def result():
        os.setgid(user_gid)
        os.setuid(user_uid)
    return result

def exec_cmd(username):
    # get user info from username
    pw_record = pwd.getpwnam(username)
    homedir = pw_record.pw_dir
    user_uid = pw_record.pw_uid
    user_gid = pw_record.pw_gid
    env = os.environ.copy()
    env.update({'HOME': homedir, 'LOGNAME': username, 'PWD': os.getcwd(), 'FOO': 'bar', 'USER': username})

# execute the command
# R CMD INSTALL --preclean --no-multiarch --with-keep.source YATATools
#    proc = subprocess.Popen(['echo $USER; touch myFile.txt'],
# R CMD INSTALL --preclean --no-multiarch --with-keep.source YATATools
    proc = subprocess.Popen(['R', 'CMD', 'INSTALL', '--no-multiarch', '--with-keep.source', ],
                              shell=True,
                              env=env,
                              preexec_fn=demote(user_uid, user_gid),
                              stdout=subprocess.PIPE)
    proc.wait()

def make_package(package):
    tools.msg("Making package " + package)
    #oldwd = os.getcwd()
    #os.chdir("/home/yata/YATA2/" + package)

    pw_record = pwd.getpwnam(os.getlogin())
    homedir = pw_record.pw_dir
    user_uid = pw_record.pw_uid
    user_gid = pw_record.pw_gid
    env = os.environ.copy()
    env.update({'HOME': homedir, 'LOGNAME': 'yata', 'PWD': os.getcwd()})

    pkg = yataroot + '/' + package
    #proc = subprocess.Popen(['R', 'CMD', 'INSTALL', '--no-multiarch', '--with-keep.source', pkg],
    proc = subprocess.Popen(['R CMD INSTALL --no-multiarch --with-keep.source ' + pkg],
                              shell=True,
                              env=env,
                              preexec_fn=demote(user_uid, user_gid),
                              stdout=subprocess.PIPE
                              )
    proc.wait()
    #os.chdir(oldwd)
    return proc.returncode

file_ini = yataroot + '/YATASetup/yata.cfg'
n = len(sys.argv)
if (n > 1) :
    file_ini = sys.argv[0]

config = configparser.ConfigParser()
config.read(file_ini)

oldwd = os.getcwd()
os.chdir(yataroot)
tools.msg("Retrieving repository")    
# config["YATA"]["repo"]
proc = subprocess.run("git pull")
if proc.returncode != 0:
    os.chdir(oldwd)
    tools.fatal(16, "Error " + str(proc.returncode) + "retrieving repository")

os.chdir(oldwd)
pkgs = dict(config.items("packages"))
for pkg in pkgs.values():
    #print (pkg)
    rc = make_package(pkg)   
    if (rc != 0):
        tools.fatal(4, "ERROR MAKING PACKAGE " + pkg)
        
tools.msg("Moving packages to " + os.environ.get("R_LIBS_SITE"))
shutil.copytree(os.environ.get("R_LIBS_USER"), os.environ.get("R_LIBS_SITE"))
