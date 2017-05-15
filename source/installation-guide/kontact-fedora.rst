======================
Installation on Fedora
======================

1.  Install the Kontact repository configuration. Only use the Development repository for testing, never for production:

    For Fedora 25 (Twenty Five):

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`
        # :command:`wget https://obs.kolabsys.com/repositories/Kontact:/4.13/Fedora_25/Kontact:4.13.repo`

    For Fedora 25 (Twenty Five) Development:

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`
        # :command:`wget https://obs.kolabsys.com/repositories/Kontact:/4.13:/Development/Fedora_25/Kontact:4.13:Development.repo`

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

4.  Make sure there is no leftover configuration or data from previous akonadi installs. Please note that this will delete all your locally cached data and configuration! This step is not necessary if no other akonadi has been installed before, it is however a necessary step if an upstream version of Kontact/Akonadi was running on the system previously:

    .. parsed-literal::

        # :command:`rm -R ~/.kde/share/apps/akonadi_migration_agent`
        # :command:`rm -R ~/.kde/share/config/akonadi*`
        # :command:`rm -R ~/.local/share/akonadi`
        # :command:`rm -R ~/.config/akonadi`

5.  Install the Kolab Desktop Client (supply --allowerasing to allow the command to uninstall conflicting packages):

    .. parsed-literal::

        # :command:`dnf install kolab-desktop-client --allowerasing --refresh`

6.  To install additional spellchecking languages install the wanted hunspell-* packages:

    .. parsed-literal::

        # :command:`dnf install hunspell-de`

Continue to :ref:`settings-clientconfig-kontact`.
