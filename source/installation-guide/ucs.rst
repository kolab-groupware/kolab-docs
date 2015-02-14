.. _installation-ucs:

===========================================
Installation on Univention Corporate Server
===========================================

.. IMPORTANT::

    There are **multiple versions** of Kolab for UCS. Make sure you
    choose the correct version for your requirements.

Kolab Enterprise 13
===================

To install the Enterprise edition under Kolab Systems support, execute
the following process:

#.  Configure your UCS system to obtain the repository configuration packages:

    .. parsed-literal::

        # :command:`ucr set \\
            repository/online/component/kolab-13=enabled \\
            repository/online/component/kolab-13/description="Kolab Enterprise 13 Installation Repository" \\
            repository/online/component/kolab-13/server="mirror.kolabsys.com" \\
            repository/online/component/kolab-13/prefix="pub/ucs" \\
            repository/online/component/kolab-13/version="current" \\
            repository/online/component/kolab-13/parts="maintained"`

#.  Install the client certificate you have obtained from Kolab Systems in the
    following location:

    .. parsed-literal::

        /etc/apt/certs/mirror.kolabsys.com.client.pem

    If you do not have an SSL client certificate from Kolab Systems, contact
    sales@kolabsys.com.

#.  Install the repository configuration package:

    .. parsed-literal::

        # :command:`univention-install kolab-13-enterprise-release`

    When the installation complains the package cannot be verified, type [y] and
    [Enter] to continue:

    .. parsed-literal::

        WARNING: The following packages cannot be authenticated!
          kolab-13-enterprise-release
        Install these packages without verification [y/N]? y

#.  Install kolab:

    .. parsed-literal::

        # :command:`univention-install kolab`

App Center Edition
==================

An evaluation version of Kolab is available in the Univention App
Center. This edition does *not* provide you with bugfix, security or
enhancement updates.

Kolab Groupware from the OBS
============================

.. WARNING::

    This is a community version of Kolab Groupware, and it is not
    recommended you run this version in production. Instead, for
    production systems, use Kolab Enterprise from Kolab Systems.

1.  Add the following two lines to ``/etc/apt/sources.list.d/kolab.list``:

    For UCS 3.2:

    .. parsed-literal::

        deb http://obs.kolabsys.com/repositories/Kolab:/3.4/UCS_3.2/ ./
        deb http://obs.kolabsys.com/repositories/Kolab:/3.4:/Updates/UCS_3.2/ ./

2.  Import the GPG key used to sign the packages:

    .. parsed-literal::

        # :command:`gpg --search devel@lists.kolab.org`
        gpg: searching for "devel@lists.kolab.org" from hkp server pgp.mit.edu
        (1) Kolab Development Coordination Mailing List <devel@lists.kolab.org>
            2048 bit RSA key 446D5A45, created: 2014-08-20
        Keys 1-1 of 1 for "devel@lists.kolab.org".  Enter number(s), N)ext, or Q)uit > :command:`1`

    The key's fingerprint is: ``79D8 6A05 FDE6 C9FB 4E43  A6C5 830C 2BCF 446D 5A45``

    .. parsed-literal::

        # :command:`gpg --export --armor devel@lists.kolab.org | apt-key add -`

3.  To ensure the Kolab packages have priority over the Debian packages, such as
    must be the case for PHP as well as Cyrus IMAP, please make sure the APT
    preferences pin the obs.kolabsys.com origin as a preferred source.

    Put the following in ``/etc/apt/preferences.d/kolab``:

    .. parsed-literal::

        Package: *
        Pin: origin obs.kolabsys.com
        Pin-Priority: 501

4.  Enable the unmaintained UCS software repositories:

    .. parsed-literal::

        # :command:`ucr set repository/online/unmaintained="yes"`

5.  Update the repository metadata and install Kolab:

    .. parsed-literal::

        # :command:`univention-install kolab`

.. IMPORTANT::

    The Kolab Groupware packages for Univention Corporate Server are configured
    automatically. There is no need to run any setup.
