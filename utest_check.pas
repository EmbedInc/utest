{   Routines to check values.
}
module utest_check;
%include 'utest2.ins.pas';
define utest_check_above;
define utest_check_below;
{
********************************************************************************
*
*   Function UTEST_CHECK_ABOVE (NAME, VAL, LEV)
*
*   Check for the value VAL with name NAME being at or above the level LEV.  If
*   so, the function writes a message indicating the values.
*
*   If VAL is below LEV, then the function returns FALSE and writes a message
*   indicating the error.
}
function utest_check_above (           {check for value at or above some level}
  in      name: string;                {name of the value, for error message}
  in      val: real;                   {the value to test}
  in      lev: real)                   {minimum valid value}
  :boolean;                            {value is valid}
  val_param;

const
  max_msg_args = 3;                    {max arguments we can pass to a message}

var
  msg_parm:                            {references arguments passed to a message}
    array[1..max_msg_args] of sys_parm_msg_t;

begin
  sys_msg_parm_str (msg_parm[1], name); {1 - name of value being tested}
  sys_msg_parm_real (msg_parm[2], lev); {2 - threshold}
  sys_msg_parm_real (msg_parm[3], val); {3 - actual measured value}

  if val >= lev
    then begin                         {value is valid}
      utest_check_above := true;       {indicate within spec}
      sys_message_parms ('utest', 'ok_min', msg_parm, 3);
      end
    else begin
      utest_check_above := false;      {indicate error}
      sys_message_parms ('utest', 'err_low', msg_parm, 3);
      end
    ;
  writeln;
  end;
{
********************************************************************************
*
*   Function UTEST_CHECK_BELOW (NAME, VAL, LEV)
*
*   Check for the value VAL with name NAME being at or below the level LEV.  If
*   so, the function writes a message indicating the values.
*
*   If VAL is above LEV, then the function returns FALSE and writes a message
*   indicating the error.
}
function utest_check_below (           {check for value at or below some level}
  in      name: string;                {name of the value, for error message}
  in      val: real;                   {the value to test}
  in      lev: real)                   {maximum valid value}
  :boolean;                            {value is valid}
  val_param;

const
  max_msg_args = 3;                    {max arguments we can pass to a message}

var
  msg_parm:                            {references arguments passed to a message}
    array[1..max_msg_args] of sys_parm_msg_t;

begin
  sys_msg_parm_str (msg_parm[1], name); {1 - name of value being tested}
  sys_msg_parm_real (msg_parm[2], lev); {2 - threshold}
  sys_msg_parm_real (msg_parm[3], val); {3 - actual measured value}

  if val <= lev
    then begin                         {value is valid}
      utest_check_below := true;       {indicate within spec}
      sys_message_parms ('utest', 'ok_max', msg_parm, 3);
      end
    else begin
      utest_check_below := false;      {indicate error}
      sys_message_parms ('utest', 'err_high', msg_parm, 3);
      end
    ;
  writeln;
  end;
