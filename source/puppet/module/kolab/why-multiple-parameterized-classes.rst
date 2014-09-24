.. _puppet-module-kolab-why-multiple-parameterized-classes:

=======================================
Why Use Multiple Parameterized Classes?
=======================================

When two nodes provide a part of the same or similar service, such as an
IMAP frontend and an IMAP backend, it is desirable to allow them to have
different configuration, while their individual configuration is
generated from the same template.

One example is the :man:`imapd.conf(5)` ``configdir`` setting, which on
IMAP frontends is a happy default, but is usually under the same
directory hierarchy as meta- and spool-partitions.
