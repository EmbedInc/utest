@echo off
rem
rem   Define the variables for running builds from this source library.
rem
set srcdir=utest
set buildname=
call treename_var "(cog)source/utest" sourcedir
set libname=utest
set fwname=
call treename_var "(cog)src/%srcdir%/debug_%fwname%.bat" tnam
make_debug "%tnam%"
call "%tnam%"
