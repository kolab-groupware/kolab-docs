================================
HOWTO: Secure all Kolab Services
================================

This HOWTO is based on Centos 6 with some notes for Debian 7.

The configuration on Debian(-based distributions) is similar, but the base path
for the certifcates storage is different, and Debian already has a group called
``ssl-cert`` to which the user accounts for applications like Cyrus IMAP or
Postfix are added by default.

On CentOS, this group is called ``mail``.

.. warning::

    This guide provides general information about how to enable ssl/tls and
    the majority of your kolab services. This guide is by no means 100%
    complete nor will it get's updated everytime ciphers or protocols get
    deprecated.If you want to know more get deeper knowledge about securing a
    particular service please consult the corresponding software documentation
    or other projects that take care about hardening your server.

    Example:

    *   https://bettercrypto.org

Prerequisites
=============

Prepare your certificates! You'll need your certificate, your key, the CA and
intermediate CA certificates. This tutorial is based on the StartCom SSL CA.
Feel free to use any other Certificate Authority to your liking.

In this case the certificate is a wildcard \*.example.org certificate, which
makes it easier to cover various hostnames (like ``smtp.example.org``,
``imap.example.org`` and ``webmail.example.org``).

#.  Copy your personal SSL certificates on your new Kolab server.

    On Debian the default location is :file:`/etc/ssl/` instead of
    :file:`/etc/pki/tls/`.

    .. parsed-literal::

        # :command:`scp example.org.key kolab.example.org:/etc/pki/tls/private/`
        # :command:`scp example.org.crt kolab.example.org:/etc/pki/tls/certs/`

    On Debian: Make sure the files have the correct permissions:
    * `/etc/ssl/private/example.org.key`: owner root, group ssl-cert and mode 0640
    * `/etc/ssl/certs/example.org.crt`: owner root, group root and mode 0666

