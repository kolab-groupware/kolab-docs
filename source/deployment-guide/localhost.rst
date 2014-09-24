.. _deployment-localhost:

A Single Server Kolab Deployment
================================

This is the default installation for a Kolab Groupware server, when the
``setup-kolab`` bootstrap utility is run.

A single server runs all services related to Kolab, including the LDAP,
SMTP, IMAP, HTTP and MySQL servers.

Since this deployment is not highly-available, and can only be scaled up
vertically (i.e. by giving the system more resources), this is typically
a small deployment for a limited number of users.

Should you be looking to provide your environment with a level of
redundancy, please see :ref:`deployment-redundant-servers`.
