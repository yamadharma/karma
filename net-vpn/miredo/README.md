This ebuild uses [my fork](https://gitlab.com/rindeal/miredo) of miredo as a source.

Original miredo has not seen a commit for more than 2 years so I decided to go this way.

The fork includes:

 - unreleased 1.3.0 version
  - original Miredo author began working on it, but hasn't yet released it
 - some patches from Gentoo and other distros
 - improved systemd service files
 - new features:
  - ability to set syslog severity level, because the original version of miredo totally spams journal with its messages
   - this is done via `SyslogSeverityLevel` config entry
