==========================================================
The CRAM-MD5 and DIGEST-MD5 SASL Authentication Mechanisms
==========================================================

These two credential exchange mechanisms depend on the tip of the iceberg being
a shared secret, that both parties have available to them in plaintext, prior
to the actual exchange of credentials.

Starting at such tip, the mechanisms basically describe a methodology for the
server and the client to each end up with an iceberg of the same dimensions, so
that it can be compared, and matched.

The principle of storing a shared secret at any one location -- let alone at
multiple individual, stand-alone locations -- that also harbors the attack
surface of a service is a virtual no-go. Storing the shared secret in plaintext
is one type of offence, and storing the shared secret in a reverse-cryptable
fashion is another type of offence.

However, some networks may have, in the past, some long time ago, consciously
or otherwise, decided that running a PKI was just slightly too inconvenient,
and perhaps unprotected traffic would therefore need not exchange any user's
credentials in humanly legible form. Enter secrecy for the wire, but obscurity
for the client and the server both.

.. IMPORTANT::

    It MUST be very clear by now, such CAN NOT sustain an environment with the
    continued support of Kolab.

    If it is not yet all that clear though, please feel free to contact your
    friendly consultant at Kolab Systems AG.

To migrate such environments, one might enable CRAM-MD5 and/or DIGEST-MD5
authentication credential exchange mechanisms. The assumption is that either
you use :file:`/etc/sasldb2` and have the means to synchronize password changes
over however many systems, or that you already use a plugin allowing you to
centralize the storage so it can be reached by multiple systems, over the
network. Re-apply whichever logic to your Kolab servers, and you should be fine
and live happily ever after -- you get rid of plain text copies of users'
passwords on your servers.

#.  In :file:`/etc/imapd.conf`, ensure the following is set:

    .. parsed-literal::

        sasl_pwcheck_method: auxprop saslauthd

#.  Add to :file:`/etc/imapd.conf`, if it doesn't already exist:

    .. parsed-literal::

        sasl_mech_list: PLAIN LOGIN CRAM-MD5 DIGEST-MD5

#.  Ensure (albeit contrary to the aforementioned advice) you have the **cyrus-sasl-md5** package installed:

    .. parsed-literal::

        # :command:`yum -y install cyrus-sasl-md5`

#.  Entertain Postfix with a similar set of configuration items in :file:`/etc/sasl2/smtpd.conf`:

    .. parsed-literal::

        pwcheck_method: auxprop saslauthd
        auxprop_plugin: sasldb
        mech_list: PLAIN LOGIN CRAM-MD5 DIGEST-MD5

#.  Restart services as you deem appropriate.

Now you can test the functionality as follows:

.. parsed-literal::

    $ :command:`imtest -t "" -u cyrus-admin -a cyrus-admin -w LDAP_PASSWORD`

Add this user with a different password, to the local sasldb:

.. parsed-literal::

    $ :command:`saslpasswd2 -c cyrus-admin`

And run again:

.. parsed-literal::

    $ :command:`imtest -t "" -u cyrus-admin -a cyrus-admin -w LDAP_PASSWORD`

Also run:

.. parsed-literal::

    $ :command:`imtest -t "" -m CRAM-MD5 -u cyrus-admin -a cyrus-admin -w SASLDB_PASSWORD`
