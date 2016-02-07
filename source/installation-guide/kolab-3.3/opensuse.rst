========================
Installation on openSUSE
========================

1.  Install the Kolab Groupware repositories:

    For openSUSE 13.1:

    .. parsed-literal::

        # :command:`zypper ar http://obs.kolabsys.com/repositories/Kolab:/3.3/openSUSE_13.1/Kolab:3.3.repo`
        # :command:`zypper ar http://obs.kolabsys.com/repositories/Kolab:/3.3:/Updates/openSUSE_13.1/Kolab:3.3:Updates.repo`

    For openSUSE 12.3:

    .. parsed-literal::

        # :command:`zypper ar http://obs.kolabsys.com/repositories/Kolab:/3.3/openSUSE_12.3/Kolab:3.3.repo`
        # :command:`zypper ar http://obs.kolabsys.com/repositories/Kolab:/3.3:/Updates/openSUSE_12.3/Kolab:3.3:Updates.repo`

2.  Import the GPG key used to sign the packages:

    .. parsed-literal::

        # :command:`gpg --search devel@lists.kolab.org`
        gpg: searching for "devel@lists.kolab.org" from hkp server pgp.mit.edu
        (1) Kolab Development Coordination Mailing List <devel@lists.kolab.org>
            2048 bit RSA key 446D5A45, created: 2014-08-20
        Keys 1-1 of 1 for "devel@lists.kolab.org".  Enter number(s), N)ext, or Q)uit > :command:`1`

    The key's fingerprint is: ``79D8 6A05 FDE6 C9FB 4E43  A6C5 830C 2BCF 446D 5A45``

    .. parsed-literal::

        # :command:`gpg --export --armor devel@lists.kolab.org > devel.asc`
        # :command:`rpm --import devel.asc`

3.  Install Kolab Groupware:

    .. parsed-literal::

        # :command:`zypper in kolab`

Continue to :ref:`installation-guide-setup-kolab`.