#.  You should have obtained a CA certificate or CA certificate chain from your
    SSL certificate issuer.

    If you have not, obtain the root and chain certificates from your
    certification authority. Make sure the source of the certificate is
    verifiable and trusted.

    For example:

    .. parsed-literal::

        # :command:`wget https://www.startssl.com/certs/ca.pem \\
            -O /etc/pki/tls/certs/startcom-ca.pem`

        # :command:`wget https://www.startssl.com/certs/sub.class2.server.ca.pem \\
            -O /etc/pki/tls/certs/startcom-sub.class2.server.ca.pem`

#.  Lets build some bundle files we can use later

    .. parsed-literal::

        # :command:`cat /etc/pki/tls/certs/example.org.crt \\
              /etc/pki/tls/private/example.org.key \\
              /etc/pki/tls/certs/startcom-sub.class2.server.ca.pem \\
              /etc/pki/tls/certs/startcom-ca.pem \\
              > /etc/pki/tls/private/example.org.bundle.pem`

        # :command:`cat /etc/pki/tls/certs/startcom-ca.pem \\
              /etc/pki/tls/certs/startcom-sub.class2.server.ca.pem \\
              > /etc/pki/tls/certs/example.org.ca-chain.pem`

#.  Add an SSL group. Only members of this group should be able to access your
    private key, etc.

    On Debian the usergroup is not needed.

    .. parsed-literal::

        # :command:`chmod 640 /etc/pki/tls/private/* \\
            /etc/pki/tls/certs/*`

        # :command:`chown root:mail /etc/pki/tls/private/example.org.key`

#.  Add the CA to system's CA bundle.

    Other applications and scripts that want to communicate via SSL should point
    to the cabundle in case they want check if your own certificate is trusted.

    For RedHat/Centos based systems:

    .. parsed-literal::

        # :command:`cp /etc/pki/tls/certs/startcom-ca.pem /etc/pki/ca-trust/source/anchors/startcom-ca.pem`
        # :command:`update-ca-trust`

    On Debian based systems you've a different location/command, but the
    rest is the same.

    .. parsed-literal::

        # :command:`cp /etc/ssl/certs/startcom-ca.pem /usr/local/share/ca-certificates/startcom-ca.crt`
        # :command:`update-ca-certificates`

Applications
============

Cyrus IMAPD
-----------

#.  Configure SSL certificates

    **Cyris 2.5 (Kolab 3.2+):**

    .. parsed-literal::

        # :command:`sed -r -i \\
              -e 's|^tls_server_cert.*|tls_server_cert /etc/pki/tls/certs/example.org.crt|g' \\
              -e 's|^tls_server_key.*|tls_server_key /etc/pki/tls/private/example.org.key|g' \\
              -e 's|^tls_server_ca_file.*|tls_server_ca_file /etc/pki/tls/certs/example.org.ca-chain.pem|g' \\
              /etc/imapd.conf`

    **Cyrus 2.4 (Kolab 3.0 + 3.1):**

    .. parsed-literal::

        # :command:`sed -r -i \\
              -e 's|^tls_cert_file:.*|tls_cert_file: /etc/pki/tls/certs/example.org.crt|g' \\
              -e 's|^tls_key_file:.*|tls_key_file: /etc/pki/tls/private/example.org.key|g' \\
              -e 's|^tls_ca_file:.*|tls_ca_file: /etc/pki/tls/certs/example.org.ca-chain.pem|g' \\
              /etc/imapd.conf`

    On Debian: Change the paths according to the Debian file structure (replace `/etc/pki/tls` with
    `/etc/ssl`. Make sure that the user `cyrus` is part of the `ssl-certs` group.

    **Bonus:**

    You can get bonus points to disable weak ciphers like so:

    .. parsed-literal::

        # Cyrus 2.5 (imapd.conf)
        tls_ciphers: EDH+CAMELLIA:EDH+aRSA:EECDH+aRSA+AESGCM:EECDH+aRSA+SHA384:EECDH+aRSA+SHA256:EECDH:+CAMELLIA256:+AES256:+CAMELLIA128:+AES128:+SSLv3:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!DSS:!RC4:!SEED:!ECDSA:CAMELLIA256-SHA:AES256-SHA:CAMELLIA128-SHA:AES128-SHA

        # Cyrus 2.4 (imapd.conf)
        tls_ciphers_list: EDH+CAMELLIA:EDH+aRSA:EECDH+aRSA+AESGCM:EECDH+aRSA+SHA384:EECDH+aRSA+SHA256:EECDH:+CAMELLIA256:+AES256:+CAMELLIA128:+AES128:+SSLv3:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!DSS:!RC4:!SEED:!ECDSA:CAMELLIA256-SHA:AES256-SHA:CAMELLIA128-SHA:AES128-SHA

#.  Restart and verify

    .. parsed-literal::

        # :command:`service cyrus-imapd restart`
        # :command:`sslscan --no-failed localhost:993`
        # :command:`openssl s_client -showcerts -connect localhost:993`

Postfix
-------

#.  Configure SSL certificates

    .. parsed-literal::

        # :command:`postconf -e smtpd_tls_key_file=/etc/pki/tls/private/example.org.key`
        # :command:`postconf -e smtpd_tls_cert_file=/etc/pki/tls/certs/example.org.crt`
        # :command:`postconf -e smtpd_tls_CAfile=/etc/pki/tls/certs/example.org.ca-chain.pem`
        # :command:`postconf -e smtp_tls_mandatory_protocols="!SSLv2,!SSLv3"`
        # :command:`postconf -e smtp_tls_protocols="!SSLv2,!SSLv3"`
        # :command:`postconf -e smtpd_tls_mandatory_protocols="!SSLv2,!SSLv3"`
        # :command:`postconf -e smtpd_tls_protocols="!SSLv2,!SSLv3"`
        # :command:`postconf -e smtpd_tls_mandatory_ciphers=high`
        # :command:`postconf -e smtpd_tls_eecdh_grade=ultra`
        # :command:`postconf -e tls_preempt_cipherlist=yes`
        # :command:`postconf -e tls_high_cipherlist=EDH+CAMELLIA:EDH+aRSA:EECDH+aRSA+AESGCM:EECDH+aRSA+SHA384:EECDH+aRSA+SHA256:EECDH:+CAMELLIA256:+AES256:+CAMELLIA128:+AES128:+SSLv3:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!DSS:!RC4:!SEED:!ECDSA:CAMELLIA256-SHA:AES256-SHA:CAMELLIA128-SHA:AES128-SHA`

    On Debian: Change the paths according to the Debian file structure (replace `/etc/pki/tls` with
    `/etc/ssl`. Make sure that the user `postfix` is part of the `ssl-certs` group.

#.  Restart

    .. parsed-literal::

        # :command:`service postfix restart`
        # :command:`sslscan --starttls --no-failed localhost:587`

Apache2
-------

Apache offers 2 modules that provide SSL support.

The wildly used **mod_ssl** and **mod_nss**. Since **mod_nss** was already
installed and loaded through some dependency I'll cover this.

mod_ssl
^^^^^^^

This is the prefered way and it's easier to work with.

#.  Install **mod_ssl**

    .. parsed-literal::

        # :command:`yum install mod_ssl`


#.  Set your ssl certificates

    .. parsed-literal::

        # :command:`sed -i -e 's/^SSLCertificateFile.*/SSLCertificateFile /etc/pki/tls/certs/example.org.crt/' /etc/httpd/conf.d/ssl.conf`
        # :command:`sed -i -e 's/^SSLCertificateKeyFile.*/SSLCertificateKeyFile /etc/pki/tls/private/example.org.key/' /etc/httpd/conf.d/ssl.conf`
        # :command:`sed -i -e 's/^#?SSLCertificateChainFile.*/SSLCertificateChainFile /etc/pki/tls/certs/example.org.ca-chain.pem/' /etc/httpd/conf.d/ssl.conf`

