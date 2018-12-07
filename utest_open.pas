{   Routines to start and end uses of the UTEST library.
}
module utest_open;
define utest_open;
%include 'utest2.ins.pas';
{
********************************************************************************
*
*   Subroutine UTEST_OPEN (NAME, UT, STAT)
*
*   Start a new use of the UTEST library and connect to the tester.  The tester
*   is a Embed USBProg.  It may have additional hardware connected to it via the
*   serial data port of the USBProg.  It may also have additional capabilities
*   added to the USBProg processor.
*
*   NAME is the name that the USBProg of the tester must report.  There must be
*   exactly one Embed PIC programmer of that name available to this machine.
*
*   On success, UT is returned the new UTEST library use state, and STAT
*   reports no error.  On failure, STAT will indicate error, and the state of
*   UT is indefined, except that no system resources will be allocated to it.
}
procedure utest_open (                 {open new use of the UTEST library}
  in      name: univ string_var_arg_t; {name of the USBProg in the tester}
  out     ut: utest_t;                 {returned library use state}
  out     stat: sys_err_t);            {completion status}
  val_param;

var
  devs: picprg_devs_t;                 {list of available PIC programmer devices}
  dev_p: picprg_dev_p_t;               {points to current PIC programmers list entry}
  tester_p: picprg_dev_p_t;            {points to tester device in list}
  devs_open: boolean;                  {DEVS list is allocated}

label
  leave;

begin
  devs_open := false;                  {init to programmer devices list not allocated}
{
*   Find the tester PIC programmer device.  TESTER_P will be pointing to the
*   device in the PIC programmer devices list.
}
  picprg_list_get (util_top_mem_context, devs); {get list of PIC programmers}
  devs_open := true;                   {remember that the list is allocated}

  tester_p := nil;                     {init to tester not found}
  dev_p := devs.list_p;                {init to first list entry}
  while dev_p <> nil do begin          {scan the list}
    if string_equal(dev_p^.name, name) then begin {found device with right name ?}
      if tester_p <> nil then begin    {previously found another one ?}
        sys_stat_set (utest_subsys_k, utest_stat_dupname_k, stat);
        sys_stat_parm_vstr (name, stat);
        goto leave;
        end;
      tester_p := dev_p;               {save pointer to tester device}
      end;
    dev_p := dev_p^.next_p;            {advance to next list entry}
    end;
  if tester_p = nil then begin         {no such programmer found ?}
    sys_stat_set (utest_subsys_k, utest_stat_prog_nfnd_k, stat);
    sys_stat_parm_vstr (name, stat);
    goto leave;
    end;
{
*   Open a connection to the tester.  TESTER_P is pointing to the tester device
*   in the PIC programmer devices list.
}
  picprg_init (ut.pr);                 {init the PICPRG library use state}

  ut.pr.devconn := picprg_devconn_enum_k; {indicate to open enumerable device}
  string_copy (tester_p^.name, ut.pr.prgname); {set name of device to open}
  picprg_list_del (devs);              {delete the list of known PIC programmers}
  devs_open := false;                  {indicate devices list no longer allocated}

  picprg_open (ut.pr, stat);           {open connection to the specified programmer}
  if sys_error(stat) then goto leave;
{
*   Initialize the rest of the UTEST library use state.
}
  ut.ibufn := 0;                       {init serial data input buffer to empty}
  ut.ibufrd := 0;
  ut.obufn := 0;                       {init serial data output buffer to empty}
{
*   Initialize the tester.
}
  utest_ser_recv_flush (ut, stat);     {flush any previously received serial data}

leave:                                 {common exit point, STAT all set}
  if devs_open then begin
    picprg_list_del (devs);            {deallocate programmer devices list}
    end;
  end;
