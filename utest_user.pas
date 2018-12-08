{   Routines that interact with the user.
}
module utest_user;
define utest_user_message;
define utest_user_msg;
define utest_user_message_wait;
define utest_user_mssg_wait;
%include 'utest2.ins.pas';
{
********************************************************************************
*
*   Subroutine UTEST_USER_MESSAGE (SUBSYS, MSG, PARMS, NPARMS)
*
*   Write a message to the user.  The message will be visually separated from
*   previous output, and a beep will be emitted after the message is written.
*
*   SUBSYS, MSG, PARMS, and NPARMS are the usual parameters to reference a
*   message and to supply parameters to it.  SUBSYS is the subsystem name, which
*   is the name of the message file.  MSG is the name of the message within the
*   message file.  PARMS is a array of parameters, and NPARMS is the number of
*   parameters in PARMS.  If no parameters are being supplied, pass NIL for
*   PARMS and 0 for NPARMS.
}
procedure utest_user_message (         {write separator, message, beep}
  in      subsys: string;              {name of subsystem, used to find message file}
  in      msg: string;                 {message name withing subsystem file}
  in      parms: univ sys_parm_msg_ar_t; {array of parameter descriptors}
  in      nparms: sys_int_machine_t);  {number of parameters in PARMS}
  val_param;

begin
  writeln;
  writeln;
  writeln;
  sys_message_parms (subsys, msg, parms, nparms); {write the message}
  sys_beep (0.5, 0.0, 1);              {beep to alert to prompt}
  end;
{
********************************************************************************
*
*   Subroutine UTEST_USER_MSG (MSG)
*
*   This is a special case version of UTEST_USER_MESSAGE where no parameters
*   are passed to the message, and where the message is always taken from the
*   message file unique to the current program.
}
procedure utest_user_msg (             {default message file, no parameters}
  in      msg: string);                {message name withing subsystem file}
  val_param;

begin
  utest_user_message ('', msg, nil, 0);
  end;
{
********************************************************************************
*
*   Function UTEST_USER_MESSAGE_WAIT (UT, SUBSYS, MSG, PARMS, NPARMS)
*
*   Write the indicated message, then prompt the user to hit ENTER when done.
*   This routine does not return until the user hits ENTER.
*
*   The function returns TRUE if the user hit ENTER normally.  The function
*   returns FALSE is the user wants to skip the upcoming step.
}
function utest_user_message_wait (     {write message, wait for user to hit ENTER}
  in out  ut: utest_t;                 {UTEST library use state}
  in      subsys: string;              {name of subsystem, used to find message file}
  in      msg: string;                 {message name withing subsystem file}
  in      parms: univ sys_parm_msg_ar_t; {array of parameter descriptors}
  in      nparms: sys_int_machine_t)   {number of parameters in PARMS}
  :boolean;                            {TRUE confirmed normally, FALSE skip}
  val_param;

var
  try: sys_int_machine_t;              {1-N number of try to get done indication}
  rsp: string_var32_t;                 {user response string}
  pick: sys_int_machine_t;             {number of keyword picked from list}
  stat: sys_err_t;

label
  retry;

begin
  rsp.max := size_char(rsp.str);       {init local var string}

  utest_user_message (subsys, msg, parms, nparms); {write the prompt message}

  utest_user_message_wait := true;     {init to user did normal confirm}
  try := 1;                            {init number of try}
retry:
  string_prompt (string_v('Done> '(0))); {write the prompt}
  string_readin (rsp);                 {get string entered by user}
  writeln;
  writeln;
  string_unpad (rsp);                  {remove trailing blanks}
  if rsp.len = 0 then return;          {just ENTER, as expected}

  string_upcase (rsp);                 {make upper case for keyword matching}
  string_tkpick80 (rsp,                {which command is it ?}
    'Q S',
    pick);
  case pick of
1:  begin                              {Q  -  quit the program}
      utest_close (ut, stat);          {try to shut down cleanly}
      sys_bomb;
      end;
2:  begin                              {S  -  skip this step}
      utest_user_message_wait := false; {indicate user wants to skip this step}
      ut.skipped := ut.skipped +1;     {count one more skipped step}
      return;
      end;
    end;                               {not one of the recognized commands}

  try := try + 1;                      {make number of this new try}
  case try of                          {which try is this ?}
2:  sys_message ('utest', 'try2done');
3:  sys_message ('utest', 'try3done');
otherwise
    sys_message ('utest', 'tryabort');
    writeln;
    sys_bomb;
    end;
  sys_beep (0.5, 0.0, 1);              {beep to alert to prompt}

  goto retry;
  end;
{
********************************************************************************
*
*   Function UTEST_USER_MSG_WAIT (UT, MSG)
*
*   Like UTEST_USER_MESSAGE_WAIT, except that the message is in the message file
*   unique to this program, and no parameters are passed to the message.
}
function utest_user_msg_wait (         {message, wait for user, defaulf msg file}
  in out  ut: utest_t;                 {UTEST library use state}
  in      msg: string)                 {message name withing subsystem file}
  :boolean;                            {TRUE confirmed normally, FALSE skip}
  val_param;

begin
  utest_user_msg_wait :=
    utest_user_message_wait (ut, '', msg, nil, 0);
  end;
