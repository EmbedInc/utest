/*   Messages referenced by the UTEST library.
/*
/*   Messages corresponding to completion status codes.
/*
msg err1
  lan english -def
    Multiple programmers found with name "%p1s".
msg err2
  lan english -def
    Programmer with name "%p1s" was not found.
msg err2
  lan english -def
    Received %p2i bytes, %p1i were required.


/*   Messages referenced by name.
/*
msg check_delta_err
  lan english -def
    FAILED: %p1s, must be within %p3f6.2 of %p2f6.2, is off by %p4f6.2
msg check_delta_ok
  lan english -def
    Passed: %p1s, must be within %p3f6.2 of %p2f6.2, is off by %p4f6.2

msg check_lim_err
  lan english -def
    FAILED: %p1s, must be from %p2f6.2 to %p3f6.2, is %p4f6.2
msg check_lim_ok
  lan english -def
    Passed: %p1s, must be from %p2f6.2 to %p3f6.2, is %p4f6.2

msg check_max_err
  lan english -def
    FAILED: %p1s, must be %p2f6.2 maximum, is %p3f6.2
msg check_max_ok
  lan english -def
    Passed: %p1s, must be %p2f6.2 maximum, is %p3f6.2

msg check_min_err
  lan english -def
    FAILED: %p1s, must be %p2f6.2 minimum, is %p3f6.2
msg check_min_ok
  lan english -def
    Passed: %p1s, must be %p2f6.2 minimum, is %p3f6.2

msg check_percent_err
  lan english -def
    FAILED: %p1s, must be within %p3f6.2%% of %p2f6.2, is off by %p4f6.2%%
msg check_percent_ok
  lan english -def
    Passed: %p1s, must be within %p3f6.2%% of %p2f6.2, is off by %p4f6.2%%

msg progged
  lan english -def
    PIC %p1s has been programmed successfully.
msg progging
  lan english -def
    Programming %p1s into PIC %p2s.

msg try2done
  lan english -def
    Gibberish not allowed.  Just hit ENTER when done.
msg try3done
  lan english -def
    It's really not that hard.  Just hit ENTER when done.
msg tryabort
  lan english -def
    Stop playing with the 'puter and go get mommy to take a look.
