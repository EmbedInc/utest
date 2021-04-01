{   Routines that deal with firmware issues in the unit under test.
}
module utest_fw;
define utest_fw_name;
define utest_fw_show;
define utest_fw_ver;
%include 'utest2.ins.pas';
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
43: string_vstring (name, 'PBPTEST'(0), -1);
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
