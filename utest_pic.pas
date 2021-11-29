{   Routines related to the PIC connected to the programmer.
}
module utest_pic;
define utest_pic_get;
%include 'utest2.ins.pas';
{
********************************************************************************
*
*   Subroutine UTEST_PIC_GET (UT, NAME, STAT)
*
*   Get the model name of the PIC connected to the programmer.  The model name
*   is derived from the chip ID that is hard-coded in the PIC.  The upper case
*   model name is returned in NAME.  Examples are "16F877" and "33EP128GM604".
*
*   NAME is returned the empty string on error.
}
procedure utest_pic_get (              {get name of PIC model connected to programmer}
  in out  ut: utest_t;                 {UTEST library use state}
  in out  name: univ string_var_arg_t; {returned PIC model name, upper case}
  out     stat: sys_err_t);            {completion status}
  val_param;

var
  tinfo: picprg_tinfo_t;               {info about the target PIC}

begin
  sys_error_none (stat);               {init to no error encountered}
  name.len := 0;                       {init to not returning with PIC name}

  picprg_config (ut.pr, string_v(''(0)), stat); {force re-read of PIC ID}
  if sys_error(stat) then return;

  picprg_tinfo (ut.pr, tinfo, stat);   {get info about the target PIC}
  if sys_error(stat) then return;

  string_copy (tinfo.name, name);      {return the PIC name}
  end;
