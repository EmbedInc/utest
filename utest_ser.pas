{   Routines for sending and receiving data over the serial data port of the
*   programmer.
}
module utest_ser;
define utest_ser_send;
define utest_ser_send8;
define utest_ser_send8s;
define utest_ser_send16;
define utest_ser_send16s;
define utest_ser_send24;
define utest_ser_send24s;
define utest_ser_send32;
define utest_ser_recv;
define utest_ser_recv_flush;
define utest_ser_nrecv;
define utest_ser_get8;
define utest_ser_get8s;
define utest_ser_get16;
define utest_ser_get16s;
define utest_ser_get24;
define utest_ser_get24s;
define utest_ser_get32;
%include 'utest2.ins.pas';
{
********************************************************************************
*
*   Subroutine UTEST_SER_SEND (UT, STAT)
*
*   Send any buffered serial data port output data.  The output buffer is
*   guaranteed to be empty after this call.  Nothing is done if the buffer is
*   already empty.
}
procedure utest_ser_send (             {send all buffered serial data}
  in out  ut: utest_t;                 {UTEST library use state}
  out     stat: sys_err_t);            {completion status}
  val_param;

begin
  sys_error_none (stat);               {init to no error}
  if ut.obufn <= 0 then return;        {buffer is already empty ?}

  picprg_cmdw_sendser (                {send bytes out the serial data port}
    ut.pr,                             {PICPRG library use state}
    ut.obufn,                          {number of bytes to send}
    ut.obuf,                           {the data bytes}
    stat);

  ut.obufn := 0;                       {reset the output buffer to empty}
  end;
{
********************************************************************************
*
*   Subroutine UTEST_SER_SEND8 (UT, D, STAT)
*
*   Send the byte in the low bits of D out the serial data port of the
*   programmer.
*
*   The byte is buffered to the extent possible.  Data is only physically sent
*   if the output buffer is already full on attempt to store another byte.  In
*   that case, the existing buffer contents is sent, and the new byte will be
*   the only byte in the output buffer.
}
procedure utest_ser_send8 (            {send 8 bits serial, buffer as much as possible}
  in out  ut: utest_t;                 {UTEST library use state}
  in      d: sys_int_conv8_t;          {data in low bits}
  out     stat: sys_err_t);            {completion status}
  val_param;

begin
  sys_error_none (stat);               {init to no error}

  if ut.obufn >= utest_obuf_size then begin {output buffer is full ?}
    utest_ser_send (ut, stat);         {send and empty the buffer}
    if sys_error(stat) then return;
    end;

  ut.obuf[ut.obufn] := d & 16#FF;      {write the byte into the buffer}
  ut.obufn := ut.obufn + 1;            {log one more byte in the buffer}
  end;
{
********************************************************************************
*
*   Subroutines for sending various multi-byte words over the serial data port.
*   Bytes are sent in most to least significant order.  All these routines are
*   layered on UTEST_SER_SEND8, above.
*
********************
}
procedure utest_ser_send16 (           {send 16 bits serial, buffer as much as possible}
  in out  ut: utest_t;                 {UTEST library use state}
  in      d: sys_int_conv16_t;         {data in low bits, high to low byte order}
  out     stat: sys_err_t);            {completion status}
  val_param;

begin
  utest_ser_send8 (ut, rshft(d, 8), stat);
  if sys_error(stat) then return;
  utest_ser_send8 (ut, d, stat);
  end;
{
********************
}
procedure utest_ser_send24 (           {send 24 bits serial, buffer as much as possible}
  in out  ut: utest_t;                 {UTEST library use state}
  in      d: sys_int_conv24_t;         {data in low bits, high to low byte order}
  out     stat: sys_err_t);            {completion status}
  val_param;

begin
  utest_ser_send8 (ut, rshft(d, 16), stat);
  if sys_error(stat) then return;
  utest_ser_send8 (ut, rshft(d, 8), stat);
  if sys_error(stat) then return;
  utest_ser_send8 (ut, d, stat);
  end;
{
********************
}
procedure utest_ser_send32 (           {send 32 bits serial, buffer as much as possible}
  in out  ut: utest_t;                 {UTEST library use state}
  in      d: sys_int_conv32_t;         {data in low bits, high to low byte order}
  out     stat: sys_err_t);            {completion status}
  val_param;

begin
  utest_ser_send8 (ut, rshft(d, 24), stat);
  if sys_error(stat) then return;
  utest_ser_send8 (ut, rshft(d, 16), stat);
  if sys_error(stat) then return;
  utest_ser_send8 (ut, rshft(d, 8), stat);
  if sys_error(stat) then return;
  utest_ser_send8 (ut, d, stat);
  end;
{
********************************************************************************
*
*   Subroutine UTEST_SER_RECV (UT, WAIT, N, STAT)
*
*   Wait at least WAIT seconds, then get any bytes received by the programmer
*   on its serial data port.  When N is non-zero, there must be exactly N bytes
*   received.  When N is 0, then any number of bytes (including 0) is valid.
*
*   The local serial data port input buffer is reset to empty before any bytes
*   are received.  Any bytes in the input buffer when this routine is called are
*   lost.  Note that UTEST_SER_NRECV can be used at any time to get the number
*   of bytes in the input buffer.
}
procedure utest_ser_recv (             {receive serial data into internal buffer}
  in out  ut: utest_t;                 {UTEST library use state}
  in      wait: real;                  {seconds to wait before attempting read}
  in      n: sys_int_machine_t;        {required number of bytes, 0 = any number}
  out     stat: sys_err_t);            {completion status}
  val_param;

