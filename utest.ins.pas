{   Public include file for the UTEST library.
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
    end;
{
********************************************************************************
*
*   Entry points.
}
procedure utest_announce;              {write program info to standard output}
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

procedure utest_close (                {end a use of the UTEST library}
  in out  ut: utest_t;                 {UTEST library use state, returned invalid}
  out     stat: sys_err_t);            {completion status}
  val_param; extern;

procedure utest_open (                 {start new use of the UTEST library}
  in      name: univ string_var_arg_t; {name of the USBProg in the tester}
  out     ut: utest_t;                 {returned library use state}
  out     stat: sys_err_t);            {completion status}
  val_param; extern;

procedure utest_prog (                 {program data into a target PIC}
  in out  ut: utest_t;                 {UTEST library use state}
  in      hexdir: string_treename_t;   {directory to look for HEX file in}
  in      fwname: string;              {bare firmware name, no version or path}
  in      ver: sys_int_machine_t;      {required firmware version}
  in      pic: string;                 {PIC model, like "16LF1786", case-insensitive}
  out     stat: sys_err_t);            {completion status}
  val_param; extern;

function utest_ser_get8 (              {get next 8 bit value from receive buffer}
  in out  ut: utest_t)                 {UTEST library use state}
  :sys_int_machine_t;                  {byte value, 0 when not byte available}
  val_param; extern;

function utest_ser_get16 (             {get next 16 bit value from receive buffer}
  in out  ut: utest_t)                 {UTEST library use state}
  :sys_int_machine_t;                  {16 bit value, high to low byte order from buff}
  val_param; extern;

function utest_ser_get24 (             {get next 24 bit value from receive buffer}
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

procedure utest_user_message (         {write separator, message, beep}
  in      subsys: string;              {name of subsystem, used to find message file}
  in      msg: string;                 {message name withing subsystem file}
  in      parms: univ sys_parm_msg_ar_t; {array of parameter descriptors}
  in      nparms: sys_int_machine_t);  {number of parameters in PARMS}
  val_param; extern;

function utest_user_message_wait (     {write message, wait for user to hit ENTER}
  in out  ut: utest_t;                 {UTEST library use state}
  in      subsys: string;              {name of subsystem, used to find message file}
  in      msg: string;                 {message name withing subsystem file}
  in      parms: univ sys_parm_msg_ar_t; {array of parameter descriptors}
  in      nparms: sys_int_machine_t)   {number of parameters in PARMS}
  :boolean;                            {TRUE confirmed normally, FALSE skip}
  val_param; extern;

procedure utest_user_msg (             {default message file, no parameters}
  in      msg: string);                {message name withing subsystem file}
  val_param; extern;

function utest_user_msg_wait (         {message, wait for user, defaulf msg file}
  in out  ut: utest_t;                 {UTEST library use state}
  in      msg: string)                 {message name withing subsystem file}
  :boolean;                            {TRUE confirmed normally, FALSE skip}
  val_param; extern;

procedure utest_wait (                 {wait a minimum time, performed in programmer}
  in out  ut: utest_t;                 {UTEST library use state}
  in      sec: real);                  {seconds to wait}
  val_param; extern;
