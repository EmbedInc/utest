{   Routines that deal with firmware issues in the unit under test.
}
module utest_fw;
define utest_fw_init;
define utest_fw_name;
define utest_fw_show;
define utest_fw_ver;
%include 'utest2.ins.pas';
{
********************************************************************************
*
*   Subroutine UTEST_FW_INIT (FW)
*
*   Initialize the firmware information descriptor FW to indicate that the
*   firmware information is unknown.
}
procedure utest_fw_init (              {init FW info to unknown}
  out     fw: utest_fw_t);             {firmware info descriptor to initialize}
  val_param;

begin
  fw.typ := 0;
  fw.ver := 0;
  fw.seq := 0;
  end;
{
********************************************************************************
*
*   Subroutine UTEST_FW_NAME (TYP, NAME)
*
*   Create the firmware name from the firmware type ID.  If the type ID is not
*   known, then the name will be just the decimal number of the type ID.
}
procedure utest_fw_name (              {make firmware name from type ID}
  in      typ: sys_int_machine_t;      {firmware type ID}
  in out  name: univ string_var_arg_t); {returned name, number string if type not known}
  val_param;

begin
  case typ of
0: string_vstring (name, 'unknown'(0), -1);
6: string_vstring (name, 'TAURUS'(0), -1);
7: string_vstring (name, 'TTRECV'(0), -1);
8: string_vstring (name, 'TTCOM'(0), -1);
9: string_vstring (name, 'EBHV'(0), -1);
10: string_vstring (name, 'EBCT'(0), -1);
11: string_vstring (name, 'R1LIT'(0), -1);
12: string_vstring (name, 'EMCPS'(0), -1);
13: string_vstring (name, 'COPB'(0), -1);
14: string_vstring (name, 'OCCD'(0), -1);
15: string_vstring (name, 'SHIPM'(0), -1);
16: string_vstring (name, 'HANSIM'(0), -1);
17: string_vstring (name, 'OCCB'(0), -1);
18: string_vstring (name, 'HALLT'(0), -1);
19: string_vstring (name, 'TAGLCD'(0), -1);
20: string_vstring (name, 'VOYAG'(0), -1);
21: string_vstring (name, 'MINIX'(0), -1);
22: string_vstring (name, 'CPAP'(0), -1);
23: string_vstring (name, 'DUMET'(0), -1);
24: string_vstring (name, 'DUMSOL'(0), -1);
25: string_vstring (name, 'DUMCAN'(0), -1);
26: string_vstring (name, 'DUMSND'(0), -1);
27: string_vstring (name, 'BLDC'(0), -1);
28: string_vstring (name, 'DUMOT'(0), -1);
29: string_vstring (name, 'MORBET'(0), -1);
30: string_vstring (name, 'MORB'(0), -1);
31: string_vstring (name, 'MBDCC'(0), -1);
33: string_vstring (name, 'DUMAUD'(0), -1);
34: string_vstring (name, 'DCCPWR'(0), -1);
35: string_vstring (name, 'H2SNODE'(0), -1);
36: string_vstring (name, 'H2SBASE'(0), -1);
37: string_vstring (name, 'CO2PWR'(0), -1);
38: string_vstring (name, 'MENG'(0), -1);
39: string_vstring (name, 'DSNIF'(0), -1);
40: string_vstring (name, 'MB2SOL'(0), -1);
41: string_vstring (name, 'MB2SOLP'(0), -1);
42: string_vstring (name, 'G1S'(0), -1);
43: string_vstring (name, 'PBPTEST'(0), -1);
44: string_vstring (name, 'MB1DIOT'(0), -1);
45: string_vstring (name, 'JDSP'(0), -1);
46: string_vstring (name, 'JMTM'(0), -1);
47: string_vstring (name, 'AGSTP'(0), -1);
48: string_vstring (name, 'AGSTC'(0), -1);
49: string_vstring (name, 'JSER'(0), -1);
50: string_vstring (name, 'MTMT'(0), -1);
51: string_vstring (name, 'CANSER'(0), -1);
52: string_vstring (name, 'AGPAN'(0), -1);
53: string_vstring (name, 'CURRT'(0), -1);
54: string_vstring (name, 'AGCTRL'(0), -1);
55: string_vstring (name, 'SYNVB'(0), -1);
56: string_vstring (name, 'SYNVT'(0), -1);
57: string_vstring (name, 'JCURR'(0), -1);
58: string_vstring (name, 'MMDSP'(0), -1);
59: string_vstring (name, 'MMCOM'(0), -1);
60: string_vstring (name, 'S5CAN'(0), -1);
61: string_vstring (name, 'RELAY'(0), -1);
62: string_vstring (name, 'ISCAN'(0), -1);
63: string_vstring (name, 'S5MAIN'(0), -1);
64: string_vstring (name, 'S5DIG'(0), -1);
65: string_vstring (name, 'USBSER'(0), -1);
66: string_vstring (name, 'G1OGG'(0), -1);
67: string_vstring (name, 'CAPLEV'(0), -1);
68: string_vstring (name, 'HLEAR'(0), -1);
69: string_vstring (name, 'CMUXM'(0), -1);
70: string_vstring (name, 'CMUXI'(0), -1);
71: string_vstring (name, 'DB25'(0), -1);
72: string_vstring (name, 'RESCAL'(0), -1);
otherwise
    string_f_int (name, typ);          {make type ID number string}
    end;
  end;
{
********************************************************************************
*
*   UTEST_FW_SHOW (DESC, FW)
*
*   Show information about one firmware to the user.  DESC is a short
*   description of the firmware.  FW is the version information of that
*   firmware.
}
procedure utest_fw_show (              {show information about one firmware}
  in      desc: string;                {short description}
  in      fw: utest_fw_t);             {firmware version info}
  val_param;

