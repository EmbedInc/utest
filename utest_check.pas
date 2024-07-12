{   Routines for checking values being within a valid range.
}
module utest_check;
define utest_check_above;
define utest_check_below;
define utest_check_delta;
define utest_check_lim;
define utest_check_percent;
define utest_check_bits;
define utest_check_true;
%include 'utest2.ins.pas';
{
********************************************************************************
*
*   Local subroutine BITS_STR (BITS, MASK, STR)
*
*   Make the string of the binary representation of the bits in BITS that have
*   the associated bits in MASK set.  A "0" or "1" digit is written for each
*   bit with its MASK bit set.  Nothing is written for a bit when its MASK bit
*   is 0.
}
procedure bits_str (                   {make binary bits string}
  in      bits: sys_int_conv32_t;      {the input bits}
  in      mask: sys_int_conv32_t;      {mask of valid bits in BITS}
  in out  str: univ string_var_arg_t); {returned string}
  val_param; internal;

var
  bit: sys_int_machine_t;              {0-31 number of current bit}
  m: sys_int_conv32_t;                 {mask for the current bit}
  dig: char;                           {digit to write for the current bit}

begin
  str.len := 0;                        {init the returned string to empty}

  for bit := 31 downto 0 do begin      {once for each bit, MSB to LSB order}
    m := lshft(1, bit);                {make mask for this bit}
    if (m & mask) = 0 then next;       {this bit is not used, ignore ?}
    if (m & bits) = 0
      then dig := '0'
      else dig := '1';
    string_append1 (str, dig);         {add this digit to end of output string}
    end;                               {back for next bit}
  end;
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
{
********************************************************************************
*
*   Function UTEST_CHECK_BITS (NAME, VAL, REF, MASK)
*
*   Check that the bits in VAL match the bits in REF.  MASK indicates which bits
*   in VAL and REF are relevant.  When a MASK bit is 0, the corresponding VAL
*   bit is not checked, and the bit is not included in any message.
*
*   The function returns TRUE when the selected bits in VAL match those in REF.
*   Otherwise, the function returns FALSE.  A message is emitted in either case.
}
function utest_check_bits (            {check that bits are set to specified value}
  in      name: string;                {name of the value, for message}
  in      val: sys_int_conv32_t;       {the bits to check}
  in      ref: sys_int_conv32_t;       {correct bit values}
  in      mask: sys_int_conv32_t)      {mask of used bits in VAL and REF}
  :boolean;                            {all bits correct}
  val_param;

const
  max_msg_args = 3;                    {max arguments we can pass to a message}

var
  strval: string_var32_t;              {actual bits string}
  strexp: string_var32_t;              {expected bits string}
  msg_parm:                            {references arguments passed to a message}
    array[1..max_msg_args] of sys_parm_msg_t;

begin
  strval.max := size_char(strval.str); {init local var strings}
  strexp.max := size_char(strexp.str);

  bits_str (val, mask, strval);        {make actual value bits string}
  bits_str (ref, mask, strexp);        {make expected bits string}
  sys_msg_parm_str (msg_parm[1], name); {1 - name of bits being tested}
  sys_msg_parm_vstr (msg_parm[2], strval); {2 - actual bit settings}
  sys_msg_parm_vstr (msg_parm[3], strexp); {3 - expected bit settings}

  if (xor(val, ref) & mask) = 0
    then begin                         {bits are correct}
      utest_check_bits := true;        {indicate correct}
      sys_message_parms ('utest', 'check_bits_ok', msg_parm, 3);
      end
    else begin                         {bits are different}
      utest_check_bits := false;       {indicate error}
      sys_message_parms ('utest', 'check_bits_err', msg_parm, 3);
      end
    ;
  writeln;
  end;
{
********************************************************************************
*
*   Function UTEST_CHECK_TRUE (NAME, TF)
*
*   Check that the boolean value TF is TRUE.  NAME is the name or description of
*   what is being checked.  NAME is used in the message emitted to the user.
*
*   The function returns TRUE if the test passed (TF is TRUE), and false if the
*   test did not pas (TF is FALSE).
}
function utest_check_true (            {check that a boolean value is TRUE}
  in      name: string;                {description of test, for message}
  in      tf: boolean)                 {value to check, must be TRUE for pass}
  :boolean;                            {value is correct}
  val_param;

const
  max_msg_args = 1;                    {max arguments we can pass to a message}

var
  msg_parm:                            {references arguments passed to a message}
    array[1..max_msg_args] of sys_parm_msg_t;

begin
  sys_msg_parm_str (msg_parm[1], name); {1 - name of value or test description}

  if tf
    then begin                         {test passed}
      utest_check_true := true;        {indicate success}
      sys_message_parms ('utest', 'check_tf_ok', msg_parm, 1);
      end
    else begin
      utest_check_true := false;       {indicate failure}
      sys_message_parms ('utest', 'check_tf_err', msg_parm, 1);
      end
    ;
  writeln;
  end;
