{   Small utility routines that don't pertain directly to any of the other
*   modules.
}
module utest_util;
define utest_wait;
%include 'utest2.ins.pas';
{
********************************************************************************
*
*   Subroutine UTEST_WAIT (UT, SEC)
*
*   Wait SEC seconds.  The wait is timed in the programmer.  This routine does
*   not return until at least SEC seconds have elapsed.
}
procedure utest_wait (                 {wait a minimum time, performed in programmer}
  in out  ut: utest_t;                 {UTEST library use state}
  in      sec: real);                  {seconds to wait}
  val_param;

var
  flags: int8u_t;                      {wait completion status flags}
  stat: sys_err_t;                     {completion status}

begin
  picprg_cmdw_wait (ut.pr, sec, stat); {start the wait}
  sys_error_abort (stat, '', '', nil, 0);
  picprg_cmdw_waitchk (ut.pr, flags, stat); {wait for timed interval to complete}
  sys_error_abort (stat, '', '', nil, 0);
  end;