#.  Fine tune your ssl/tls ciphers and protocols

    .. parsed-literal::

        # :command:`sed -i -e 's/^SSLProtocol.*/SSLProtocol All -SSLv2 -SSLv3/' /etc/httpd/conf.d/ssl.conf`
        # :command:`sed -i -e "s/^SSLProtocol/SSLHonorCipherOrder on\\nSSLProtocol/" /etc/httpd/conf.d/ssl.conf`
        # :command:`sed -i -e 's/^SSLCipherSuite.*/SSLCipherSuite "EDH+CAMELLIA:EDH+aRSA:EECDH+aRSA+AESGCM:EECDH+aRSA+SHA384:EECDH+aRSA+SHA256:EECDH:+CAMELLIA256:+AES256:+CAMELLIA128:+AES128:+SSLv3:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!DSS:!RC4:!SEED:!ECDSA:CAMELLIA256-SHA:AES256-SHA:CAMELLIA128-SHA:AES128-SHA"/' /etc/httpd/conf.d/ssl.conf`


#.  Create a vhost for http (:80) to redirect everything to https

    .. parsed-literal::

        # :command:`cat >> /etc/httpd/conf/httpd.conf << EOF

        <VirtualHost _default_:80>
            RewriteEngine On
            RewriteRule ^(.*)$ https://%{HTTP_HOST}$1 [R=301,L]
        </VirtualHost>
        EOF`

#.  Restart and verify

    .. parsed-literal::

        # :command:`service httpd restart`
        # :command:`openssl s_client -showcerts -connect localhost:443`

mod_nss
^^^^^^^

This is an alternative to **mod_ssl**.

#.  Import your CA into NSS Cert Database for Apache

    .. parsed-literal::

        # :command:`certutil -d /etc/httpd/alias -A  -t "CT,," \\
            -n "StartCom Certification Authority" \\
            -i /etc/pki/tls/certs/startcom-ca.pem`

#.  Convert and import your personal certificate into NSS DB

    .. parsed-literal::

        # :command:`openssl pkcs12 -export \\
            -in /etc/pki/tls/certs/example.org.crt \\
            -inkey /etc/pki/tls/private/example.org.key \\
            -out /tmp/example.p12 -name Server-Cert -passout pass:foo`

        # :command:`echo "foo" > /tmp/foo`
        # :command:`pk12util -i /tmp/example.p12 -d /etc/httpd/alias -w /tmp/foo -k /dev/null`
        # :command:`rm /tmp/foo`
        # :command:`rm /tmp/example.p12`

#.  You should now be able to see all the imported certificates

    .. parsed-literal::

        # :command:`certutil -L -d /etc/httpd/alias`
        # :command:`certutil -V -u V -d /etc/httpd/alias -n "Server-Cert"`

#.  Move mod_nss from port 8443 to 443 and configure the certificate that
    mod_nss should use.

    .. parsed-literal::

        # :command:`sed -i -e 's/8443/443/' /etc/httpd/conf.d/nss.conf`
        # :command:`sed -i -e 's/NSSNickname.*/NSSNickname Server-Cert/' \\
            /etc/httpd/conf.d/nss.conf`

#.  Create a vhost for http (:80) to redirect everything to https

    .. parsed-literal::

        # :command:`cat >> /etc/httpd/conf/httpd.conf << EOF

        <VirtualHost _default_:80>
            RewriteEngine On
            RewriteRule ^(.*)$ https://%{HTTP_HOST}$1 [R=301,L]
        </VirtualHost>
        EOF`

#.  Restart and verify

    .. parsed-literal::

        # :command:`service httpd restart`
        # :command:`openssl s_client -showcerts -connect localhost:443`


389 Directory Server
--------------------

.. note::

    Unless you want to make your LDAP Service available to other services on
    other servers you can safely skip this section. There's no need to enable
    SSL/TLS if you only use LDAP on ``localhost``.

If you've more question please refer the the documentation of the 389 directory
server.

*   http://directory.fedoraproject.org/docs/389ds/howto/howto-ssl.html

Enable SSL/TLS

#.  First you must import your PEM File into the certutil certificate store
    (identical to Apache with **mod_nss**)

    .. parsed-literal::

        # :command:`certutil -d /etc/dirsrv/slapd-\$(hostname -s)/ -A  -t "CT,," \\
            -n "StartCom Certification Authority" \\
            -i /etc/pki/tls/certs/startcom-ca.pem`

        # :command:`openssl pkcs12 -export \\
            -in /etc/pki/tls/certs/example.org.crt \\
            -inkey /etc/pki/tls/private/example.org.key \\
            -out /tmp/example.p12 -name Server-Cert -passout pass:foo`

        # :command:`echo "foo" > /tmp/foo`
        # :command:`pk12util -i /tmp/example.p12 -d /etc/dirsrv/slapd-\$(hostname -s)/ \\
            -w /tmp/foo -k /dev/null`
        # :command:`rm /tmp/foo`
        # :command:`rm /tmp/example.p12`

#.  Enable SSL Support

    Since all the configuration for 389ds is being done live, changing and adding SSL support will require some LDAP commands to modify the server configuration.

    .. parsed-literal::

        # :command:`passwd=$(grep ^bind_pw /etc/kolab/kolab.conf | cut -d '=' -f2- | sed -e 's/\\s*//g')`
        # :command:`ldapmodify -x -h localhost -p 389 \\
            -D "cn=Directory Manager" -w "${passwd}" << EOF
        dn: cn=encryption,cn=config
        changetype: modify
        replace: nsSSL2
        nsSSL2: off
        -
        replace: nsSSL3
        nsSSL3: off
        -
        replace: nsTLS1
        nsTLS1: on
        -
        replace: nsSSLClientAuth
        nsSSLClientAuth: allowed

        dn: cn=config
        changetype: modify
        add: nsslapd-security
        nsslapd-security: on
        -
        replace: nsslapd-ssl-check-hostname
        nsslapd-ssl-check-hostname: off
        -
        replace: nsslapd-secureport
        nsslapd-secureport: 636

        dn: cn=RSA,cn=encryption,cn=config
        changetype: add
        objectclass: top
        objectclass: nsEncryptionModule
        cn: RSA
        nsSSLPersonalitySSL: Server-Cert
        nsSSLToken: internal (software)
        nsSSLActivation: on
        EOF`

#.  Next, restart the LDAP service:

    .. parsed-literal::

        # :command:`service dirsrv restart`
        # :command:`openssl s_client -connect localhost:636`

#.  You can test if your LDAP over SSL is configured correctly via the
    ``openssl s_client -connect localhost:636`` command, or just making a query
    using ``ldapsearch``:

    Test non-SSL connection

    .. parsed-literal::

        # :command:`ldapsearch -x -H ldap://kolab.example.org \\
            -b "cn=kolab,cn=config" -D "cn=Directory Manager" \\
            -w "${passwd}"`

    Test SSL connection

    .. parsed-literal::

        # :command:`ldapsearch -x -H ldaps://kolab.example.org \\
            -b "cn=kolab,cn=config" -D "cn=Directory Manager" \\
            -w "${passwd}"`

Kolab Components
================

kolab-cli
---------

With the HTTP Service configured to force SSL communication you must add/update
your kolab-cli API url.

    .. parsed-literal::

        # :command:`sed -r -i \\
              -e '/api_url/d' \\
              -e "s#\\[kolab_wap\\]#[kolab_wap]\\napi_url = https://kolab.example.org/kolab-webadmin/api#g" \\
              /etc/kolab/kolab.conf`

Roundcube/Plugins
-----------------

Set correct SSL parameters for HTTP_Request2. This will ensure the
``kolab_files`` plugin and Chwala can talk over HTTPS.


#.  Change freebusy API url in the ``libkolab`` plugin configuration:

    .. parsed-literal::

        # :command:`sed -i -e 's/http:/https:/' /etc/roundcubemail/libkolab.inc.php`

#.  Change Chwala API url in the ``kolab_files`` plugin configuration:

    .. parsed-literal::

        # :command:`sed -i -e 's/http:/https:/' /etc/roundcubemail/kolab_files.inc.php`

#.  Lets remove the php-close tag line as a quick hack to make it easier for us
    to extend the :file:`/etc/roundcubemail/config.inc.php`:

    .. parsed-literal::

        # :command:`sed -i -e '/^\?>/d' /etc/roundcubemail/config.inc.php`

#.  Tell the webclient the SSL iRony URLs for CalDAV and CardDAV:

    .. parsed-literal::

        # :command:`cat >> /etc/roundcubemail/config.inc.php << EOF
        # caldav/webdav
        \\$config['calendar_caldav_url']             = "https://%h/iRony/calendars/%u/%i";
        \\$config['kolab_addressbook_carddav_url']   = 'https://%h/iRony/addressbooks/%u/%i';
        EOF`

#.  Additionaly, you can redirect all http traffic to https:

    .. parsed-literal::

        # :command:`cat >> /etc/roundcubemail/config.inc.php << EOF
        # Force https redirect for http requests
        \\$config['force_https'] = true;
        EOF`

#.  **Optional**: Switch to verified ssl connections

    This will enable the ssl-verification for internal api calls between
    kolab php components (like roundcube <> chwala). If you care about this
    you're free to do so, but don't forget the parts of python/kolab.conf as
    well.

    Usually these calls are internal (on localhost) and therefore don't really
    need to to trust the ssl endpoint.

    #.  Remove old-style SSL configuration parameters

        .. parsed-literal::

            # :command:`sed -i -e '/kolab_ssl/d' /etc/roundcubemail/libkolab.inc.php`

    #.  Enable SSL verification against our extended CA bundle.

        .. parsed-literal::

            # :command:`cat >> /etc/roundcubemail/config.inc.php << EOF
            \\$config['kolab_http_request'] = array(
                    'ssl_verify_peer'       => true,
                    'ssl_verify_host'       => true,
                    'ssl_cafile'            => '/etc/pki/tls/certs/ca-bundle.crt'
            );
            EOF`

