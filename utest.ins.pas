{   Public include file for the UTEST library.
}
type
  utest_t = record                     {data for one use of this library}
    pr: picprg_t;                      {PICPRG library use state}
    end;
{
********************************************************************************
*
*   Entry points.
}
function utest_check_above (           {check for value at or above some level}
  in      name: string;                {name of the value, for error message}
  in      val: real;                   {the value to test}
  in      lev: real)                   {minimum valid value}
  :boolean;                            {value is in range}
  val_param; extern;

function utest_check_below (           {check for value at or below some level}
  in      name: string;                {name of the value, for error message}
  in      val: real;                   {the value to test}
  in      lev: real)                   {maximum valid value}
  :boolean;                            {value is in range}
  val_param; extern;

function utest_check_delta (           {check that value is within +-error}
  in      name: string;                {name of the value, for error message}
  in      val: real;                   {value to check}
  in      nom: real;                   {nominal value (0% error)}
  in      delta: real)                 {max allowed deviation from nominal}
  :boolean;                            {value is in range}
  val_param; extern;

function utest_check_lim (             {check that value is within specific limits}
  in      name: string;                {name of the value, for error message}
  in      val: real;                   {value to check}
  in      limlo: real;                 {minimum allowed value}
  in      limhi: real)                 {maximum allowed value}
  :boolean;                            {value is in range}
  val_param; extern;

function utest_check_percent (         {check that value is within +-percent}
  in      name: string;                {name of the value, for error message}
  in      val: real;                   {value to check}
  in      nom: real;                   {nominal value (0% error)}
  in      pcent: real)                 {max allowed percent error from nominal}
  :boolean;                            {value is in range}
  val_param; extern;

procedure utest_prog (                 {program data into a target PIC}
  in out  ut: utest_t;                 {UTEST library use state}
  in      hexdir: string_treename_t;   {directory to look for HEX file in}
  in      fwname: string;              {bare firmware name, no version or path}
  in      ver: sys_int_machine_t;      {required firmware version}
  in      pic: string;                 {PIC model, like "16LF1786", case-insensitive}
  out     stat: sys_err_t);            {completion status}
  val_param; extern;