const
  max_msg_args = 4;                    {max arguments we can pass to a message}

var
  msg_parm:                            {references arguments passed to a message}
    array[1..max_msg_args] of sys_parm_msg_t;
  tyname: string_var32_t;              {firmware type name}

begin
  tyname.max := size_char(tyname.str); {init local var string}

  if fw.typ = 0 then begin             {firmware type is not known ?}
    sys_msg_parm_str (msg_parm[1], desc); {description}
    sys_message_parms ('utest', 'fw_show_unk', msg_parm, 1);
    return;
    end;

  utest_fw_name (fw.typ, tyname);      {make firmware type name string}

  sys_msg_parm_str (msg_parm[1], desc); {description}
  sys_msg_parm_vstr (msg_parm[2], tyname); {type name}
  sys_msg_parm_int (msg_parm[3], fw.ver); {version number}
  sys_msg_parm_int (msg_parm[4], fw.seq); {sequence number}

  sys_message_parms ('utest', 'fw_show', msg_parm, 4); {write the message}
  end;
{
********************************************************************************
*
*   Function UTEST_FW_VER (FW, TYP, VER)
*
*   Check that the firmware indicated by FW is of type TYP and version VER.  The
*   function returns TRUE if the firmware is at the indicated version, and FALSE
*   otherwise.  Either way, a message will be written to the user.
}
function utest_fw_ver (                {check firmware version, show result}
  in      fw: utest_fw_t;              {actual firmware info}
  in      typ: sys_int_machine_t;      {desired type}
  in      ver: sys_int_machine_t)      {desired version}
  :boolean;                            {firmware version is correct}
  val_param;

const
  max_msg_args = 3;                    {max arguments we can pass to a message}

var
  name: string_var32_t;                {firmware type name}
  msg_parm:                            {references arguments passed to a message}
    array[1..max_msg_args] of sys_parm_msg_t;

begin
  name.max := size_char(name.str);     {init local var string}
  utest_fw_ver := false;               {init to mismatch}

  utest_fw_name (typ, name);           {make firmware type name}

  sys_msg_parm_vstr (msg_parm[1], name); {FW name, common parameter to all msg}

  if fw.typ <> typ then begin          {firmware is the wrong type ?}
    sys_msg_parm_int (msg_parm[2], fw.typ); {actual firmware type}
    sys_msg_parm_int (msg_parm[3], typ); {desired firmware type}
    sys_message_parms ('utest', 'fw_ver_match_ntyp', msg_parm, 3);
    return;
    end;

  if fw.ver <> ver then begin          {wrong version ?}
    sys_msg_parm_int (msg_parm[2], fw.ver); {actual firmware version}
    sys_msg_parm_int (msg_parm[3], ver); {desired firmware version}
    sys_message_parms ('utest', 'fw_ver_match_nver', msg_parm, 3);
    return;
    end;
{
*  Firmware type and version match.
}
  sys_msg_parm_vstr (msg_parm[1], name); {firmware name}
  sys_message_parms ('utest', 'fw_ver_match', msg_parm, 1);
  utest_fw_ver := true;                {indicate match}
  end;
