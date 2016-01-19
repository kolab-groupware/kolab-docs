======================
Installation on Fedora
======================

1.  Install the Kontact repository configuration:

    For Fedora 22 (Twenty Two):

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`
        # :command:`wget https://obs.kolabsys.com/repositories/Kontact:/4.13:/Git/Fedora_22/Kontact:4.13:Git.repo`

    For Fedora 21 (Twenty One):

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`
        # :command:`wget https://obs.kolabsys.com/repositories/Kontact:/4.13:/Git/Fedora_21/Kontact:4.13:Git.repo`

2.  Make sure that the Kolab Kontact repositories get a higher priority, eg. we need kdepimlibs to be installed from Kolab rather than from Fedora:

    .. parsed-literal::

        # :command: `for f in /etc/yum.repos.d/Kontact*.repo`
        # :command: `do`
        # :command:     `sed -i "s#enabled=1#enabled=1\\npriority=0#g" $f`
        # :command: `done`

3.  Import the GPG key used to sign the packages:

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

4.  Install the Kolab Desktop Client

    .. parsed-literal::

        # :command:`yum install kolab-desktop-client`
