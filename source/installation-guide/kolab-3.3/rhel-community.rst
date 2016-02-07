========================================
Installation on Red Hat Enterprise Linux
========================================

1.  Install the `EPEL repository <http://fedoraproject.org/wiki/EPEL>`_
    configuration using the RPM package linked to from:

    *   `EPEL for CentOS 7`_

    *   `EPEL for CentOS 6`_

    .. parsed-literal::

        # :command:`rpm -Uhv http://url/to/epel-release.rpm`

2.  Install the Kolab Groupware repository configuration:

    For CentOS 7:

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`
        # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.3/CentOS_7/Kolab:3.3.repo`
        # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.3:/Updates/CentOS_7/Kolab:3.3:Updates.repo`

    For CentOS 6:

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`
        # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.3/CentOS_6/Kolab:3.3.repo`
        # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.3:/Updates/CentOS_6/Kolab:3.3:Updates.repo`

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

Continue to :ref:`installation-guide-setup-kolab`.

.. _EPEL for CentOS 6: http://download.fedoraproject.org/pub/epel/6/i386/repoview/epel-release.html
.. _EPEL for CentOS 7: http://download.fedoraproject.org/pub/epel/beta/7/x86_64/repoview/epel-release.html
