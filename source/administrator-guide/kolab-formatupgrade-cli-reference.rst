=============================================
:command:`kolab-formatupgrade` Command-Line Reference
=============================================

The :command:`kolab-formatupgrade` command allows one to upgrade kolab objects from format version 2 to version 3.
It additionaly provides utilites to detect and fix defective kolab objects.

.. parsed-literal::

[root@kolab ~]# kolab-formatupgrade --help
Usage: kolab-formatupgrade [options] [server/file]

Options:
  --mime                    Read mime from stdin or file
  -u, --user <loginname>    Username for IMAP Account
  -y, --proxyauth <loginname> Username to be used for authentication together with password (optional, works with PLAIN/SASL authentication)
  -p, --password <password> Password for IMAP Account
  -P, --port <port>         Port to be used on IMAP Server [143]
  -e, --encrypt <mode>      Encryption mode to be used (NONE, TLS, SSL) [TLS]
  -f, --folder <folder>     Upgrade only the specified folder
  -t, --type <type>         force the type (EVENT, TODO, JOURNAL, CONTACT). Applies only when upgrading a single file or a specific folder.
  -a, --auth <mode>         Authentication mode to be used (PLAIN, LOGIN, CRAMMD5, DIGESTMD5, NTLM, GSSAPI, ANONYMOUS, CLEARTEXT) [PLAIN]
  --fix-utc-incidences      Converts all incidences from UTC to floating time.
  --fix-utc-incidences-offset <offset> Uses a UTC offset to convert the times. If not provided the local timezone get's used instead. The offset is in seconds. [0]
  --fix-utc-incidences-timezone <timezone> Uses the specified timezone to convert the times. If not provided the local timezone gets used instead. Timezones are read from zone.tab
  --validate                Validate all kolab-objects and mails, and delete the ones that are invalid.
  --delete                  Delete invalid objects from the server. Applies to validate mode.
  --shared                  Validate shared folders (This requires login with an admin account). Applies to validate mode.
  --save-to <folder>        Store invalid objects under the given path. Applies to validate mode.

Arguments:
  server/file               IMAP Server/File

Usage for upgrading the version
===============================

An example command-line to upgrade all folders of a user would look as follows:

  $ kolab-formatupgrade --u <USERNAME> -p <PASSWORD> -P 993 -e SSL <SERVER-ADDRESS>

Note that this will rewrite all kolab-objects. If this is executed on a folder already converted to version 3 it will simply rewrite all objects unchanged (but still result in entirely new MIME messages).

Usage for converting UTC date-times to local time
=================================================

To convert UTC date-times found in the incidences to floating time (as commonly used in kolab format version 2);

  $ kolab-formatupgrade --u <USERNAME> -p <PASSWORD> -P 993 -e SSL <SERVER-ADDRESS> --fix-utc-incidences

To additionaly specify which source timezone to interpret the UTC time as use the fix-utc-incidences-offset or fix-utc-incidences-timezone options. By default the local timezone will be used.
This is useful in case one is running kolab-formatupgrade from a machine with a different local timezone than the machine with which the kolab object had been originally created.

Usage for Validation
====================

Should a folder contain invalid kolab objects this can create synchronization issues for kolab clients.
Such a situation may arise due to, for example, the usage of third-party tools that inject messages into the store directly.
To detect and remove such objects the kolab-formatupgrade validation functionality can be used.

An example command-line to scan the folders of a user would look as follows:

  $ kolab-formatupgrade --validate --save-to /path/to/folder -u <USERNAME> -p <PASSWORD> -P 993 -e SSL <SERVER-ADDRESS>

To not require the user's password, and instead use proxy authentication (recommended), use the following:

  $ kolab-formatupgrade --validate --save-to /path/to/folder --proxyauth cyrus-admin -u <USER> -p <PASSWORD> -P 993 -e SSL kolab

where <PASSWORD> is the password for the `cyrus-admin` user, and not the user specified as `-u <USER>`.

To scan and validate shared folder hierarchies, use `-u cyrus-admin` with the cyrus-admin password, and the option `--shared`:

  $ kolab-formatupgrade --validate --save-to /path/to/folder --shared -u cyrus-admin -p <PASSWORD> -P 993 -e SSL kolab

Please note that the default examples here do not alter the contents of the mailbox(es) in question.
To purge contents deemed invalid from the mailboxes scanned, add `--delete`. When used in combination with `--save-to /path/to/folder`, the objects deemed invalid will be saved off in to the hierarchy specified (`/path/to/folder`).

