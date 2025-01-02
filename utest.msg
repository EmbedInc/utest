/*   Messages referenced by the UTEST library.
/*
/*   Messages corresponding to completion status codes.
/*
msg err1
  lan english -def
    Multiple testers or programmers found with name "%p1s".
msg err2
  lan english -def
    Tester with name "%p1s" was not found.
msg err3
  lan english -def
    Received %p2i bytes, %p1i were required.
/*
/*   Messages referenced by name.
/*
msg check_bits_err
  lan english -def
    FAILED: %p1s are %p2s, expected %p3s
msg check_bits_ok
  lan english -def
    Passed: %p1s are %p2s

msg check_delta_err
  lan english -def
    FAILED: %p1s, must be within %p3f9.2 of %p2f9.2, is off by %p4f9.2
msg check_delta_ok
  lan english -def
    Passed: %p1s, must be within %p3f9.2 of %p2f9.2, is off by %p4f9.2

msg check_lim_err
  lan english -def
    FAILED: %p1s, must be from %p2f9.2 to %p3f9.2, is %p4f9.2
msg check_lim_ok
  lan english -def
    Passed: %p1s, must be from %p2f9.2 to %p3f9.2, is %p4f9.2

msg check_max_err
  lan english -def
    FAILED: %p1s, must be %p2f9.2 maximum, is %p3f9.2
msg check_max_ok
  lan english -def
    Passed: %p1s, must be %p2f9.2 maximum, is %p3f9.2

msg check_min_err
  lan english -def
    FAILED: %p1s, must be %p2f9.2 minimum, is %p3f9.2
msg check_min_ok
  lan english -def
    Passed: %p1s, must be %p2f9.2 minimum, is %p3f9.2

msg check_percent_err
  lan english -def
    FAILED: %p1s, must be within %p3f9.2%% of %p2f9.2, is off by %p4f9.2%%
msg check_percent_ok
  lan english -def
    Passed: %p1s, must be within %p3f9.2%% of %p2f9.2, is off by %p4f9.2%%

msg check_tf_err
  lan english -def
    FAILED: %p1s
msg check_tf_ok
  lan english -def
    Passed: %p1s

msg datetime
  lan english -def
    Program %p1s, built on %p2s.

msg fw_vers_bad
  lan english -def
    Not all firmware is at the correct version.  Programming is required.
msg fw_vers_good
  lan english -def
    All firmware is at the correct version.
msg fw_ver_match
  lan english -def
    Firmware %p1s is at the correct version.
msg fw_ver_match_ntyp
  lan english -def
    Firmware %p1s is type %p2i, should be %p3i.
msg fw_ver_match_nver
  lan english -def
    Firmware %p1s is at version %p2i, should be version %p3i.
msg fw_show
  lan english -def
    %p1s firmware is %p2s ver %p3i seq %p4i.
msg fw_show_unk
  lan english -def
    Firmware unknown (%p1s)

msg nskipped
  lan english -def
    %p1i operations were skipped.

msg pass_no
  lan english -def
    The unit does NOT PASS the production test.
msg pass_yes
  lan english -def
    .nfill
    ******************************
    *  Production tests passed.  *
    ******************************
msg progged
  lan english -def
    PIC %p1s has been programmed successfully.
msg progged_retry
  lan english -def
    *** Programming failed.  Try again ***
msg progging
  lan english -def
    Programming %p1s into PIC %p2s.

msg prompt_cont
  lan english -def
    Continue>
msg prompt_proc
  lan english -def
    Proceed>
msg prompt_yesno
  lan english -def
    Y or N>
msg prompt_yesno_y
  lan english -def
    Y or N (def Y)>
msg prompt_yesno_n
  lan english -def
    Y or N (def N)>

msg try2done
  lan english -def
    Gibberish not allowed.  Try again.
msg try3done
  lan english -def
    It's really not that hard.  Try again.
msg tryabort
  lan english -def
    Stop playing with the 'puter and go get mommy to take a look.
