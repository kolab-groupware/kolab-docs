======================
Installation on Fedora
======================

1.  Install the Kontact repository configuration:

    For Fedora 23 (Twenty Three):

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`
        # :command:`wget https://obs.kolabsys.com/repositories/Kontact:/4.13/Fedora_23/Kontact:4.13.repo`

    For Fedora 22 (Twenty Two):

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`
        # :command:`wget https://obs.kolabsys.com/repositories/Kontact:/4.13/Fedora_22/Kontact:4.13.repo`

2.  Make sure that the Kolab Kontact repositories get a higher priority, eg.
    we need kdepimlibs to be installed from Kolab rather than from Fedora:

    .. parsed-literal::

        # :command:`for f in /etc/yum.repos.d/Kontact*.repo`
        # :command:`do`
        # :command:`sed -i "s#enabled=1#enabled=1\\npriority=0#g" $f`
        # :command:`done`

3.  Import the GPG key used to sign the packages:

    .. parsed-literal::

        # :command:`rpm --import https://ssl.kolabsys.com/community.asc`

4.  Install the Kolab Desktop Client

    .. parsed-literal::

        # :command:`yum install kolab-desktop-client`

Continue to :ref:`_settings-clientconfig-kontact`.
