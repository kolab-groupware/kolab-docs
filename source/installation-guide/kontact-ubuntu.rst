.. _installation-guide-kontact-ubuntu14.04:

============================
Installation on Ubuntu 14.04
============================

#.  Add the following line to ``/etc/apt/sources.list.d/kolab.list``:

    .. parsed-literal::

        deb http://obs.kolabsys.com/repositories/Kontact:/4.13/Ubuntu_14.04/ /

#.  Download the release key:

    .. parsed-literal::

        # :command:`wget http://obs.kolabsys.com/repositories/Kontact:/4.13/Ubuntu_14.04/Release.key`

#.    Add key to valid keys:

    .. parsed-literal::

        # :command:`sudo apt-key add Release.key`

#.    Update the sources:

    .. parsed-literal::

        # :command:`sudo apt-get update`

#.    Install kolab-desktop-client:

    .. parsed-literal::

        # :command:`sudo apt-get install kolab-desktop-client`

#.    Start the Kolab Desktop Client:

    .. parsed-literal::

        # :command:`kontact`



Continue to :ref:`_settings-clientconfig-kontact`.
