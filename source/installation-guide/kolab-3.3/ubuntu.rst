======================
Installation on Ubuntu
======================

1.  Add the following two lines to ``/etc/apt/sources.list.d/kolab.list``:

    For Ubuntu 12.04:

    .. parsed-literal::

        deb http://obs.kolabsys.com/repositories/Kolab:/3.3/Ubuntu_12.04/ ./
        deb http://obs.kolabsys.com/repositories/Kolab:/3.3:/Updates/Ubuntu_12.04/ ./

    For Ubuntu 13.10:

    .. parsed-literal::

        deb http://obs.kolabsys.com/repositories/Kolab:/3.3/Ubuntu_13.10/ ./
        deb http://obs.kolabsys.com/repositories/Kolab:/3.3:/Updates/Ubuntu_13.10/ ./

    For Ubuntu 14.04:

    .. parsed-literal::

        deb http://obs.kolabsys.com/repositories/Kolab:/3.3/Ubuntu_14.04/ ./
        deb http://obs.kolabsys.com/repositories/Kolab:/3.3:/Updates/Ubuntu_14.04/ ./

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

3.  To ensure the Kolab packages have priority over the Ubuntu packages, such as
    must be the case for PHP as well as Cyrus IMAP, please make sure the APT
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

        # :command:`aptitude install kolab`

6.  When asked to confirm you want to install the package and its dependencies, press Enter.

Continue to :ref:`installation-guide-setup-kolab`.
