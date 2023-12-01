{   Routines that interact with the user.
}
module utest_user;
define utest_user_message;
define utest_user_make_prompt;
define utest_user_prompt_resp;
define utest_user_message_resp;
define utest_user_message_keyw;
define utest_user_message_prmt_wait;
define utest_user_message_wait;
define utest_user_msg;
define utest_user_msg_prmt_wait;
define utest_user_msg_wait;
define utest_user_msg_yes;
define utest_user_msg_yes_y;
define utest_user_msg_yes_n;
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
  in      msg: string;                 {message name within subsystem file}
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
*   Subroutine UTEST_USER_MAKE_PROMPT (SUBSYS, PRMSG, PROMPT)
*
*   Make the prompt string referenced by PRMSG.  There are three different
*   formats for PRMSG:
*
*     Message name
*
*       When PRMSG is a single token, that token is the name of the message
*       within the SUBSYS subsystem.
*
*     Subsystem name, message name
*
*       When PRMSG is two tokens, then the first is the subsystem name and the
*       second the name of the message within that subsystem.  In this case, the
*       value of SUBSYS is irrelevant.
*
*     Anything else
*
*       When PRMSG is anything else (like the empty string, for example), then
*       prompt will be the default of "Done> ".
*
*   PROMPT is returned the prompt string.
}
procedure utest_user_make_prompt (     {make prompt string from msg references}
  in      subsys: string;              {name of subsystem, used to find message file}
  in      prmsg: string;               {prompt msg ref, [subsys] name, def "Done> "}
  in out  prompt: univ string_var_arg_t); {returned prompts string}
  val_param;

var
  vprmsg: string_var80_t;              {var string PRMSG}
  psubsys: string_var80_t;             {prompt message subsystem name}
  pmsg: string_var80_t;                {prompt message name within subsystem}
  p: string_index_t;                   {PRMSG parse index}
  tk: string_var80_t;                  {scratch token}
  def: boolean;                        {use default prompt}
  stat: sys_err_t;

