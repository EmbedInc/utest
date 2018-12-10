{   Small utility routines that don't pertain directly to any of the other
*   modules.
}
module utest_util;
define utest_announce;
define utest_wait;
%include 'utest2.ins.pas';
{
********************************************************************************
*
*   Subroutine UTEST_ANNOUNCE
*
*   Write information about this program to standard output.
}
procedure utest_announce;              {announce this program and its build date/time}
  val_param;

const
  max_msg_args = 2;                    {max arguments we can pass to a message}

var
  msg_parm:                            {references arguments passed to a message}
    array[1..max_msg_args] of sys_parm_msg_t;
  tk1, tk2: string_var80_t;            {message parameters}

begin
  tk1.max := size_char(tk1.str);       {init local var string}
  tk2.max := size_char(tk2.str);

  string_progname (tk1);               {get the name of this program}
  string_upcase (tk1);
  sys_msg_parm_vstr (msg_parm[1], tk1);

  string_vstring (tk2, build_dtm_str, size_char(build_dtm_str)); {get date/time string}
  sys_msg_parm_vstr (msg_parm[2], tk2);
  sys_message_parms ('utest', 'datetime', msg_parm, 2);
  end;
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
