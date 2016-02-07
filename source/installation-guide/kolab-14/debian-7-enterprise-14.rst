.. _installation-guide-debian-7-enterprise-14:

========================================================
Installation of Kolab Enterprise 14 on Debian 7 (Wheezy)
========================================================

1.  Install the **apt-transport-https** package:

    .. parsed-literal::

        # :command:`aptitude -y install apt-transport-https`

2.  Add the following two lines to ``/etc/apt/sources.list.d/kolab.list``:

    .. parsed-literal::

        deb https://mirror.kolabsys.com/debian/kolab-14/ wheezy release updates
        deb-src https://mirror.kolabsys.com/debian/kolab-14/ wheezy release updates

3.  To ensure the Kolab packages have priority over the Debian packages, such as
    must be the case for PHP as well as Cyrus IMAP, please make sure the APT
    preferences pin the mirror.kolabsys.com origin as a preferred source.

    Put the following in ``/etc/apt/preferences.d/kolab``:

    .. parsed-literal::

        Package: *
        Pin: origin mirror.kolabsys.com
        Pin-Priority: 501

4.  Install the client certificate and certificate authority files:

5.  Configure **APT** to use the certificates installed in step 4 by
    creating a file ``/etc/apt/apt.conf.d/71kolab`` with the following
    contents:

    .. parsed-literal::

        Acquire {
            https {
                mirror.kolabsys.com {
                    Verify-Peer "false";
                    Verify-Host "false";
                    CaInfo "/etc/apt/certs/mirror.kolabsys.com.ca.cert";

                    SslCert "/etc/apt/certs/mirror.kolabsys.com.client.pem";
                    SslKey "/etc/apt/certs/mirror.kolabsys.com.client.pem";
                };
            };
        };

6.  Update the repository metadata:

    .. parsed-literal::

        # :command:`apt-get update`

7.  Start the installation of the base package as follows:

    .. parsed-literal::

        # :command:`aptitude install kolab`

8.  When asked to confirm you want to install the package and its dependencies, press Enter.

Continue to :ref:`installation-guide-setup-kolab`.
