.. _installation-rhel-6-enterprise-13:

=================================================================
Installation of Kolab Enterprise 13 on Red Hat Enterprise Linux 6
=================================================================

The installation of Kolab Groupware on Red Hat Enterprise Linux installs
a number of additional packages, from the :term:`EPEL` software
repository, and the repositories for the Kolab Enterprise edition,
provided by `Kolab Systems AG`_.

Installation Procedure
======================

1.  Copy the client SSL certificate and key you have obtained from
    `Kolab Systems AG`_ as per the instructions listed on [#]_,
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

2.  Install the `EPEL repository <http://fedoraproject.org/wiki/EPEL>`_
    configuration using the RPM package linked to from:

    *   `EPEL for Enterprise Linux 6`_

    .. parsed-literal::

        # :command:`rpm -Uhv http://url/to/epel-release.rpm`

3.  Obtain a copy of the GPG signature used to sign packages:

    .. parsed-literal::

        # :command:`wget https://ssl.kolabsys.com/santiago.asc`

4.  Import this signature in to the RPM database:

    .. parsed-literal::

        # :command:`rpm --import santiago.asc`

5.  Install the **yum-plugin-priorities** software package:

    .. parsed-literal::

        # :command:`yum -y install yum-plugin-priorities`

6.  Download the Kolab Enterprise repository configuration package:

    .. parsed-literal::

        # :command:`wget https://ssl.kolabsys.com/kolab-enterprise-13-for-el6.rpm`

7.  Verify the signature on the downloaded RPM package:

    .. parsed-literal::

        # :command:`rpm -K kolab-enterprise-13-for-el6.rpm`
        kolab-enterprise-13-for-el6.rpm: sha1 md5 OK

    .. WARNING::

        Do NOT install the repository configuration for Kolab Enterprise
        13 from this package, should the verification of the package
        fail.

8.  Install the repository configuration:

    .. parsed-literal::

        # :command:`yum localinstall kolab-enterprise-13-for-el6.rpm`

9.  Install Kolab Enterprise:

    .. parsed-literal::

        # :command:`yum install kolab`

Continue to :ref:`install-setup-kolab`.

.. rubric:: Footnotes

.. [#]

    https://support.kolabsys.com/Obtaining,_Renewing_and_Using_a_Client_SSL_Certificate#Using_a_Customer_or_Partner_Client_SSL_Certificate
