.. _installation-guide-debian-10:

=====================================
Installation of Kolab 16 on Debian 10
=====================================

.. WARNING::

    This document sets you up with the version of Kolab that is maintained by
    the community.

1.  Add the following two lines to ``/etc/apt/sources.list.d/kolab.list``:

    .. parsed-literal::

        deb http://obs.kolabsys.com/repositories/Kolab:/16/Debian_10.0/ ./
        deb-src http://obs.kolabsys.com/repositories/Kolab:/16/Debian_10.0/ ./

2.  Import the GPG key used to sign the packages:

    .. parsed-literal::

        # :command:`wget -q -O- https://ssl.kolabsys.com/community.asc | apt-key add -`

3.  To ensure the Kolab packages have priority over the Debian packages, as
    must be the case for Cyrus IMAP, please make sure the APT
    preferences pin the obs.kolabsys.com origin as a preferred source.

    Put the following in ``/etc/apt/preferences.d/kolab``:

    .. parsed-literal::

        Package: *
        Pin: origin obs.kolabsys.com
        Pin-Priority: 501

4.  Update the repository metadata:

    .. parsed-literal::

        # :command:`apt-get update`

5. Start the installation of the base package as follows:

    .. parsed-literal::

        # :command:`aptitude -y install kolab`

Continue to :ref:`installation-guide-setup-kolab`.
