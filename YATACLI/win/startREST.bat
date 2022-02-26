: Start REST Server in Windows
: Author: Grandez
:
@echo off
SET RCMD=C:\SDK\R\R-4.0.4\bin\Rscript.exe
%RCMD%  --arch x64 --default-packages="YATABase" -e YATAREST::start(4001)
