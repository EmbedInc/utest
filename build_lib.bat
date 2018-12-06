@echo off
rem
rem   BUILD_LIB [-dbg]
rem
rem   Build the UTEST library.
rem
setlocal
call build_pasinit

call src_insall %srcdir% %libname%

call src_pas %srcdir% %libname%_check %1

call src_lib %srcdir% %libname%
call src_msg %srcdir% %libname%