begin
  if wait > 0.0 then begin
    utest_wait (ut, wait);             {do the wait}
    end;

  picprg_cmdw_recvser (                {get any received serial data port bytes}
    ut.pr,                             {PICPRG library use state}
    ut.ibufn,                          {number of bytes returned}
    ut.ibuf,                           {the data bytes}
    stat);
  ut.ibufrd := 0;                      {init index of next byte to read}
  if sys_error(stat) then return;

  if n = 0 then return;                {any number of bytes is allowed ?}
  if ut.ibufn <> n then begin          {didn't get the required number of bytes ?}
    sys_stat_set (utest_subsys_k, utest_stat_notnbytes_k, stat);
    sys_stat_parm_int (n, stat);
    sys_stat_parm_int (ut.ibufn, stat);
    end;
  end;
{
********************************************************************************
*
*   Subroutine UTEST_SER_RECV_FLUSH (UT, STAT)
*
*   Get and discard all bytes received over the serial data port.  The input
*   buffer will be empty after this call.
}
procedure utest_ser_recv_flush (       {read and discard serial bytes until no more}
  in out  ut: utest_t;                 {UTEST library use state}
  out     stat: sys_err_t);            {completion status}
  val_param;

begin
  repeat
    utest_ser_recv (ut, 0.010, 0, stat); {try to read some bytes}
    if sys_error(stat) then return;
    until ut.ibufn = 0;                {do it again if got any bytes}
  end;
{
********************************************************************************
*
*   Function UTEST_SER_NRECV (UT)
*
*   Return the number of unread bytes currently in the serial data port input
*   buffer.
}
function utest_ser_nrecv (             {get number of unread bytes in receive buffer}
  in out  ut: utest_t)                 {UTEST library use state}
  :sys_int_machine_t;                  {number of remaining unread bytes}
  val_param;

begin
  utest_ser_nrecv := ut.ibufn - ut.ibufrd;
  end;
{
********************************************************************************
*
*   Function UTEST_SER_GET8 (UT)
*
*   Get the next byte from the serial data port input buffer.  If no byte is
*   available, 0 is returned.
}
function utest_ser_get8 (              {get next 8 bit value from receive buffer}
  in out  ut: utest_t)                 {UTEST library use state}
  :sys_int_machine_t;                  {byte value, 0 when not byte available}
  val_param;

begin
  if ut.ibufrd < ut.ibufn
    then begin                         {a byte is available}
      utest_ser_get8 := ut.ibuf[ut.ibufrd]; {get the byte}
      ut.ibufrd := ut.ibufrd + 1;      {update the read index for next time}
      end
    else begin                         {there is no unread byte in the input buffer}
      utest_ser_get8 := 0;
      end
    ;
  end;
{
********************
}
function utest_ser_get8s (             {get next 8 bit signed value from receive buffer}
  in out  ut: utest_t)                 {UTEST library use state}
  :sys_int_machine_t;                  {byte value, 0 when not byte available}
  val_param;

var
  ii: sys_int_machine_t;

begin
  ii := utest_ser_get8 (ut);
  if ii >= 16#80 then ii := ii - 16#100;
  utest_ser_get8s := ii;
  end;
{
********************************************************************************
*
*   Functions for getting various multi-byte values over the serial data port.
*   Multi-byte value are assumed to be sent in most to least significant byte
*   order.  All these routine are layered on UTEST_SER_GET8.
*
********************
}
function utest_ser_get16 (             {get next 16 bit value from receive buffer}
  in out  ut: utest_t)                 {UTEST library use state}
  :sys_int_machine_t;                  {16 bit value, high to low byte order from buff}
  val_param;

var
  ii: sys_int_machine_t;

begin
  ii := utest_ser_get8 (ut);
  ii := lshft(ii, 8) ! utest_ser_get8 (ut);
  utest_ser_get16 := ii;
  end;
{
********************
}
function utest_ser_get16s (            {get next 16 bit signed value from receive buffer}
  in out  ut: utest_t)                 {UTEST library use state}
  :sys_int_machine_t;                  {16 bit value, high to low byte order from buff}
  val_param;

var
  ii: sys_int_machine_t;

begin
  ii := utest_ser_get16 (ut);
  if ii >= 16#8000 then ii := ii - 16#10000;
  utest_ser_get16s := ii;
  end;
{
********************
}
function utest_ser_get24 (             {get next 24 bit value from receive buffer}
  in out  ut: utest_t)                 {UTEST library use state}
  :sys_int_machine_t;                  {24 bit value, high to low byte order from buff}
  val_param;

var
  ii: sys_int_machine_t;

begin
  ii := utest_ser_get8 (ut);
  ii := lshft(ii, 8) ! utest_ser_get8 (ut);
  ii := lshft(ii, 8) ! utest_ser_get8 (ut);
  utest_ser_get24 := ii;
  end;
{
********************
}
function utest_ser_get24s (            {get next 24 bit signed value from receive buffer}
  in out  ut: utest_t)                 {UTEST library use state}
  :sys_int_machine_t;                  {24 bit value, high to low byte order from buff}
  val_param;

var
  ii: sys_int_machine_t;

begin
  ii := utest_ser_get24 (ut);
  if ii >= 16#800000 then ii := ii - 16#1000000;
  utest_ser_get24s := ii;
  end;
{
********************
}
function utest_ser_get32 (             {get next 32 bit value from receive buffer}
  in out  ut: utest_t)                 {UTEST library use state}
  :sys_int_machine_t;                  {32 bit value, high to low byte order from buff}
  val_param;

var
  ii: sys_int_machine_t;

begin
  ii := utest_ser_get8 (ut);
  ii := lshft(ii, 8) ! utest_ser_get8 (ut);
  ii := lshft(ii, 8) ! utest_ser_get8 (ut);
  ii := lshft(ii, 8) ! utest_ser_get8 (ut);
  utest_ser_get32 := ii;
  end;
