{   Public include file for the UTEST library.
*
*   This library provides a precedural interface for a production tester based
*   on an Embed Inc USBProg PIC programmer.  It also includes other functions
*   useful for implementing production testers.
}
const
{
*   Error status values related to the UTEST library.
}
  utest_subsys_k = -64;                {subsystem ID for the UTEST library}

  utest_stat_dupname_k = 1;            {duplicate programmer names found}
  utest_stat_prog_nfnd_k = 2;          {named programmer not found}
  utest_stat_notnbytes_k = 3;          {not received required number of bytes}
{
*   Other constants.
}
  utest_obuf_size = 256;               {size of serial data port output buffer}
  utest_ibuf_size = 256;               {size of serial data port input buffer}

  utest_obuf_last = utest_obuf_size - 1;
  utest_ibuf_last = utest_ibuf_size - 1;

type
  utest_fw_t = record                  {version info of one firmware}
    typ: sys_int_machine_t;            {type ID}
    ver: sys_int_machine_t;            {version number}
    seq: sys_int_machine_t;            {sequence number}
    end;

  utest_t = record                     {data for one use of this library}
    pr: picprg_t;                      {PICPRG library use state}
    ibuf:                              {serial data port input buffer}
      array[0..utest_ibuf_last] of int8u_t;
    ibufn: sys_int_machine_t;          {number of bytes in IBUF}
    ibufrd: sys_int_machine_t;         {IBUF index of next byte to read}
    obuf:                              {serial data port output buffer}
      array[0..utest_ibuf_last] of int8u_t;
    obufn: sys_int_machine_t;          {number of bytes in OBUF}
    skipped: sys_int_machine_t;        {number of tests that were skipped}
    open: boolean;                     {PICPRG library state is open}
    end;
{
********************************************************************************
*
*   Routines that access the tester.  These require a current library use state.
}
procedure utest_lib_close (            {end a use of the UTEST library}
  in out  ut: utest_t;                 {UTEST library use state, returned invalid}
  out     stat: sys_err_t);            {completion status}
  val_param; extern;

