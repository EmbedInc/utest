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
call src_pas %srcdir% %libname%_open %1
call src_pas %srcdir% %libname%_prog %1
call src_pas %srcdir% %libname%_ser %1
call src_pas %srcdir% %libname%_user %1
call src_pas %srcdir% %libname%_util %1

call src_lib %srcdir% %libname%
call src_msg %srcdir% %libname%