begin
  vprmsg.max := size_char(vprmsg.str); {init local var strings}
  psubsys.max := size_char(psubsys.str);
  pmsg.max := size_char(pmsg.str);
  tk.max := size_char(tk.str);
{
*   Determine the message subsystem and name in PSUBSYS and PMSG, or set DEF to
*   indicate to use the default prompt.
}
  string_vstring (                     {make var string PRMSG in VPRMSG}
    vprmsg, prmsg, size_char(prmsg));
  p := 1;                              {init parse index}
  def := true;                         {init to use default prompt}

  while true do begin                  {try to get prompt message subsys and name}
    string_token (vprmsg, p, psubsys, stat); {get first token into PSUBSYS}
    if sys_error(stat) then exit;      {abort ?}
    string_token (vprmsg, p, pmsg, stat); {get second token into PMSG}
    if string_eos(stat) then begin     {only one token ?}
      string_copy (psubsys, pmsg);     {the only token is the message name}
      string_vstring (                 {subsystem name comes from SUBSYS}
        psubsys, subsys, size_char(subsys));
      def := false;                    {indicate to use PSUBSYS and PMSG}
      exit;
      end;
    if sys_error(stat) then exit;      {hard error getting second token ?}
    string_token (vprmsg, p, tk, stat); {try to get another token}
    if not string_eos(stat) then exit; {not end of string as expected ?}
    def := false;                      {indicate to use PSUBSYS and PMSG}
    exit;
    end;
{
*   Resolve the final prompt.
}
  if def
    then begin                         {use default prompt}
      string_vstring (prompt, 'Done> '(0), -1);
      end
    else begin                         {PSUBSYS and PMSG indicate prompt message}
      string_terminate_null (psubsys); {make sure string bodies are null-terminated}
      string_terminate_null (pmsg);
      string_f_message (prompt,        {expand prompt message into PROMPT}
        psubsys.str, pmsg.str, nil, 0);
      if
          (prompt.len > 0) and         {prompt is not the empty string ?}
          (prompt.str[prompt.len] <> ' ') {doesn't already end in blank ?}
          then begin
        string_append1 (prompt, ' ');  {add blank to separate prompt from user resp}
        end;
      end
    ;
  end;
{
********************************************************************************
*
*   Subroutine UTEST_USER_PROMPT_RESP (SUBSYS, PRMSG, RESP)
*
*   Prompt the user with the string defined by SUBSYS and PRMSG, then return the
*   response in RESP.  See the comments for UTEST_USER_MAKE_PROMPT (above) for
*   a description of SUBSYS and PRMSG.
*
*   RESP is returned what the user entered in response to the prompt.  Trailing
*   blanks, if any, are stripped.
}
procedure utest_user_prompt_resp (     {write prompt, get response string}
  in      subsys: string;              {name of subsystem, used to find message file}
  in      prmsg: string;               {prompt msg ref, [subsys] name, def "Done> "}
  in out  resp: univ string_var_arg_t); {returned response from the user}
  val_param;

var
  prompt: string_var80_t;              {prompt string}

begin
  prompt.max := size_char(prompt.str); {init local var strings}

  utest_user_make_prompt (             {get the prompt string into PROMPT}
    subsys, prmsg, prompt);

  writeln;
  string_prompt (prompt);              {write the prompt}

  string_readin (resp);                {get the string entered by the user}
  string_unpad (resp);                 {remove any trailing blanks}

  writeln;
  writeln;
  end;
{
********************************************************************************
*
*   Subroutine UTEST_USER_MESSAGE_RESP (
*     SUBSYS, MSG, PARMS, NPARMS, PRMSG, RESP)
*
*   Write the message indicated by SUBSYS, MSG, PARMS, and NPARMS to the user.
*   Then write the prompt referenced in PRMSG.  The response from the user is
*   returned in RESP with any trailing blanks stripped.
*
*   PRMSG identifies the message to write as the prompt.  See the comments to
*   subroutine UTEST_USER_MAKE_PROMPT (above) for a more detailed description of
*   PRMSG.
*
*   The prompt defined by PRMSG is written to the user after the message and
*   with no return following.
}
procedure utest_user_message_resp (    {message, prompt, get response}
  in      subsys: string;              {name of subsystem, used to find message file}
  in      msg: string;                 {message name within subsystem file}
  in      parms: univ sys_parm_msg_ar_t; {array of parameter descriptors}
  in      nparms: sys_int_machine_t;   {number of parameters in PARMS}
  in      prmsg: string;               {prompt msg ref, [subsys] name, def "Done> "}
  in out  resp: univ string_var_arg_t); {returned response from the user}
  val_param;

begin
  utest_user_message (                 {write the message}
    subsys, msg, parms, nparms);
  utest_user_prompt_resp (             {write the prompt and get the response}
    '', prmsg, resp);
  end;
{
********************************************************************************
*
*   Subroutine UTEST_USER_MESSAGE_KEYW (
*     SUBSYS, MSG, PARMS, NPARMS, PRMSG, KEYWS, PICK)
*
*   The parameters SUBSYS, MSG, PARMS, NPARMS, and PRMSG specify a message and
*   prompt that will be written to the user.  See the UTEST_USER_MESSAGE_RESP
*   subroutine description (above) for details.
*
*   The response entered by the user will be compared against the list of
*   keywords in KEYWS, and PICK returned the 1-N number of the matching keyword.
*   Keyword matches are case-insensitive.  If just hitting ENTER is a desired
*   response, then the empty string must be one of the keywords in the list.
*
*   The only valid user response is one of the keywords in the list.  Several
*   attempts are made to get a correct entry from the user.  However, eventually
*   the program is aborted with a suitable error message if the user persists in
*   supplying invalid responses.
*
*   KEYWS is a Pascal string containing the list of valid response keywords.
*   These must be upper case, and separated by one or more spaces from each
*   other.  To add the empty string as a valid keyword, use two quotes ("").
}
procedure utest_user_message_keyw (    {write message, get response keyword}
  in      subsys: string;              {name of subsystem, used to find message file}
  in      msg: string;                 {message name within subsystem file}
  in      parms: univ sys_parm_msg_ar_t; {array of parameter descriptors}
  in      nparms: sys_int_machine_t;   {number of parameters in PARMS}
  in      prmsg: string;               {prompt msg ref, [subsys] name, def "Done> "}
  in      keyws: string;               {keyw choices, blank separate, upper case}
  out     pick: sys_int_machine_t);    {1-N number of chosen keyword}
  val_param;

const
  max_tries = 3;                       {max allowed attempts to enter valid response}

var
  try: sys_int_machine_t;              {1-N number of try to get valid response}
  resp: string_var80_t;                {response from user}

begin
  resp.max := size_char(resp.str);     {init local var string}

  utest_user_message (                 {write the message}
    subsys, msg, parms, nparms);

  for try := 1 to max_tries do begin   {back here to retry after invalid response}
    case try of                        {what attempt is this ?}
1:    ;                                {first attempt, nothing wrong yet}
2:    sys_message ('utest', 'try2done'); {first bad response message}
otherwise
      sys_message ('utest', 'try3done'); {subsequent bad response messages}
      end;
    if try <> 1 then begin             {not the first attempt ?}
      sys_beep (0.5, 0.0, 1);          {beep to alert to new prompt}
      end;

    utest_user_prompt_resp (           {prompt the user and get the response}
      subsys, prmsg, resp);
    string_upcase (resp);              {make upper case for keyword matching}
    string_tkpick80 (resp, keyws, pick); {pick matching keyword from list}
    if pick > 0 then return;           {user entered a valid keyword ?}
    end;                               {back to try again}
{
*   Giving up trying to get this moron to enter a valid response.
}
  sys_message ('utest', 'tryabort');
  writeln;
  sys_bomb;
  end;
{
********************************************************************************
*
*   Function UTEST_USER_MESSAGE_PRMT_WAIT (UT, SUBSYS, MSG, PARMS, NPARMS, PRMSG)
*
*   Write the indicated message, then prompt the user to hit ENTER when done.
*   This routine does not return until the user hits ENTER.
*
*   PRMSG specifies the the prompt by referencing a message.  The description of
*   subroutine UTEST_USER_MAKE_PROMPT for details of PRMSG.
*
*   This routine allows additional "hidden" responses instead of just ENTER (the
*   empty string):
*
*     S
*
*       Skip this step.  The function returns FALSE, and the SKIPPED counter is
*       incremented by 1.
*
*     Q
*
*       Quit the program.  The program is aborted with error.
*
*   The above special keywords are case-insensitive.
}
function utest_user_message_prmt_wait ( {write message, wait for user to hit ENTER}
  in out  ut: utest_t;                 {UTEST library use state}
  in      subsys: string;              {name of subsystem, used to find message file}
  in      msg: string;                 {message name within subsystem file}
  in      parms: univ sys_parm_msg_ar_t; {array of parameter descriptors}
  in      nparms: sys_int_machine_t;   {number of parameters in PARMS}
  in      prmsg: string)               {prompt msg ref, [subsys] name, def "Done> "}
  :boolean;                            {TRUE confirmed normally, FALSE skip}
  val_param;

var
  pick: sys_int_machine_t;             {number of keyword picked from the list}
  stat: sys_err_t;

begin
  utest_user_message_prmt_wait := true; {init to got normal confirm (empty string)}

  utest_user_message_keyw (            {write message and prompt, expect keyword}
    subsys, msg, parms, nparms,        {parameters defining the message to write}
    prmsg,                             {specify the prompt}
    '"" S Q',                          {keywords allowed}
    pick);                             {returned 1-N selected keyword number}

  case pick of                         {which keyword was entered ?}
1:  begin                              {empty string}
      return;
      end;
2:  begin                              {S - skip this step}
      ut.skipped := ut.skipped +1;     {count one more skipped step}
      utest_user_message_prmt_wait := false; {indicate skip}
      return;
      end;
otherwise                              {Q (or anything else) - quit}
    utest_lib_close (ut, stat);        {try to shut down cleanly}
    sys_bomb;
    end;                               {end of keyword cases}
  end;
{
********************************************************************************
*
*   Function UTEST_USER_MESSAGE_WAIT (UT, SUBSYS, MSG, PARMS, NPARMS)
*
*   Write the indicated message, then prompt the user to hit ENTER when done.
*   This routine does not return until the user hits ENTER.
*
*   This routine allows additional "hidden" responses instead of just ENTER (the
*   empty string):
*
*     S
*
*       Skip this step.  The function returns FALSE, and the SKIPPED counter is
*       incremented by 1.
*
*     Q
*
*       Quit the program.  The program is aborted with error.
*
*   The above special keywords are case-insensitive.
}
function utest_user_message_wait (     {write message, wait for user to hit ENTER}
  in out  ut: utest_t;                 {UTEST library use state}
  in      subsys: string;              {name of subsystem, used to find message file}
  in      msg: string;                 {message name within subsystem file}
  in      parms: univ sys_parm_msg_ar_t; {array of parameter descriptors}
  in      nparms: sys_int_machine_t)   {number of parameters in PARMS}
  :boolean;                            {TRUE confirmed normally, FALSE skip}
  val_param;

begin
  utest_user_message_wait := utest_user_message_prmt_wait (
    ut, subsys, msg, parms, nparms, '');
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
  in      msg: string);                {message name within subsystem file}
  val_param;

