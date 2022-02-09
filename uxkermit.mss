@Part(UXKERMIT,root="KER:KUSER")
@string{-UXversion="@q<3.0(0)>"}
@Chapter<UNIX KERMIT>
@Begin<Description,Leftmargin +12,Indent -12,spread 0>
@i(Authors:)@\Bill Catchings, Bob Cattani, Chris Maio, Columbia University@*
with fixes and contributions from many others.

@i(Documentation:)@\Walter Underwood, Ford Aerospace (Palo Alto, CA)

@i(Version:)@\@value(-UXversion)

@i(Date: )@\August 1984
@end<Description>

@label<-kc>
A sample, working implementation of the Kermit "kernel" was written in the
C language, and widely distributed in the @i<Kermit Protocol Manual>.  This
kernel was intended merely to
illustrate the protocol, and did not include a "user interface", nor some of
the fancy features like server support, 8-bit quoting, file warning, timeouts,
etc.  Several sites have added the necessary trappings to make this a
production version of Kermit, usually under the UNIX operating system.

The keyword style of user/program interaction favored by Kermit (program types
prompt, user types command followed by operands, program types another prompt,
etc) is contrary to the UNIX style, so UNIX implementations have a style more
familiar to UNIX users.  C versions of Kermit are running successfully on
VAX and PDP-11 UNIX systems, IBM 370-@|compatible mainframes under Amdahl UTS,
and the SUN Microsystems MC68000-@|based and other workstations.

UNIX filespecs are of the form
@example<dir1/dir2/dir3/ ... /filename>
where the tokens delimited by slashes form a @i<path name>, and by convention
are each limited to 14 characters in length.  The final token in a path is the
actual file name.  By convention, it is of the form @q<name.type>, but there is
nothing special about the dot separating name and type;
to UNIX it's just another character, and there may be many dots in a filename.

In the tradition of UNIX, here's the UNIX KERMIT "man page".

@begin<description>
NAME@\kermit - file transfer, virtual terminal over tty link

SYNOPSIS@\kermit c[lbphe] [line] [baud] [par] [esc]

@\kermit r[ddilbpt] [line] [baud] [par]

@\kermit s[ddilbpt] [line] [baud] [par] file ...

DESCRIPTION@\@begin<multiple>Kermit provides reliable file transfer and
primitive virtual terminal communication between machines.  It has been
implemented on many different computers.  The files transferred may be
arbitrary ASCII data (7-bit characters) and may be of any length.  Binary
(8-bit) files may also be transferred under most conditions.  The file transfer
protocol uses small (96 character) checksummed packets, with ACK/NACK responses
and timeouts.  Kermit currently uses a five second timeout and ten retries.

The Unix Kermit command line is in the style of TAR.
The arguments are a set of flags (no spaces
between the flags), three optional args (which, if included,
must be in the same order as the flags which indicate their
presence), and, if this is a Send operation a list of one or
more files.

Kermit has three modes, Connect, Send, and Receive.  The
first is for a virtual terminal connection, the other two
for file transfer.  These modes are specified by the first
flag, which should be c, s, or r, respectively.  Exactly one
mode must be specified.

The d flag (debug) makes kermit a bit more verbose.  The
states kermit goes through are printed along with other
traces of its operation.  A second d flag will cause kermit
to give an even more detailed trace.

The i flag (image) allows slightly more efficient file
transfer between Unix machines.  Normally (on Kermits
defined to run on Unix systems) newline is mapped to CRLF on
output, CR's are discarded on input, and bytes are masked to
7 bits.  If this is set, no mapping is done on newlines, and
all eight bits of each byte are sent or received.  This is
the default for all kermits.

The l flag (line) specifies the tty line that kermit should use to communicate
with the other machine.  This is specified as a regular filename, like
"/dev/ttyh1".  If no l option is specified, standard input is used and kermit
assumes it is running on the remote host (ie. NOT the machine to which your
terminal is attached).

The b flag (baud) sets the baud rate on the line specified
by the l flag.  No changes are made if the b flag is not
used.  Legal speeds are: 110, 150, 300, 1200, 1800, 2400, 4800,
9600.  Note that this version of kermit supports this option
on Unix systems only.

