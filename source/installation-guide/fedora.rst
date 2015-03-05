======================
Installation on Fedora
======================

1.  Install the Kolab Groupware repository configuration:

    For Fedora 21:

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`
        # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.4/Fedora_21/Kolab:3.4.repo`
        # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.4:/Updates/Fedora_21/Kolab:3.4:Updates.repo`

    For Fedora 20 (Heisenburg):

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`
        # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.4/Fedora_20/Kolab:3.4.repo`
        # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.4:/Updates/Fedora_20/Kolab:3.4:Updates.repo`

2.  Make sure that the Kolab repositories get a higher priority, eg. we need roundcubemail to be installed from Kolab rather than from Fedora:

    .. parsed-literal::

        # :command: `for f in /etc/yum.repos.d/Kolab*.repo`
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

4.  Install Kolab Groupware:

    .. parsed-literal::

        # :command:`yum install kolab`

Continue to :ref:`install-setup-kolab`.