begin
  utest_user_message ('', msg, nil, 0);
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
  in      msg: string)                 {message name within subsystem file}
  :boolean;                            {TRUE confirmed normally, FALSE skip}
  val_param;

begin
  utest_user_msg_wait :=
    utest_user_message_prmt_wait (ut, '', msg, nil, 0, '');
  end;
{
********************************************************************************
*
*   Function UTEST_USER_MSG_PRMT_WAIT (UT, MSG, PRMSG)
*
*   Like UTEST_USER_MESSAGE_PRMT_WAIT, except that the message is in the message
*   file unique to this program, and no parameters are passed to the message.
}
function utest_user_msg_prmt_wait (    {message, wait for user, defaulf msg file}
  in out  ut: utest_t;                 {UTEST library use state}
  in      msg: string;                 {message name within subsystem file}
  in      prmsg: string)               {prompt msg ref, [subsys] name, def "Done> "}
  :boolean;                            {TRUE confirmed normally, FALSE skip}
  val_param;

begin
  utest_user_msg_prmt_wait :=
    utest_user_message_prmt_wait (ut, '', msg, nil, 0, prmsg);
  end;
{
********************************************************************************
*
*   Function UTEST_USER_MSG_YES (MSG)
*
*   Show the message MSG within the program's private message file.  The
*   function value reflects the user's yes/no choice.  There is no default.  A
*   yes or no response is required.
}
function utest_user_msg_yes (          {message, get yes/no response, no default}
  in      msg: string)                 {message name within program's msg file}
  :boolean;                            {TRUE for yes, FALSE for no}
  val_param;

var
  pick: sys_int_machine_t;             {number of keyword picked from the list}

begin
  utest_user_message_keyw (            {write message, get response keyword number}
    '', msg, nil, 0,                   {message parameters}
    'utest prompt_yesno',              {reference to prompt message}
    'Y YES N NO',                      {the value user responses}
    pick);                             {1-N number of user response keyword}
  utest_user_msg_yes := pick <= 2;     {TRUE for yes, FALSE for no}
  end;
{
********************************************************************************
*
*   Function UTEST_USER_MSG_YES_Y (MSG)
*
*   Show the message MSG within the program's private message file.  The
*   function value reflects the user's yes/no choice.  The default when the
*   empty string is entered (just hit RETURN) is YES.
}
function utest_user_msg_yes_y (        {message, get yes/no response, default yes}
  in      msg: string)                 {message name within program's msg file}
  :boolean;                            {TRUE for yes, FALSE for no}
  val_param;

var
  pick: sys_int_machine_t;             {number of keyword picked from the list}

begin
  utest_user_message_keyw (            {write message, get response keyword number}
    '', msg, nil, 0,                   {message parameters}
    'utest prompt_yesno_y',            {reference to prompt message}
    '"" Y YES N NO',                   {the value user responses}
    pick);                             {1-N number of user response keyword}
  utest_user_msg_yes_y := pick <= 3;   {TRUE for yes, FALSE for no}
  end;
{
********************************************************************************
*
*   Function UTEST_USER_MSG_YES_N (MSG)
*
*   Show the message MSG within the program's private message file.  The
*   function value reflects the user's yes/no choice.  The default when the
*   empty string is entered (just hit RETURN) is NO.
}
function utest_user_msg_yes_n (        {message, get yes/no response, default no}
  in      msg: string)                 {message name within program's msg file}
  :boolean;                            {TRUE for yes, FALSE for no}
  val_param;

var
  pick: sys_int_machine_t;             {number of keyword picked from the list}

begin
  utest_user_message_keyw (            {write message, get response keyword number}
    '', msg, nil, 0,                   {message parameters}
    'utest prompt_yesno_n',            {reference to prompt message}
    'Y YES "" N NO',                   {the value user responses}
    pick);                             {1-N number of user response keyword}
  utest_user_msg_yes_n := pick <= 2;   {TRUE for yes, FALSE for no}
  end;
