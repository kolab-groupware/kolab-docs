.. _installation-ucs-3-enterprise-13:

====================================================================
Installation of Kolab Enterprise 13 on Univention Corporate Server 3
====================================================================

.. IMPORTANT::

    There are **multiple versions** of Kolab for UCS. Make sure you
    choose the correct version for your requirements.

App Center Edition
==================

An evaluation version of Kolab is available in the Univention App
Center. This edition does *not* provide you with bugfix, security or
enhancement updates.

Kolab Enterprise 13
===================

To install the Enterprise edition under Kolab Systems support, execute
the following process:

#.  Configure your UCS system to obtain the repository configuration packages:

    .. parsed-literal::

        # :command:`ucr set \\
            repository/online/component/kolab-13=enabled \\
            repository/online/component/kolab-13/description="Kolab Enterprise 13 Installation Repository" \\
            repository/online/component/kolab-13/server="mirror.kolabsys.com" \\
            repository/online/component/kolab-13/prefix="pub/ucs" \\
            repository/online/component/kolab-13/version="current" \\
            repository/online/component/kolab-13/parts="maintained"`

#.  Install the client certificate you have obtained from Kolab Systems in the
    following location:

    .. parsed-literal::

        /etc/apt/certs/mirror.kolabsys.com.client.pem

    If you do not have an SSL client certificate from Kolab Systems, contact
    sales@kolabsys.com.

#.  Install the repository configuration package:

    .. parsed-literal::

        # :command:`univention-install kolab-13-enterprise-release`

    When the installation complains the package cannot be verified, type [y] and
    [Enter] to continue:

    .. parsed-literal::

        WARNING: The following packages cannot be authenticated!
          kolab-13-enterprise-release
        Install these packages without verification [y/N]? y

#.  Install kolab:

    .. parsed-literal::

        # :command:`univention-install kolab`

.. IMPORTANT::

    The Kolab Groupware packages for Univention Corporate Server are configured
    automatically. There is no need to run any setup.