procedure utest_lib_init (             {make UTEST lib state valid, but don't open}
  in out  ut: utest_t);                {UTEST library use state, returned valid}
  val_param; extern;

procedure utest_lib_open (             {start a new use of the UTEST library}
  in      name: univ string_var_arg_t; {name of the USBProg in the tester}
  out     ut: utest_t;                 {returned library use state}
  out     stat: sys_err_t);            {completion status}
  val_param; extern;

procedure utest_pic_get (              {get name of PIC model connected to programmer}
  in out  ut: utest_t;                 {UTEST library use state}
  in out  name: univ string_var_arg_t; {returned PIC model name, upper case}
  out     stat: sys_err_t);            {completion status}
  val_param; extern;

procedure utest_prog (                 {program data into a target PIC}
  in out  ut: utest_t;                 {UTEST library use state}
  in      hexdir: univ string_treename_t; {directory to look for HEX file in}
  in      fwname: string;              {bare firmware name, no version or path}
  in      ver: sys_int_machine_t;      {required firmware version}
  in      pic: string;                 {PIC model, like "16LF1786", case-insensitive}
  out     stat: sys_err_t);            {completion status}
  val_param; extern;

function utest_ser_get8 (              {get next 8 bit unsigned value from receive buffer}
  in out  ut: utest_t)                 {UTEST library use state}
  :sys_int_machine_t;                  {byte value, 0 when no byte available}
  val_param; extern;

function utest_ser_get8s (             {get next 8 bit signed value from receive buffer}
  in out  ut: utest_t)                 {UTEST library use state}
  :sys_int_machine_t;                  {byte value, 0 when not byte available}
  val_param; extern;

function utest_ser_get16 (             {get next 16 bit unsigned value from receive buffer}
  in out  ut: utest_t)                 {UTEST library use state}
  :sys_int_machine_t;                  {16 bit value, high to low byte order from buff}
  val_param; extern;

function utest_ser_get16s (            {get next 16 bit signed value from receive buffer}
  in out  ut: utest_t)                 {UTEST library use state}
  :sys_int_machine_t;                  {16 bit value, high to low byte order from buff}
  val_param; extern;

function utest_ser_get24 (             {get next 24 bit unsigned value from receive buffer}
  in out  ut: utest_t)                 {UTEST library use state}
  :sys_int_machine_t;                  {24 bit value, high to low byte order from buff}
  val_param; extern;

function utest_ser_get24s (            {get next 24 bit signed value from receive buffer}
  in out  ut: utest_t)                 {UTEST library use state}
  :sys_int_machine_t;                  {24 bit value, high to low byte order from buff}
  val_param; extern;

function utest_ser_get32 (             {get next 32 bit value from receive buffer}
  in out  ut: utest_t)                 {UTEST library use state}
  :sys_int_machine_t;                  {32 bit value, high to low byte order from buff}
  val_param; extern;

function utest_ser_nrecv (             {get number of unread bytes in receive buffer}
  in out  ut: utest_t)                 {UTEST library use state}
  :sys_int_machine_t;                  {number of remaining unread bytes}
  val_param; extern;

procedure utest_ser_recv (             {receive serial data into internal buffer}
  in out  ut: utest_t;                 {UTEST library use state}
  in      wait: real;                  {seconds to wait before attempting read}
  in      n: sys_int_machine_t;        {required number of bytes, 0 = any number}
  out     stat: sys_err_t);            {completion status}
  val_param; extern;

procedure utest_ser_recv_flush (       {read and discard serial bytes until no more}
  in out  ut: utest_t;                 {UTEST library use state}
  out     stat: sys_err_t);            {completion status}
  val_param; extern;

procedure utest_ser_send (             {send all buffered serial data}
  in out  ut: utest_t;                 {UTEST library use state}
  out     stat: sys_err_t);            {completion status}
  val_param; extern;

procedure utest_ser_send8 (            {send 8 bits serial, buffer as much as possible}
  in out  ut: utest_t;                 {UTEST library use state}
  in      d: sys_int_conv8_t;          {data in low bits}
  out     stat: sys_err_t);            {completion status}
  val_param; extern;

procedure utest_ser_send16 (           {send 16 bits serial, buffer as much as possible}
  in out  ut: utest_t;                 {UTEST library use state}
  in      d: sys_int_conv16_t;         {data in low bits, high to low byte order}
  out     stat: sys_err_t);            {completion status}
  val_param; extern;

procedure utest_ser_send24 (           {send 24 bits serial, buffer as much as possible}
  in out  ut: utest_t;                 {UTEST library use state}
  in      d: sys_int_conv24_t;         {data in low bits, high to low byte order}
  out     stat: sys_err_t);            {completion status}
  val_param; extern;

procedure utest_ser_send32 (           {send 32 bits serial, buffer as much as possible}
  in out  ut: utest_t;                 {UTEST library use state}
  in      d: sys_int_conv32_t;         {data in low bits, high to low byte order}
  out     stat: sys_err_t);            {completion status}
  val_param; extern;

function utest_user_message_prmt_wait ( {write message, wait for user to hit ENTER}
  in out  ut: utest_t;                 {UTEST library use state}
  in      subsys: string;              {name of subsystem, used to find message file}
  in      msg: string;                 {message name within subsystem file}
  in      parms: univ sys_parm_msg_ar_t; {array of parameter descriptors}
  in      nparms: sys_int_machine_t;   {number of parameters in PARMS}
  in      prmsg: string)               {prompt msg ref, [subsys] name, def "Done> "}
  :boolean;                            {TRUE confirmed normally, FALSE skip}
  val_param; extern;

function utest_user_message_wait (     {write message, wait for user to hit ENTER}
  in out  ut: utest_t;                 {UTEST library use state}
  in      subsys: string;              {name of subsystem, used to find message file}
  in      msg: string;                 {message name within subsystem file}
  in      parms: univ sys_parm_msg_ar_t; {array of parameter descriptors}
  in      nparms: sys_int_machine_t)   {number of parameters in PARMS}
  :boolean;                            {TRUE confirmed normally, FALSE skip}
  val_param; extern;

function utest_user_msg_prmt_wait (    {message, wait for user, default msg file}
  in out  ut: utest_t;                 {UTEST library use state}
  in      msg: string;                 {message name within subsystem file}
  in      prmsg: string)               {prompt msg ref, [subsys] name, def "Done> "}
  :boolean;                            {TRUE confirmed normally, FALSE skip}
  val_param; extern;

function utest_user_msg_wait (         {message, wait for user, default msg file}
  in out  ut: utest_t;                 {UTEST library use state}
  in      msg: string)                 {message name within subsystem file}
  :boolean;                            {TRUE confirmed normally, FALSE skip}
  val_param; extern;

procedure utest_wait (                 {wait a minimum time, performed in programmer}
  in out  ut: utest_t;                 {UTEST library use state}
  in      sec: real);                  {seconds to wait}
  val_param; extern;
{
********************************************************************************
*
*   General utility routines that are independent of the tester.  These do not
*   access a UTEST library use state, and the library does not need to be open.
}
procedure utest_announce (             {write program info to standard output}
  in      dtm: string);                {program build date/time string}
  val_param; extern;

function utest_check_above (           {check for value at or above some level}
  in      name: string;                {name of the value, for message}
  in      val: real;                   {the value to test}
  in      lev: real)                   {minimum valid value}
  :boolean;                            {value is in range}
  val_param; extern;

function utest_check_below (           {check for value at or below some level}
  in      name: string;                {name of the value, for message}
  in      val: real;                   {the value to test}
  in      lev: real)                   {maximum valid value}
  :boolean;                            {value is in range}
  val_param; extern;

function utest_check_bits (            {check that bits are set to specified value}
  in      name: string;                {name of the value, for message}
  in      val: sys_int_conv32_t;       {the bits to check}
  in      ref: sys_int_conv32_t;       {correct bit values}
  in      mask: sys_int_conv32_t)      {mask of used bits in VAL and REF}
  :boolean;                            {all bits correct}
  val_param; extern;

function utest_check_delta (           {check that value is within +-error}
  in      name: string;                {name of the value, for message}
  in      val: real;                   {value to check}
  in      nom: real;                   {nominal value (0% error)}
  in      delta: real)                 {max allowed deviation from nominal}
  :boolean;                            {value is in range}
  val_param; extern;

function utest_check_lim (             {check that value is within specific limits}
  in      name: string;                {name of the value, for message}
  in      val: real;                   {value to check}
  in      limlo: real;                 {minimum allowed value}
  in      limhi: real)                 {maximum allowed value}
  :boolean;                            {value is in range}
  val_param; extern;

function utest_check_percent (         {check that value is within +-percent}
  in      name: string;                {name of the value, for message}
  in      val: real;                   {value to check}
  in      nom: real;                   {nominal value (0% error)}
  in      pcent: real)                 {max allowed percent error from nominal}
  :boolean;                            {value is in range}
  val_param; extern;

function utest_check_true (            {check that a boolean value is TRUE}
  in      name: string;                {description of test, for message}
  in      tf: boolean)                 {value to check, must be TRUE for pass}
  :boolean;                            {value is correct}
  val_param; extern;

procedure utest_fw_init (              {init FW info to unknown}
  out     fw: utest_fw_t);             {firmware info descriptor to initialize}
  val_param; extern;

procedure utest_fw_name (              {make firmware name from type ID}
  in      typ: sys_int_machine_t;      {firmware type ID}
  in out  name: univ string_var_arg_t); {returned name, number string if type not known}
  val_param; extern;

procedure utest_fw_show (              {show information about one firmware}
  in      desc: string;                {short description}
  in      fw: utest_fw_t);             {firmware version info}
  val_param; extern;

function utest_fw_ver (                {check firmware version, show result}
  in      fw: utest_fw_t;              {actual firmware info}
  in      typ: sys_int_machine_t;      {desired type}
  in      ver: sys_int_machine_t)      {desired version}
  :boolean;                            {firmware version is correct}
  val_param; extern;

procedure utest_user_beep;             {beep to alert user to new message}
  val_param; extern;

procedure utest_user_make_prompt (     {make prompt string from msg references}
  in      subsys: string;              {name of subsystem, used to find message file}
  in      prmsg: string;               {prompt msg ref, [subsys] name, def "Done> "}
  in out  prompt: univ string_var_arg_t); {returned prompts string}
  val_param; extern;
{
*   Routines that write messages to the user from a full message reference and
*   parameters.  The messages are specified with SUBSYS, MSG, PARMS, and NPARMS.
}
procedure utest_user_message (         {write separator, message, beep}
  in      subsys: string;              {name of subsystem, used to find message file}
  in      msg: string;                 {message name within subsystem file}
  in      parms: univ sys_parm_msg_ar_t; {array of parameter descriptors}
  in      nparms: sys_int_machine_t);  {number of parameters in PARMS}
  val_param; extern;

procedure utest_user_message_keyw (    {write message, get response keyword}
  in      subsys: string;              {name of subsystem, used to find message file}
  in      msg: string;                 {message name within subsystem file}
  in      parms: univ sys_parm_msg_ar_t; {array of parameter descriptors}
  in      nparms: sys_int_machine_t;   {number of parameters in PARMS}
  in      prmsg: string;               {prompt msg ref, [subsys] name, def "Done> "}
  in      keyws: string;               {keyw choices, blank separate, upper case}
  out     pick: sys_int_machine_t);    {1-N number of chosen keyword}
  val_param; extern;

procedure utest_user_message_resp (    {message, prompt, get response}
  in      subsys: string;              {name of subsystem, used to find message file}
  in      msg: string;                 {message name within subsystem file}
  in      parms: univ sys_parm_msg_ar_t; {array of parameter descriptors}
  in      nparms: sys_int_machine_t;   {number of parameters in PARMS}
  in      prmsg: string;               {prompt msg ref, [subsys] name, def "Done> "}
  in out  resp: univ string_var_arg_t); {returned response from the user}
  val_param; extern;
{
*   Shortcut message routines.  These can be used when the message takes no
*   parameters and the message is from the message file unique to the program.
}
procedure utest_user_msg (             {default message file, no parameters}
  in      msg: string);                {message name within subsystem file}
  val_param; extern;

function utest_user_msg_yes_y (        {message, get yes/no response, default yes}
  in      msg: string)                 {message name within program's msg file}
  :boolean;                            {TRUE for yes, FALSE for no}
  val_param; extern;

function utest_user_msg_yes_n (        {message, get yes/no response, default no}
  in      msg: string)                 {message name within program's msg file}
  :boolean;                            {TRUE for yes, FALSE for no}
  val_param; extern;

function utest_user_msg_yes (          {message, get yes/no response, no default}
  in      msg: string)                 {message name within program's msg file}
  :boolean;                            {TRUE for yes, FALSE for no}
  val_param; extern;

procedure utest_user_prompt_resp (     {write prompt, get response string}
  in      subsys: string;              {name of subsystem, used to find message file}
  in      prmsg: string;               {prompt msg ref, [subsys] name, def "Done> "}
  in out  resp: univ string_var_arg_t); {returned response from the user}
  val_param; extern;

procedure utest_user_prompt_resp_beep ( {prompt, optional beep, get response string}
  in      subsys: string;              {name of subsystem, used to find message file}
  in      prmsg: string;               {prompt msg ref, [subsys] name, def "Done> "}
  in      beep: boolean;               {beep after writing prompt}
  in out  resp: univ string_var_arg_t); {returned response from the user}
  val_param; extern;

function utest_user_prmt_wait (        {prompt user, wait for ENTER}
  in      msg: string;                 {ref to message to display before prompt}
  in      prmsg: string)               {prompt message reference, def "Done> "}
  :boolean;                            {user wants to continue normally, not exit}
  val_param; extern;

function utest_user_wait (             {prompt user with "Done> ", wait until ENTER}
  in      msg: string)                 {ref to message to display before prompt}
  :boolean;                            {user wants to continue normally, not exit}
  val_param; extern;