The e flag (escape) allows the user to set the first character of the two
character escape sequence for Connect mode.  When the escape character is
typed, kermit will hold it and wait for the next character.  If the next
character is c or C, kermit will close the connection with the remote host.  If
the second character is the same as the escape character, the escape character
itself is passed.  Any character other than these two results in a bell being
sent to the user's terminal and no characters passwd to the remote host.  All
other typed characters are passed through unchanged.  The default escape
character is '^'.

The p flag (parity) allows parity to be set on outgoing packets and
stripped on incoming ones.  This is useful for communicating with IBM
hosts or over networks, such as TELENET, that usurp the parity bit.
The possible values for parity are mark, space, even, odd or none (the
default). 

The t flag (turnaround) tells Kermit while in protocol mode (sending
or receiving) to wait for a turnaround character (XON) from the other
host after receiving every packet.  This is necessary to run Kermit
with a half duplex host such as an IBM mainframe.

The h flag (half duplex) makes Kermit echo locally any characters
typed in connect mode.  This is also necessary to communicate with a
half duplex system like an IBM 370.

The file arguments are only meaningful to a Send kermit.
The Receiving kermit will attempt to store the file with the
same name that was used to send it.  Unix kermits normally
convert outgoing file names to uppercase and incoming ones
to lower case (see the f flag).  If a filename contains a
slash (/) kermit will strip off the leading
part of the name through the last slash.
 @end<multiple>

EXAMPLE@\@begin<multiple>For this example we will assume two Unix machines.  We
are logged onto "unixa" (the local machine), and want to communicate with
"unixb" (the remote machine).  There is a modem on "/dev/tty03".

We want to connect to "unixb", then transfer "file1" to that
machine.

We type:
@example<kermit clb /dev/tty03 1200>

Kermit answers:
@example<Kermit: connected...>

Now we dial the remote machine and connect the modem.  Anything typed on the
terminal will be sent to the remote machine and any output from that machine
will be displayed on our terminal.  We hit RETURN, get a "login:" prompt and
login.

Now we need to start a kermit on the remote machine so that
we can send the file over.  First we start up the remote,
(in this case receiving) kermit, then the local, (sending)
one.  Remember that we are talking to unixb right now.

We type:
@example(kermit r)
(there is now a Receive kermit on unixb)

We type @q<^> (the escape character) and then the letter c to kill the
local (Connecting) kermit:
@q<^C>

Kermit answers:
@example<Kermit: disconnected.>

We type:
@example<kermit slb /dev/tty03 1200 file1>

Kermit answers:
@example<Sending file1 as FILE1>

When the transmission is finished, kermit will type either
"Send complete", or "Send failed.", depending on the success
of the transfer.  If we now wanted to transfer a file from
unixb (remote) to unixa (local), we would use these commands:

@begin<example>
kermit clb /dev/tty03 1200
  @i<(connected to unixb)>
kermit s file9
  ^c @i<(up-arrow c not control-c)>
     @i<(talking to unixa again)>
kermit rl /dev/tty03 1200
@end<example>
After all the transfers were done, we should connect again,
log off of unixb, kill the Connect kermit and hang up the
phone.
@end<multiple>

FEATURES@\Kermit can interact strangely with the tty driver.  In particular, a
tty with "hangup on last close" set (stty hup), will reset to 300 Baud between
kermit commands.  It will also hang up a modem at that time.  It is better to
run with "stty -hup", and use "stty 0" to explicitly hang up the modem.

@\The KERMIT Protocol uses only printing ASCII characters, Ctrl-A, and CRLF.
Ctrl-S/Ctrl-Q flow control can be used "underneath" the Kermit protocol (TANDEM
line discipline on Berkeley Unix).

@\Since BREAK is not an ASCII character, kermit cannot send a BREAK to the
remote machine.  On some systems, a BREAK will be read as a NUL.

@\This kermit does have timeouts when run under Unix, so the protocol is stable
when communicating with "dumb" kermits (that don't have timeouts).

DIAGNOSTICS@\@begin<multiple>@i<cannot open device>@*
          The file named in the line argument did not exist or
          had the wrong permissions.

     @i<bad line speed>@*
          The baud argument was not a legal speed.

     @i<Could not create file>@*
          A Receive kermit could not create the file being sent
          to it.

     @i<nothing to connect to>@*
          A Connect kermit was started without a line argument.
@end<multiple>
@end<description>
