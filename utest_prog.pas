{   Routines for programming PICs.
}
module utest_prog;
define utest_prog;
%include 'utest2.ins.pas';
{
********************************************************************************
*
*   Subroutine UTEST_PROG (UT, HEXDIR, FWNAME, VER, PIC, STAT)
*
*   Program the data from a HEX file into one PIC.
*
*   FWNAME is the generic name of the HEX file within the HEXDIR directory.  VER
*   VER is the version number of the firmware.  If available, the HEX file of
*   the specific version will be used.  For example, with HEXDIR c:/stuff/hex,
*   FWNAME "abcd", and VER 27, the HEX file "c:/stuff/hex/abcd27.hex" will be
*   used if found.  If not, the HEX file without a version number will be used.
*   That would be "c:/stuff/hex/abcd.hex" in this example.
*
*   PIC is the PIC model name, like "16F877" or "33EP512GM604".  This string is
*   case-insensitive.  It is a error if the PIC model can be reliably
*   determined, and it does not match what is specified in PIC.
}
procedure utest_prog (                 {program data into a target PIC}
  in out  ut: utest_t;                 {UTEST library use state}
  in      hexdir: string_treename_t;   {directory to look for HEX file in}
  in      fwname: string;              {bare firmware name, no version or path}
  in      ver: sys_int_machine_t;      {required firmware version}
  in      pic: string;                 {PIC model, like "16LF1786", case-insensitive}
  out     stat: sys_err_t);            {completion status}
  val_param;

const
  max_msg_args = 2;                    {max arguments we can pass to a message}

var
  picv: string_var32_t;                {var string PIC model name, upper case}
  fnam: string_treename_t;             {name of HEX file to open}
  tk: string_var32_t;                  {scratch token}
  ii: sys_int_machine_t;               {scratch integer}
  ihn: ihex_in_t;                      {HEX file reading state}
  tdat_p: picprg_tdat_p_t;             {points to data for programming target PIC}
  hex_open: boolean;                   {the HEX file is open}
  msg_parm:                            {references arguments passed to a message}
    array[1..max_msg_args] of sys_parm_msg_t;
  stat2: sys_err_t;                    {to avoid corrupting STAT}

label
  abort;

begin
  picv.max := size_char(picv.str);     {init local var string}
  fnam.max := size_char(fnam.str);
  tk.max := size_char(tk.str);

  hex_open := false;                   {init to HEX file not open}
  tdat_p := nil;                       {init to TDAT structure not allocated}

  string_vstring (picv, pic, size_char(pic)); {make var string PIC name}
  string_upcase (picv);                {upper case}
  picprg_config (ut.pr, picv, stat);   {configure to the selected PIC}
  if sys_error(stat) then goto abort;

  ii := 2;                             {init number of version digits to create}
  if ver >= 100 then ii := 0;          {more than 2 digits, use as many as needed}
  string_f_int_max_base (              {make version number string}
    tk,                                {output string}
    ver,                               {input integer}
    10,                                {radix}
    ii,                                {output string field width}
    [ string_fi_leadz_k,               {fill field with leading zeros}
      string_fi_unsig_k],              {the input integer is unsigned}
    stat);
  if sys_error(stat) then return;

  string_copy (hexdir, fnam);          {init hex file pathname with directory name}
  string_append1 (fnam, '/');          {add separator before leaf name}
  string_appends (fnam, fwname);       {make generic HEX file name}
  ii := fnam.len;                      {save length to just before version number}
  string_append (fnam, tk);            {add version number string}
  ihex_in_open_fnam (fnam, '.hex', ihn, stat); {try to open HEX file with version}
  if file_not_found(stat) then begin   {version HEX file doesn't exist}
    fnam.len := ii;                    {make HEX file name without version number}
    ihex_in_open_fnam (fnam, '.hex', ihn, stat2); {try to open HEX file without version}
    if file_not_found(stat) then return; {return with original not found error}
    stat := stat2;                     {return with error opening non-version file}
    end;
  if sys_error(stat) then return;
  hex_open := true;                    {indicate HEX file is now open}

  string_generic_fnam (ihn.conn_p^.tnam, '', fnam); {make actual HEX file name}
  string_upcase (fnam);
  sys_msg_parm_vstr (msg_parm[1], fnam);
  sys_msg_parm_vstr (msg_parm[2], picv);
  sys_message_parms ('utest', 'progging', msg_parm, 2);
  writeln;

  picprg_tdat_alloc (ut.pr, tdat_p, stat); {allocate target data block}
  if sys_error(stat) then goto abort;
  picprg_tdat_hex_read (tdat_p^, ihn, stat); {read the data from the HEX file}
  if sys_error(stat) then goto abort;
  ihex_in_close (ihn, stat);           {close the HEX file}
  if sys_error(stat) then goto abort;
  hex_open := false;                   {HEX file no longer open}

  picprg_tdat_prog (                   {program the data into the target}
    tdat_p^,                           {info about what to program}
    [ picprg_progflag_stdout_k,        {show progress to standard output}
      picprg_progflag_verhex_k],       {only verify addresses set in HEX file}
    stat);
  if sys_error(stat) then goto abort;
  picprg_tdat_dealloc (tdat_p);        {deallocate TDAT structure}
  picprg_off (ut.pr, stat);            {turn off programming lines}
  if sys_error(stat) then goto abort;

  writeln;
  sys_msg_parm_vstr (msg_parm[1], picv); {show success}
  sys_message_parms ('utest', 'progged', msg_parm, 1);
  return;                              {normal return point}

abort:                                 {HEX file may be open, STAT all set}
  if hex_open then begin
    ihex_in_close (ihn, stat2);        {close the HEX file}
    end;
  if tdat_p <> nil then begin
    picprg_tdat_dealloc (tdat_p);      {deallocate TDAT structure}
    end;
  picprg_off (ut.pr, stat2);           {turn off programming lines}
  end;
