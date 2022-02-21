#!/bin/python3

import sys
import os
import configparser

if not sys.platform.startswith('win'):
    import pwd
    import subprocess
    


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
    print("Making package " + package)
    oldwd = os.getcwd()
    os.chdir("/home/yata/YATA2/" + package)

    pw_record = pwd.getpwnam('yata')
    homedir = pw_record.pw_dir
    user_uid = pw_record.pw_uid
    user_gid = pw_record.pw_gid
    env = os.environ.copy()
    env.update({'HOME': homedir, 'LOGNAME': 'yata', 'PWD': os.getcwd()})

    pkg='/home/yata/YATA2/' + package
    #proc = subprocess.Popen(['R', 'CMD', 'INSTALL', '--no-multiarch', '--with-keep.source', pkg],
    proc = subprocess.Popen(['R CMD INSTALL --no-multiarch --with-keep.source ' + pkg],
                              shell=True,
                              env=env,
                              preexec_fn=demote(user_uid, user_gid),
                              stdout=subprocess.PIPE
                              )
    proc.wait()
    os.chdir(oldwd)
    return proc.returncode

file_ini = "YATA.cfg"
n = len(sys.argv)
if (n > 1) :
    file_ini = sys.argv[0]

config = configparser.ConfigParser()
config.read(file_ini)

pkgs = dict(config.items("packages"))
for pkg in pkgs.values():
    print (pkg)
    rc = make_package(pkg)   
    if (rc != 0):
        print("ERROR MAKING PACKAGE " + pkg)
        break


# The code in the module will be executed, just as if you imported it, 
# but with the __name__ set to "__main__". 
# That means that by adding this code at the end of your module:

##if __name__ # == "__main__":#
##    import sys
#    fib(int(sys.argv[1]))

