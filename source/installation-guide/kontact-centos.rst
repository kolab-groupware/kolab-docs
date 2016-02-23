======================
Installation on CentOS
======================

1.  Activate the EPEL repository:

    .. parsed-literal::

        # :command:`yum install epel-release`

2.  Install the Kontact repository configuration:

    For CentOS 7:

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`
        # :command:`wget https://obs.kolabsys.com/repositories/Kontact:/4.13/CentOS_7/Kontact:4.13.repo`

3.  Make sure that the Kolab Kontact repositories get a higher priority, eg.
    we need kdepimlibs to be installed from Kolab rather than from CentOS:

    .. parsed-literal::

        # :command:`for f in /etc/yum.repos.d/Kontact*.repo`
        # :command:`do`
        # :command:`sed -i "s#enabled=1#enabled=1\\npriority=0#g" $f`
        # :command:`done`

4.  Import the GPG key used to sign the packages:

    .. parsed-literal::

        # :command:`rpm --import https://ssl.kolabsys.com/community.asc`

5.  Install the Kolab Desktop Client

    .. parsed-literal::

        # :command:`yum install kolab-desktop-client`

Continue to :ref:`_settings-clientconfig-kontact`.
