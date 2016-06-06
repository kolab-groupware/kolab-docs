===============
Sender BCC Maps
===============

When a shared folder is used by a number of people, each of them individually
sending new messages and responding to existing threads, it is important to be
able to let the other people be aware of the contents of the entire thread.

Suppose John and Jane are both responsible for the shared mail folder
`shared/info@example.org` -- the recipient for all `info@example.org` traffic.

Now suppose that John and Jane both have been delegated the authority to submit
messages with an envelope sender address of `info@example.org`.

The following configuration will enable responses and new messages that John or
Jane send, using the `info@example.org` identity they have been delegated
authority for, to be stored as part of the ongoing conversation in
`shared/info@example.org`.

#.  Add a lookup table :file:`/etc/postfix/ldap/sender_bcc_maps_sharedfolders.cf`:

    .. parsed-literal::

        server_host = localhost
        server_port = 389
        version = 3
        search_base = dc=example,dc=org
        scope = sub

        domain = ldap:/etc/postfix/ldap/mydestination.cf

        bind_dn = uid=kolab-service,ou=Special Users,dc=example,dc=org
        bind_pw = someverysecretpassword

        query_filter = (&(|(mail=%s)(alias=%s))(objectclass=kolabsharedfolder)(kolabFolderType=mail))
        result_attribute = mail

#.  Configure **postfix** to use this lookup table:

    .. parsed-literal::

        # :command:`postconf -e 'sender_bcc_maps=ldap:/etc/postfix/ldap/sender_bcc_maps_sharedfolders.cf'`
        # :command:`systemctl reload postfix`

