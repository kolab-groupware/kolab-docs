.. _howto_use_seafile_with_chwala:

HOWTO: Use Seafile with Chwala
==============================

`Seafile <http://seafile.com>`_ is GPL v3-licensed software designed to host files privately and securely on the Web, in a similar fashion as some popular proprietary solutions. As of Kolab version 3.4, Chwala (the file storage component of Kolab) can use Seafile as a backend to store files.

This document outlines the steps needed to interface Chwala with Seafile.

Prequisites
-----------

- Kolab Groupware, version 3.4 or later
- Seafile version 4 or later, running on a top level domain (``files.example.com`` in this guide)

In case the services reside on different hosts, the Seafile instance needs to be accessible via port 80/443 from the host running Kolab.


Configuring Seafile to interface with LDAP
------------------------------------------

As a first step, Seafile needs to be able to authenticate against Kolab's LDAP database. Locate the ``ccnet.conf`` file in the ``ccnet`` subdirectory of your Seafile root installation (for example, ``/home/seafile/ccnet/ccnet.conf``), and add the following lines at the bottom:

.. parsed-literal::

    [LDAP]
    HOST = ldap://localhost
    # Change the following to your primary domain base DN
    BASE = ou=People,dc=mydomain,dc=tld
    FILTER = &(objectclass=kolabinetorgperson)
    # Put in the details of the Kolab service account
    USER_DN = uid=kolab-service,ou=Special Users,dc=mydomain,dc=tld
    PASSWORD = <password of the Kolab service account>
    LOGIN_ATTR = mail

Restart Seafile by issuing ``/path/to/seafile/seafile-server-latest/seafile.sh restart``.

Configuring Roundcube to access Seafile
---------------------------------------

Once Seafile can authenticate against LDAP, integration can be configured with two different methods:

1. Using Seafile as an add-on to the existing storage.
2. Configure Seafile as pre-defined storage

The second method has the advantage of being set by default for all users, but it depends on the Seafile instance being always accessible. The first still relies on Kolab core components and is easier to set up, but requires users to manually add their Seafile storage.

.. warning:: In *both* cases, you will have to make **at least one login** to the Seafile instance for the integration to work.

Using Seafile as an add-on to the existing Kolab storage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Edit ``/etc/roundcubemail/config.inc.php`` as above, adding these lines:

.. parsed-literal::

    $config['fileapi_backend'] = 'kolab';
    $config['fileapi_drivers'] = ['seafile'];
    $config['fileapi_seafile_host'] = "files.example.com";
    $config['fileapi_seafile_ssl_verify_peer'] = false;
    $config['fileapi_seafile_ssl_verify_host'] = false;
    # Change the following basing on how much time you want data from Seafile cached
    $config['fileapi_seafile_cache'] = '14d';
    $config['fileapi_seafile_debug'] = false;

An additional step is required to access Seafile, that is, Chwala needs to be made aware of the additional storage. Access your Roundcube webmail and go to the Files component. Click on the gearbox icon and select *Add additional storage*. Fill in all the necessary details and click on OK. A new ``Seafile`` folder will be made available, pointing at your Seafile library.

Configure Seafile as pre-defined storage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. note:: In a previous version of this howto, it was sugested to change the ``fileapi_backend`` to ``seafilea``. This is no longer working and generates additional issues, like ignoring kolab's folder caching mechanics.

If you want to pre-define/configure for all our users you can configure a list of pre-defined sources. This can be your sole seafile instances or multiple private and public sources. For mor informations please check out the available `configuration <https://git.kolab.org/diffusion/C/browse/master/config/config.inc.php.dist>`_ options.

Edit ``/etc/roundcubemail/config.inc.php`` and add the following lines, adjusting them to match your setup:

.. parsed-literal::

    # kolab is the only supported backup
    $config['fileapi_backend'] = 'kolab';

    # disable optional storage addons
    $config['fileapi_drivers'] = [];

    # pre-define your seafile server
    $config['fileapi_sources'] = array(
        'Seafile' => array(
            'driver' => 'seafile',
            'host'   => 'files.example.com',
            'username' => '%u',
        )
    );

    # backend https calls
    $config['fileapi_seafile_ssl_verify_peer'] = false;
    $config['fileapi_seafile_ssl_verify_host'] = false;

    # Change the following basing on how much time you want data from Seafile cached
    $config['fileapi_seafile_cache'] = '14d';
    $config['fileapi_seafile_debug'] = false;

The next time you will try to access files in Roundcube, Kolab will attempt to authenticate with Seafile with the same username / password combination as your account and use Seafile as storage. In case of errors, change ``fileapi_seafile_debug`` to ``true`` and inspect Roundcube logs.

If you want to disable the usage of Kolab's default storage, where your files are stored within the imap backend, you can disable it at all using the following option.
.. parsed-literal::

    # Disable the default imap based file-storage.
    $config['fileapi_backend_storage_disabled'] = true;

Debugging
---------

In case of errors, set ``$config['fileapi_seafile_debug']`` to ``true`` and information on the Chwala-Seafile interactions will be recorded in ``/var/log/chwala/``.
