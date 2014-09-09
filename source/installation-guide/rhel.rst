.. _installation-rhel:

========================================
Installation on Red Hat Enterprise Linux
========================================

.. NOTE::

    For the installation of the community edition on Red Hat Enterprise
    Linux, follow the :ref:`installation-centos` guide.

The installation of Kolab Groupware on Red Hat Enterprise Linux installs
a number of additional packages, from the Red Hat Enterprise Linux
subscribed repositories, the :term:`EPEL` software repository, and the
repositories for the Kolab Enterprise edition, provided by
`Kolab Systems AG <https://kolabsys.com>`_.

=================  =====  ========  ========  =================  =======
Installation Type  RHEL   EPEL      Kolab     Total to Install   Total
=================  =====  ========  ========  =================  =======
Basic Server          71   48 [2]_   56 [3]_                173      548
Minimal [1]_         197   48 [2]_   56 [3]_                299      548
=================  =====  ========  ========  =================  =======

These numbers may vary for your installation, as packages are updated
over time, and are for indicative purposes only.

.. WARNING::

    Follow the instructions below to **install Kolab Enterprise 13 for
    RHEL 6**.

    Kolab Enterprise 14 for RHEL 7 and RHEL 6 are in alpha state, as is
    Kolab Enterprise 13 for RHEL 7, and they are provided exclusively as
    a **technology preview** for integration partners and contributors.

    You must not install either of these technology previews unless you
    are specifically looking to contribute to them.

Installation Procedure
======================

1.  Ensure that the system is registered with the Red Hat Network, and
    is entitled to receive updates and use the *Optional* software
    repository.

    For more information on registering systems with the Red Hat
    Network, subscriptions, entitlements and support consult the
    vendor's product and service documentation.

    Kolab Systems provides a summary example to remind you, which is not
    supported by either party.

    .. NOTE::

        These examples refer to Red Hat Enterprise Linux 6, but equally
        apply to Red Hat Enterprise Linux 7.

    **Registration Example**

    .. parsed-literal::

        # :command:`subscription-manager register`
        Username: you@yours.com
        Password:
        The system has been registered with ID: ****

    **List Available Subscription Entitlements Example**

    .. NOTE::

        The results shown to you executing this command will differ.

    .. parsed-literal::

        # :command:`subscription-manager list --available`
        (...)
        Subscription Name: Red Hat Enterprise Linux Server, Premium (4 sockets) (Unlimited guests)
        **Pool ID**:           <32-character-pool-id>
        Available:         $x
        Suggested:         $y
        Service Level:     PREMIUM
        Service Type:      L1-L3
        Multi-Entitlement: No
        Ends:              MM/DD/YYYY
        System Type:       Physical
        (...)

    .. parsed-literal::

        # :command:`subscription-manager attach --pool=<32-character-pool-id>`
        Successfully attached a subscription for: Red Hat Enterprise Linux Server, Premium (4 sockets) (Unlimited guests)

    .. parsed-literal::

        # :command:`subscription-manager repos`
        (...)
        Repo ID:   rhel-6-server-optional-rpms
        Repo Name: Red Hat Enterprise Linux 6 Server - Optional (RPMs)
        Repo URL:  https://cdn.redhat.com/content/dist/rhel/server/6/$releasever/$basearch/optional/os
        Enabled:   0
        (...)

    Search for this repository configuration in
    :file:`/etc/yum.repos.d/redhat.repo`, and set ``enabled = 1``.

2.  Copy the client SSL certificate and key you have obtained from
    `Kolab Systems AG <https://kolabsys.com>`_ as per the instructions
    listed on [4]_, summarized here for your convenience:

    #.  Remove the passphrase from the SSL certificate key:

        .. parsed-literal::

            # :command:`openssl rsa -in /path/to/private.key \\
                -out /path/to/private.key.nopass`

    #.  Concatenate the certificate file and the new key file without
        passphrase:

        .. parsed-literal::

            # :command:`cat /path/to/public.crt /path/to/private.key.nopass \\
                > /path/to/mirror.kolabsys.com.client.pem`

    #.  Place the file :file:`mirror.kolabsys.com.ca.cert` in
        :file:`/etc/pki/tls/certs/`.

    #.  Place the file :file:`mirror.kolabsys.client.pem` in
        :file:`/etc/pki/tls/private/`, and correct the permissions:

        .. parsed-literal::

            # :command:`chown root:root /etc/pki/tls/private/mirror.kolabsys.com.client.pem`
            # :command:`chmod 640 /etc/pki/tls/private/mirror.kolabsys.com.client.pem`

3.  Install the `EPEL repository <http://fedoraproject.org/wiki/EPEL>`_
    configuration using the RPM package linked to from:

    *   `EPEL for RHEL 7`_

    *   `EPEL for RHEL 6`_

    .. parsed-literal::

        # :command:`rpm -Uhv http://url/to/epel-release.rpm`

