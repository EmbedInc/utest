Host code to help implement production testers based around a USBProg
core.

Embed Inc's USBProg PIC programmer architecture allows for a optional
serial port that can be used to control additional hardware beyond the
USBProg itself.  This serial port can be accessed via the standard Embed
Inc programmer protocol, with the SENDSER and RECVSER commands.  See the
PICPROG_PROT documentation file for details.  This port is intended for
connecting to a separate microcontroller that controls hardware unique to
the test application.

The programmer prototol also includes opcodes (240 - 255) that are
specifically reserved for accessing application-specific hardware.  These
are intended for when a larger PIC is used than the normal 18F2550 to
implement the USBProg, such as a 18F4550, for example.  The
application-specific commands can be used to control application-specific
hardware connected to the additional pins not used by the base USBProg
firmware.

The advantge of using a separate processor connected via the optional
serial port is that the USBProg firmware (named EUSB, in the EmbedInc
repositories EUSB and PPROG) does not need to be modified.  It also allows
the tester firmware to run in its own processor, without having to adhere
to limitations imposed by requirements of the EUSB firmware.  The
advantage of using the application-specific commands is that the response
to commands can be faster and more tightly coupled to the command stream.

The UTEST library is layered on the PICPRG library (EmbedInc PICPRG
repository).  UTEST provides a virtual direct connection to the test
processor connected to the USBProg data port.  It also provides facilities
for testers in general that are not necessarily specific to a USBProg
tester.  The facilities in the PICPRG library are available directly for
accessing the application-specific commands of the PICPROG protocol.
