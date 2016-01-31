.. _installation-ucs-4-community-3.4:

==========================================================
Installation of Kolab 3.4 on Univention Corporate Server 4
==========================================================

Kolab Groupware is available in the App Center included with Univention
Corporate Server. The edition in the Univention Corporate Server App
Center is the recommended edition of Kolab Groupware unless you have a
support contract with `Kolab Systems`_ -- in which case you will want to
install the enterprise edition as documented in
:ref:`installation-ucs-enterprise`.

.. IMPORTANT::

    There are **multiple versions** of Kolab for UCS. Make sure you
    choose the correct version for your requirements.

Kolab Groupware from the OBS
============================

.. WARNING::

    This is a community version of Kolab Groupware, and it is not
    recommended you run this version in production. Instead, for
    production systems, use Kolab Enterprise from Kolab Systems.

1.  Add the following two lines to ``/etc/apt/sources.list.d/kolab.list``:

    .. parsed-literal::

        deb http://obs.kolabsys.com/repositories/Kolab:/3.4/UCS_4.0/ ./
        deb http://obs.kolabsys.com/repositories/Kolab:/3.4:/Updates/UCS_4.0/ ./

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