4.  Obtain a copy of the GPG signature used to sign packages:

    For RHEL 7:

    .. parsed-literal::

        # :command:`wget https://ssl.kolabsys.com/maipo.asc`

    For RHEL 6:

    .. parsed-literal::

        # :command:`wget https://ssl.kolabsys.com/santiago.asc`

5.  Import this signature in to the RPM database:

    For RHEL 7:

    .. parsed-literal::

        # :command:`rpm --import maipo.asc`

    For RHEL 6:

    .. parsed-literal::

        # :command:`rpm --import santiago.asc`

6.  Download the Kolab Enterprise repository configuration package:

    For Kolab Enterprise 14 on RHEL 7:

    .. WARNING::

        Kolab Enterprise 14 for RHEL 7 is in alpha state, you must not
        install this version unless you are specifically looking to
        contribute to it.

    .. parsed-literal::

        # :command:`wget https://ssl.kolabsys.com/kolab-enterprise-14-for-el7.rpm`

    For Kolab Enterprise 14 on RHEL 6:

    .. WARNING::

        Kolab Enterprise 14 for RHEL 6 is in alpha state, you must not
        install this version unless you are specifically looking to
        contribute to it.

    .. parsed-literal::

        # :command:`wget https://ssl.kolabsys.com/kolab-enterprise-14-for-el6.rpm`

    For Kolab Enterprise 13 on RHEL 6:

    .. parsed-literal::

        # :command:`wget https://ssl.kolabsys.com/kolab-enterprise-13-for-el6.rpm`

7.  Verify the signature on the downloaded RPM package:

    .. parsed-literal::

        # :command:`rpm -K kolab-enterprise-13-for-el6.rpm`
        kolab-enterprise-13-for-el6.rpm: sha1 md5 OK

    .. WARNING::

        Do NOT install the repository configuration for Kolab Enterprise 13 from
        this package, should the verification of the package fail.

8.  Install the repository configuration:

    .. parsed-literal::

        # :command:`yum localinstall kolab-enterprise-13-for-el6.rpm`

9.  Install Kolab Enterprise:

    .. parsed-literal::

        # :command:`yum install kolab`

Continue to :ref:`install-setup-kolab`.

.. rubric:: Footnotes

.. [1]

    Notes for Minimal installations

    *   To use ``scp`` to copy over the certificates, you need to
        install the ``openssh-clients`` package, which is not installed
        on minimal OS installations by default.

    *   To use wget to obtain the signature export file and repository
        configuration RPM package(s), you need to install the ``wget``
        package, which is not installed on minimal OS installations by
        default.

        Alternatively, download the packages to a workstation and
        ``scp`` them over to the Kolab Groupware server system.

.. [2]

    Check the number of packages installed from the :term:`EPEL`
    repository with:
    :command:`rpm -qia | grep "Build Host" | grep "fedoraproject\.org" | wc -l`

.. [3]

    Check the number of packages installed from the Kolab Enterprise 13
    software repositories with:
    :command:`rpm -qva | grep kolab_13 | wc -l`

.. [4]

    https://support.kolabsys.com/Obtaining,_Renewing_and_Using_a_Client_SSL_Certificate#Using_a_Customer_or_Partner_Client_SSL_Certificate.

.. _EPEL for RHEL 6: http://download.fedoraproject.org/pub/epel/6/i386/repoview/epel-release.html
.. _EPEL for RHEL 7: http://download.fedoraproject.org/pub/epel/beta/7/x86_64/repoview/epel-release.html
