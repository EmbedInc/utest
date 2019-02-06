{   Routines for checking values being within a valid range.
}
module utest_check;
%include 'utest2.ins.pas';
define utest_check_above;
define utest_check_below;
define utest_check_delta;
define utest_check_lim;
define utest_check_percent;
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
      sys_message_parms ('utest', 'check_min_ok', msg_parm, 3);
      end
    else begin
      utest_check_above := false;      {indicate error}
      sys_message_parms ('utest', 'check_min_err', msg_parm, 3);
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
      sys_message_parms ('utest', 'check_max_ok', msg_parm, 3);
      end
    else begin
      utest_check_below := false;      {indicate error}
      sys_message_parms ('utest', 'check_max_err', msg_parm, 3);
      end
    ;
  writeln;
  end;
{
********************************************************************************
*
*   Function UTEST_CHECK_DELTA (NAME, VAL, NOM, DELTA)
*
*   Check that the value VAL with name NAME is within DELTA of NOM.
*
*   If the value is within the valid range, the function returns TRUE and writes
*   a message "Passed" indicating the value and range.  If not, the function
*   returns FALSE and writes a message "FAILED" indicating the value and range.
}
function utest_check_delta (           {check that value is within +-error}
  in      name: string;                {name of the value, for error message}
  in      val: real;                   {value to check}
  in      nom: real;                   {nominal value (0% error)}
  in      delta: real)                 {max allowed deviation from nominal}
  :boolean;                            {value is in range}
  val_param;

const
  max_msg_args = 4;                    {max arguments we can pass to a message}

var
  err: real;
  msg_parm:                            {references arguments passed to a message}
    array[1..max_msg_args] of sys_parm_msg_t;

begin
  err := val - nom;                    {make the error}

  sys_msg_parm_str (msg_parm[1], name); {1 - name of value being tested}
  sys_msg_parm_real (msg_parm[2], nom); {2 - nominal value}
  sys_msg_parm_real (msg_parm[3], delta); {3 - allowed delta}
  sys_msg_parm_real (msg_parm[4], err); {4 - actual delta}

  if abs(err) <= delta
    then begin                         {value is within range}
      utest_check_delta := true;
      sys_message_parms ('utest', 'check_delta_ok', msg_parm, 4);
      end
    else begin                         {value is out of range}
      utest_check_delta := false;
      sys_message_parms ('utest', 'check_delta_err', msg_parm, 4);
      end
    ;
  writeln;
  end;
{
********************************************************************************
*
*   Function UTEST_CHECK_LIM (NAME, VAL, LIMLO, LIMHI)
*
*   Check that the value VAL with name NAME is within LIMLO to LIMHI.
*
*   If the value is within the valid range, the function returns TRUE and writes
*   a message "Passed" indicating the value and range.  If not, the function
*   returns FALSE and writes a message "FAILED" indicating the value and range.
}
function utest_check_lim (             {check that value is within specific limits}
  in      name: string;                {name of the value, for error message}
  in      val: real;                   {value to check}
  in      limlo: real;                 {minimum allowed value}
  in      limhi: real)                 {maximum allowed value}
  :boolean;                            {value is in range}
  val_param;

const
  max_msg_args = 4;                    {max arguments we can pass to a message}

var
  msg_parm:                            {references arguments passed to a message}
    array[1..max_msg_args] of sys_parm_msg_t;

begin
  sys_msg_parm_str (msg_parm[1], name); {1 - name of value being tested}
  sys_msg_parm_real (msg_parm[2], limlo); {2 - low limit}
  sys_msg_parm_real (msg_parm[3], limhi); {3 - high limit}
  sys_msg_parm_real (msg_parm[4], val); {4 - actual value}

  if (val >= limlo) and (val <= limhi)
    then begin                         {value is within range}
      utest_check_lim := true;
      sys_message_parms ('utest', 'check_lim_ok', msg_parm, 4);
      end
    else begin                         {value is out of range}
      utest_check_lim := false;
      sys_message_parms ('utest', 'check_lim_err', msg_parm, 4);
      end
    ;
  writeln;
  end;
{
********************************************************************************
*
*   Function UTEST_CHECK_PERCENT (NAME, VAL, NOM, PCENT)
*
*   Check that the value VAL with name NAME is within PCENT percent of NOM.
*
*   If the value is within the valid range, the function returns TRUE and writes
*   a message "Passed" indicating the value and range.  If not, the function
*   returns FALSE and writes a message "FAILED" indicating the value and range.
}

function utest_check_percent (         {check that value is within +-percent}
  in      name: string;                {name of the value, for error message}
  in      val: real;                   {value to check}
  in      nom: real;                   {nominal value (0% error)}
  in      pcent: real)                 {max allowed percent error from nominal}
  :boolean;                            {value is in range}
 val_param;

const
  max_msg_args = 4;                    {max arguments we can pass to a message}

var
  err: real;                           {actual error in percent}
  msg_parm:                            {references arguments passed to a message}
    array[1..max_msg_args] of sys_parm_msg_t;

begin
  if abs(nom) < 1.0e-30 then begin
    writeln ('NOM too small in UTEST_CHECK_PERCENT');
    sys_bomb;
    end;

  err := 100.0 * (val - nom) / nom;    {compute error in percent}

  sys_msg_parm_str (msg_parm[1], name); {1 - name of value being tested}
  sys_msg_parm_real (msg_parm[2], nom); {2 - nominal value}
  sys_msg_parm_real (msg_parm[3], pcent); {3 - allowed percent error}
  sys_msg_parm_real (msg_parm[4], err); {4 - actual percent error}

  if abs(err) <= pcent
    then begin                         {value is within range}
      utest_check_percent := true;
      sys_message_parms ('utest', 'check_percent_ok', msg_parm, 4);
      end
    else begin                         {value is out of range}
      utest_check_percent := false;
      sys_message_parms ('utest', 'check_percent_err', msg_parm, 4);
      end
    ;
  writeln;
  end;
