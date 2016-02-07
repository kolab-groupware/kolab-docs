.. _installation-guide-rhel-6-enterprise-14:

=================================================================
Installation of Kolab Enterprise 14 on Red Hat Enterprise Linux 6
=================================================================

The installation of Kolab Groupware on Red Hat Enterprise Linux installs
a number of additional packages, from the :term:`EPEL` software
repository, and the repositories for the Kolab Enterprise edition,
provided by `Kolab Systems AG`_.

Installation Procedure
======================

1.  Copy the client SSL certificate and key you have obtained from
    `Kolab Systems AG`_ as per the instructions listed on [1]_,
    summarized here for your convenience:

    #.  Remove the passphrase from the SSL certificate key:

        .. parsed-literal::

            # :command:`openssl rsa -in /path/to/private.key \\
                -out /path/to/private.key.nopass`

    #.  Concatenate the certificate file and the new key file without
        passphrase:

        .. parsed-literal::

            # :command:`cat /path/to/public.crt /path/to/private.key.nopass \\
                > /path/to/mirror.kolabsys.com.client.pem`

    #.  Place the file :file:`mirror.kolabsys.com.ca.cert` in
        :file:`/etc/pki/tls/certs/`.

    #.  Place the file :file:`mirror.kolabsys.client.pem` in
        :file:`/etc/pki/tls/private/`, and correct the permissions:

        .. parsed-literal::

            # :command:`chown root:root /etc/pki/tls/private/mirror.kolabsys.com.client.pem`
            # :command:`chmod 640 /etc/pki/tls/private/mirror.kolabsys.com.client.pem`

2.  Install the :term:`EPEL` repository

    .. parsed-literal::

        # :command:`rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm`

3.  Import this signature in to the RPM database:

    .. parsed-literal::

        # :command:`rpm --import https://ssl.kolabsys.com/santiago.asc`

4.  Install the Kolab Enterprise repository configuration package:

    .. parsed-literal::

        # :command:`yum install https://ssl.kolabsys.com/kolab-enterprise-14-for-el6.rpm`

5.  Install Kolab Enterprise:

    .. parsed-literal::

        # :command:`yum install kolab`

6.  Do not forget to also execute :command:`yum update`.

Continue to :ref:`installation-guide-setup-kolab`.

.. rubric:: Footnotes

.. [#]

    https://support.kolabsys.com/Obtaining,_Renewing_and_Using_a_Client_SSL_Certificate#Using_a_Customer_or_Partner_Client_SSL_Certificate.
