:tocdepth: 2

.. _puppet-module-kolab:

========================
Puppet Module: ``kolab``
========================

The Kolab module for Puppet allows the continued management of a Kolab
Groupware environment, by defining nodes as having a certain role within
the Kolab Groupware environment.

To configure the exact way an included ``kolab`` module class behaves,
the ``kolab`` module uses multiple parameterized classes.

.. seealso::

    *   :ref:`puppet-module-kolab-why-multiple-parameterized-classes`
    *   :ref:`puppet-module-kolab-configuration-parameters`
    *   :ref:`puppet-module-kolab-using-the-kolab-module`

Integration with Monitoring and Trending
========================================

Each role defined for a node participating in providing Kolab Groupware
services includes specific monitoring (with Nagios) and trending (with
Munin) plugins.

For Nagios, exported resources are used to allow a NOC system to
aggregate the associated resources and realize them.

For Munin, the inclusion of the classes in this module allow the
aggregation of graphs on the NOC server.

.. _puppet-module-kolab-module-classes:

Module Classes (or *Roles*)
===========================

``kolab::imap``

    A class defining virtual resources to be realized by individual
    sub-classes, and resources shared between all IMAP servers.

    Includes the following Munin plugins:

        *   :ref:`puppet-module-munin-plugin-cyrus-imapd`
        *   :ref:`puppet-module-munin-plugin-cyrus-imapd-mbox`
        *   :ref:`puppet-module-munin-plugin-cyrus-imapd-logins`

``kolab::imap::full``

    A full, standalone Cyrus IMAP server. Inherits ``kolab::imap``.

``kolab::imap::backend``

    A Cyrus IMAP backend server, such that this server holds IMAP
    mailbox payload (technically, a backend can function as a frontend
    in a unified Cyrus IMAP Murder topology).

    Inherits ``kolab::imap``.

``kolab::imap::frontend``

    A Cyrus IMAP frontend in a discrete Cyrus IMAP Murder topology.

    Inherits ``kolab::imap``.

``kolab::imap::mupdate``

    A Cyrus IMAP Master Update (mupdate) server in a discrete Cyrus IMAP
    Murder topology.

    Inherits ``kolab::imap``.

``kolab::ldap``

``kolab::mx``

    A generic mail exchanger.

``kolab::mx::amavisd``

    Adds anti-spam and anti-virus to a mail exchanger.

``kolab::mx::external``

    An Internet-facing mail exchanger.

``kolab::mx::external::inbound``

    An Internet-facing mail exchanger for inbound traffic.

``kolab::mx::external::outbound``

    An Internet-facing mail exchanger for outbound traffic.

``kolab::mx::internal``

    An internal mail exchanger.

``kolab::webserver``

    An webserver with all standard functionality included.

``kolab::webserver::activesync``

    A webserver dedicated to providing ActiveSync for mobile device
    synchronization.

    Merely includes ``kolab::webserver::syncroton``.

``kolab::webserver::chwala``

    A webserver dedicated to providing the Chwala file-cloud.

    Inherits ``kolab::webserver::common``.

``kolab::webserver::common``

    Commonly shared resources between ``kolab::webserver`` sub-classes.

``kolab::webserver::freebusy``

    A webserver dedicated to providing Free/Busy scheduling information.

    Inherits ``kolab::webserver::common``.

``kolab::webserver::hkccp``

    A webserver dedicated to the Hosted Kolab Customer Control Panel.

    Inherits ``kolab::webserver::common``.

``kolab::webserver::irony``

    A webserver dediciated to providing CalDAV, CardDAV and WebDAV
    functionality.

    Inherits ``kolab::webserver::common``.

``kolab::webserver::roundcubemail``

    A webserver dedicated to the Roundcube webmail interface.

    Inherits ``kolab::webserver::common``.

``kolab::webserver::syncroton``

    A webserver dedicated to providing ActiveSync for mobile device
    synchronization.

    Inherits ``kolab::webserver::common``.

``kolab::webserver::webadmin``

    A webserver dedicated to providing the Kolab Web Administration
    Panel user interface and API.

    Inherits ``kolab::webserver::common``.

``kolab::webserver::webmail``

    A wrapper class to install both ``kolab::webserver::roundcubemail``
    and ``kolab::webserver::chwala``.

``kolab::yum``

    A class to maintain the YUM repository configuration for staged
    environments.

``kolab::webserver::common``
============================

This class is shared between other ``kolab::webserver`` sub-classes, and
provides the basis for a webserver configuration.

It includes *Class["webserver"]* from :ref:`puppet-module-webserver`,
and configures commonly used virtual resources so that each individual
component can realize them, preventing collisions between duplicate
definitions.

Environment Stages and Package Version Locks
============================================

.. _puppet-module-kolab-configuration-parameters:

Configuration Parameters
========================

``kolab::params``
-----------------

The ``kolab::params`` class is a class commonly shared between all nodes
participating in servicing Kolab Groupware.

**imap_admin_login** (``cyrus-admin``)

    The administrative login for Cyrus IMAP.

    .. TODO::

        A separate set of credentials should be supplied for wallace,
        freebusy, replication and proxy for the purposes of maintaining
        a more well-informed audit trail.

**imap_admin_password** (``undef``)

    The password for the ``imap_admin_login``.

**imap_enable_notify** (``undef``)

    Enable the :manpage:`notifyd(8)` service.

**imap_enable_pop** (``undef``)

    Enable the :manpage:`pop3d(8)` services.

**imap_enable_ptloader** (``undef``)

    Enable the ptloader services.

**imap_hostname** (``$fqdn``)

    The hostname to use to connect to IMAP.

    While this setting applies to many services including the Kolab
    daemon, Wallace and Roundcube webmail, should the IMAP server for
    each of these services need to be different, we recommend you use
    a split DNS horizon.

**imap_port** (``993``)

    The port to use when connecting to IMAP.

**imap_scheme** (``imaps``)

    The scheme to use. Using ``imaps`` translates to configuring a
    prefix of ``ssl://`` where appropriate, otherwise means ``tls://``.

**imap_storage_partitions** (``[ "default" ]``)

    Define one or more storage partitions.

    .. NOTE::

        The inclusion of the "default" partition is mandatory.

    Example usage::

        class { "kolab::params":
            imap_storage_partitions => [ "default", "archive" ]
        }

**imap_storage_meta_base_path** (``undef``)

    Undefined by default, allows the separation of IMAP spool metadata
    and message payload.

    If defined, ``imap_storage_meta_base_path`` must be set to an
    absolute path that exists with 0750 permissions for the cyrus user
    and mail group.

    The ``kolab`` module (or actually, Puppet) cannot ensure the
    directory exists, unless there is a guarantee that the parent
    directory exists -- only :file:`/` is guaranteed.

    Example usage::

        class { "kolab::params":
            imap_storage_meta_base_path => "/srv/imap/meta"
        }

**imap_storage_spool_base_path** (``/var/spool/imap``)

    Sets the root of the IMAP spool partitions.

    Under the directory specified here, directories are created for each
    partition defined (with a mandated minimum list including
    ``default``).

    Example usage::

        class { "kolab::params":
            imap_storage_spool_base_path => "/srv/imap/spool"
        }

    results in::

        File["/srv/imap/spool/default/"]

**imap_configdir** (``/var/lib/imap/``)

    The :manpage:`imapd.conf(5)` ``configdir`` setting.

    This directory normally contains databases among which
    ``mailboxes.db`` and ``annotations.db``.

    Because of backup processes, it may be desirable to have the default
    spool partition and ``configdir`` located under the same directory
    hierarchy off of the same logical volume mount.

    Example usage::

        class { "kolab::params":
            imap_configdir => "/srv/imap/config",
            imap_storage_spool_base_path => "/srv/imap/spool"
        }

**imap_duplicate_db_path** (``undef``)

    The ``deliver.db`` database file used to determine whether new
    message arrivals are duplicates (to be suppressed) contains a few
    days worth of delivery information.

    However, it is not critical for operations and may simply be
    discarded in case of a system reboot.

    If performance of message delivery is more important than the
    suppression of duplicates (which are a rather rare occurrence), then
    this file may be located under a directory hierarchy mounted off of
    ``tmpfs``.

**imap_ptscache_db_path** (``undef``)

    The ``ptscache.db`` database file caches information related to LDAP
    queries performed to find target result attributes for the process
    of canonification, and additional authorization information such as
    a user's group memberships or roles.

    This database can be discarded when a node reboots, and might
    therefore also live in a directory hierarchy mounted off of
    ``tmpfs``.

**imap_sievedir** (``undef``)

    Unless specifically required, keep this to a default value of
    ``${configdir}/sieve``.

**imap_socket_path** (``/var/lib/imap/socket``)

    The path to where socket files are stored.

**imap_statuscache_db_path** (``undef``)

    The ``statuscache.db`` database file is undocumented.

**imap_temp_path** (``undef``)

    The absolute path to a location Cyrus IMAP can use to store
    temporary files.

**imap_tlscache_db_path** (``undef``)

    The ``tls_sessions.db`` is a database file that maintains previously
    negotiated TLS sessions, allowing those sessions to be resumed at a
    later time.

    This database can be discarded when a node reboots, and might
    therefore also live in a directory hierarchy mounted off of
    ``tmpfs``.

**kolab_version_name** (``kolab_14``)

    The version name of the Kolab Groupware product stream to use.

    Possible values include:

        *   ``kolab_14`` (the default)
        *   ``kolab_13``
        *   ``kolab_3_3``

**kolab_primary_domain** (``$domain``)

    The primary domain for the Kolab Groupware deployment.

    Corresponds to the ``primary_domain`` setting in the ``[kolab]``
    section of :manpage:`kolab.conf(5)`.

**kolab_default_locale** (``en_US``)

    The default locale for the environment.

    Corresponds to the setting ``default_locale`` in the ``[kolab]``
    section of :manpage:`kolab.conf(5)`.

**kolab_policy_uid** (``%(surname)s.lower()``)

    The UID policy for Kolab.

    Corresponds to the setting ``policy_uid`` in the ``[kolab]`` section
    of :manpage:`kolab.conf(5)`.

**memcache_hosts** (``undef``)

    An array of hosts that serve **memcached** to be used for memcache-
    capable software applications unless specific memcached host
    addresses are defined for that service.

**webclient_memcache_hosts** (``$kolab::params::memcache_hosts``)

    An array of hosts that serve **memcached** to be used solely for
    the webmail client software.

**webadmin_memcache_hosts** (``$kolab::params::memcache_hosts``)

    An array of hosts that serve **memcached** to be used solely for
    the webadmin client software.

**ldap_scheme** (``ldap``)

    The scheme name to use to connect to LDAP, where URIs are used.

    Can be either of ``ldap`` or ``ldaps``.

**ldap_hostname** (``$fqdn``)

    The host address to use to connect to the LDAP service.

**ldap_port** (``389``)

    The port to use to connect to the LDAP service.

**ldap_domain_base_dn** (``cn=kolab,cn=config``)

    The base dn for domain objects.

**roundcubemail_db_dsnw** (``mysqli://roundcube:password@localhost/roundcube``)

**roundcubemail_db_dsnr** (``undef``)

**ldap_bind_dn** (``cn=Directory Manager``)

    The login for the administrative credentials to use when binding to
    LDAP.

    .. NOTE::

        Note that you are encouraged to provide the Kolab Groupware
        environment with credentials lesser privileged than
        "cn=Directory Manager", but that certain functionality we have
        to make available in a standard deployment requires the use of
        these superuser credentials.

**ldap_bind_pw** (``undef``)

    The password for the administrative credentials used to bind to
    LDAP.

**ldap_root_dn** (``undef``)

    The root DN.

**ldap_service_bind_dn** (``undef``)

    The bind DN for services, normally
    ``uid=kolab-service,ou=Special Users,${ldap_root_dn}``

**ldap_service_bind_pw** (``undef``)

    The bind password for services.

**kolab_cache_sql_uri** (``mysql://kolab:Welcome2KolabSystems@localhost/kolab``)

    The URI to a SQL location to use for caching.

**kolab_webadmin_sql_uri** (``mysql://kolab:Welcome2KolabSystems@localhost/kolab``)

    The URI to a SQL location to use for the web administration panel
    configuration.

**roundcubemail_des_key** (``rcmail-!24ByteDESkey*Str``)

    The DES key used by the Roundcube webmail program to encrypt
    session-related information.

**smtp_scheme** (``undef``)

    The scheme to use when connecting to SMTP.

**smtp_hostname** (``$fqdn``)

    The host address to use when connecting to SMTP.

**smtp_port** (``587``)

    The port to use when connecting to SMTP.

``kolab::params::imap``
-----------------------

**imap_storage_partitions** (``$kolab::params::imap_storage_partitions``)

    Override the IMAP storage partitions set using ``kolab::params``.

**imap_storage_meta_base_path** (``$kolab::params::imap_storage_meta_base_path``)

    Override the IMAP metadata base path set using ``kolab::params``.

**imap_storage_spool_base_path** (``$kolab::params::imap_storage_spool_base_path``)

    Override the IMAP mail spool base path set using ``kolab::params``.

**imap_configdir** (``$kolab::params::imap_configdir``)

    Override the ``configdirectory`` setting in :manpage:`imapd.conf(5)`
    set using ``kolab::params``.

    .. NOTE::

        So far this has not yet worked in practice.

**imap_duplicate_db_path** (``$kolab::params::imap_duplicate_db_path``)

    Override the path to ``deliver.db`` set using ``kolab::params``.

**imap_ptscache_db_path** (``$kolab::params::imap_ptscache_db_path``)

    Override the path to ``ptscache.db`` set using ``kolab::params``.

**imap_sievedir** (``$kolab::params::imap_sievedir``)

    Override the Sieve directory set using ``kolab::params``.

**imap_socket_path** (``$kolab::params::imap_socket_path``)

    Override the directory used to store socket files set using
    ``kolab::params``.

**imap_statuscache_db_path** (``$kolab::params::imap_statuscache_db_path``)

**imap_temp_path** (``$kolab::params::imap_temp_path``)

**imap_tlscache_db_path** (``$kolab::params::imap_tlscache_db_path``)

.. TODO::

    #.  Add a setting ``imap_proc_path``.
    #.  Add a setting ``webadmin_api_memcache_hosts``
    #.  Add a setting ``hkccp_memcache_hosts``

.. _puppet-module-kolab-using-the-kolab-module:

Using the Kolab Module
======================

We strongly encourage you wrap the individual ``kolab`` module classes
with some of your own, in order to share certain configuration
information between multiple nodes, but not share all information with
all of them, and in order to allow divergence (in terms of development).

In the simplest form, going with all defaults, the class structure you
might want to use looks as follows:

.. graphviz::

    digraph {
            rankdir = LR;
            splines = true;
            overlab = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11];
            node [shape=record, fontname=Calibri, fontsize=11, style=filled];

            "imapb01.example.org" [color="#EEFFEE"];
            "imapf01.example.org" [color="#EEFFEE"];

            subgraph cluster_example_org_kolab {
                    label = "Class['example_org_kolab']";
                    style = filled;

                    "example_org_kolab::common" [color="#EEFFEE"];
                    "example_org_kolab::imap" [color="#EEFFEE"];
                    "example_org_kolab::imap::backend" [color="#EEFFEE"];
                    "example_org_kolab::imap::frontend" [color="#EEFFEE"];

                    "example_org_kolab::imap::backend" -> "example_org_kolab::imap" [label="inherits"];
                    "example_org_kolab::imap::frontend" -> "example_org_kolab::imap" [label="inherits"];
                    "example_org_kolab::imap" -> "example_org_kolab::common" [label="inherits"];
                }

            subgraph cluster_module_kolab {
                    label = "Kolab Module";

                    "kolab::imap::backend" [color="#EEEEFF"];
                    "kolab::imap::frontend" [color="#EEEEFF"];
                    "kolab::params" [color="#EEEEFF"];

                    "Package['cyrus-imapd']" [color="#EEEEFF"];

                }

            "example_org_kolab::common" -> "kolab::params" [label="configures"];

            "imapb01.example.org" -> "example_org_kolab::imap::backend" [label="includes"];
            "example_org_kolab::imap::backend" -> "kolab::imap::backend" [label="includes"];

            "imapf01.example.org" -> "example_org_kolab::imap::frontend" [label="includes"];
            "example_org_kolab::imap::frontend" -> "kolab::imap::frontend" [label="includes"];

            "kolab::imap::backend" -> "Package['cyrus-imapd']" [label="installs"];
            "kolab::imap::frontend" -> "Package['cyrus-imapd']" [label="installs"];

            "kolab::params" -> "Package['cyrus-imapd']" [label="sets version for"];
        }

You might wonder why the green parts (yours) need to be so large, so
lets look under the hood and apply some differentiation between IMAP
frontends and backends.

Suppose that, for example, both types of IMAP servers require a
different ``configdir`` setting in :manpage:`imapd.conf(5)`.

The ``kolab::params`` class is already configured by the parameterized
inclusion of ``example_org_kolab::common``, the class you use to share
settings between all nodes related to Kolab Groupware services.

The frontend-, backend- and mupdate-specific classes would need to
break the inheritance of the common class, and each instantiate
``kolab::params`` themselves, individually. Because your other
functional components would still use the common class, this duplicates
instantiating ``kolab::params`` times 4, for 3 environments each.

Therefore each ``example_org_kolab::imap`` sub-class is to instantiate a
parameterized sub-class of ``kolab::params``, called
``kolab::params::imap``. This sub-class inherits ``kolab::params``, so
that you still have to configure those settings only once, but allow you
to configure some additional, IMAP-server specific settings.

The same picture as before now looks a little bit more complex:

.. graphviz::

    digraph {
            rankdir = LR;
            splines = true;
            overlab = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11];
            node [shape=record, fontname=Calibri, fontsize=11, style=filled];

            "imapb01.example.org" [color="#EEFFEE"];
            "imapf01.example.org" [color="#EEFFEE"];

            subgraph cluster_example_org_kolab {
                    label = "Class['example_org_kolab']";
                    style = filled;

                    "example_org_kolab::common" [color="#EEFFEE"];

                    "example_org_kolab::imap" [color="#EEFFEE"];
                    "example_org_kolab::imap::backend" [color="#EEFFEE"];
                    "example_org_kolab::imap::frontend" [color="#EEFFEE"];
                }

            subgraph cluster_module_kolab {
                    label = "Kolab Module";

                    "kolab::imap::backend" [color="#EEEEFF"];
                    "kolab::imap::frontend" [color="#EEEEFF"];
                    "kolab::params" [color="#EEEEFF"];
                    "kolab::params::imap" [color="#EEEEFF"];

                    "File['/etc/imapd.conf']" [color="#EEEEFF"];
                }

            "example_org_kolab::common" -> "kolab::params" [label="configures"];

            "imapb01.example.org" -> "example_org_kolab::imap::backend" [label="includes"];
            "example_org_kolab::imap::backend" -> "example_org_kolab::imap" [label="inherits"];
            "example_org_kolab::imap" -> "example_org_kolab::common" [label="inherits"];
            "example_org_kolab::imap::backend" -> "kolab::params::imap" [label="configures"];
            "example_org_kolab::imap::backend" -> "kolab::imap::backend" [label="includes"];

            "imapf01.example.org" -> "example_org_kolab::imap::frontend" [label="includes"];
            "example_org_kolab::imap::frontend" -> "example_org_kolab::imap" [label="inherits"];
            "example_org_kolab::imap::frontend" -> "kolab::params::imap" [label="configures"];
            "example_org_kolab::imap::frontend" -> "kolab::imap::frontend" [label="includes"];

            "kolab::imap::backend" -> "File['/etc/imapd.conf']" [label="installs"];
            "kolab::imap::frontend" -> "File['/etc/imapd.conf']" [label="installs"];

            "kolab::params::imap" -> "kolab::params" [label="inherits"];
            "kolab::params::imap" -> "File['/etc/imapd.conf']" [label="sets configdir"];
            "kolab::params" -> "File['/etc/imapd.conf']" [label="configures"];
        }

Add to this picture the following considerations:

*   A deployment does not necessarily consist of homogeneous operating
    systems and operating system versions.

    Some systems may run CentOS 6, others RHEL 6, and perhaps yet some
    others RHEL 7.

    Even if this is not the day-to-day, each deployment will transition,
    sooner or later, therefore creating a hybrid environment (or worse).

*   A deployment is not necessarily comprised of systems all running the
    exact same Kolab Enterprise version. Some systems may happily
    continue to run a functional component based on Kolab Enterprise 13,
    while perhaps the web- or IMAP servers have moved on to run
    Kolab Enterprise 14.

    Again even if this is not the day-to-day, each deployment will
    transition, sooner or later.

*   The reproducibility of a system you have in production today,
    whether for the purposes of recovery or capacity increase, depends
    on your ability to not only produce a system, but have that system
    be maintained using the exact same package versions as the other
    systems in production.

While Puppet is intended to describe the desired state of individual
nodes, and the desired state of so many nodes across and even within
deployments may differ so much, the picture of the internals of the
``kolab`` module look yet again a little different from the previous
diagram:

.. graphviz::

    digraph {
            splines = true;
            overlab = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11];
            node [shape=record, fontname=Calibri, fontsize=11, style=filled];

            "imapf01.example.org" [color="#EEFFEE"];
            "imapb01.example.org" [color="#EEFFEE"];
            "imapm01.example.org" [color="#EEFFEE"];

            subgraph cluster_example_org_kolab {
                    label = "Class['example_org_kolab']";
                    style = filled;

                    "example_org_kolab::common" [color="#EEFFEE"];

                    "example_org_kolab::imap" [color="#EEFFEE"];
                    "example_org_kolab::imap::backend" [color="#EEFFEE"];
                    "example_org_kolab::imap::frontend" [color="#EEFFEE"];
                    "example_org_kolab::imap::mupdate" [color="#EEFFEE"];
                }

            subgraph cluster_module_kolab {
                    label = "Kolab Module";

                    "kolab::common" [color="#EEEEFF"];
                    "kolab::imap" [color="#EEEEFF"];
                    "kolab::imap::backend" [color="#EEEEFF"];
                    "kolab::imap::frontend" [color="#EEEEFF"];
                    "kolab::imap::mupdate" [color="#EEEEFF"];
                    "kolab::params" [color="#EEEEFF"];
                    "kolab::params::imap" [color="#EEEEFF"];
                    "kolab::pkg" [color="#EEEEFF"];
                    "kolab::pkg::${os}" [color="#EEEEFF"];
                    "kolab::pkg::${os}::${osname}" [color="#EEEEFF"];
                    "kolab::pkg::${os}::${osname}::${environment}" [color="#EEEEFF"];
                    "kolab::pkg::${os}::${osname}::${environment}::${kolab_version}" [color="#EEEEFF"];
                    "kolab::yum" [color="#EEEEFF"];

                    "File['/etc/imapd.conf']" [color="#EEEEFF"];
                    "Package['cyrus-imapd']" [color="#EEEEFF"];

                    "File['/etc/imapd.conf']" -> "Package['cyrus-imapd']" [label="requires"];

                }

            "example_org_kolab::common" -> "kolab::params" [label="configures"];

            "imapb01.example.org" -> "example_org_kolab::imap::backend" [label="includes"];
            "example_org_kolab::imap::backend" -> "example_org_kolab::imap" [label="inherits"];
            "example_org_kolab::imap" -> "example_org_kolab::common" [label="inherits"];
            "example_org_kolab::imap::backend" -> "kolab::params::imap" [label="configures"];
            "example_org_kolab::imap::backend" -> "kolab::imap::backend" [label="includes"];

            "imapf01.example.org" -> "example_org_kolab::imap::frontend" [label="includes"];
            "example_org_kolab::imap::frontend" -> "example_org_kolab::imap" [label="inherits"];
            "example_org_kolab::imap::frontend" -> "kolab::params::imap" [label="configures"];
            "example_org_kolab::imap::frontend" -> "kolab::imap::frontend" [label="includes"];

            "imapm01.example.org" -> "example_org_kolab::imap::mupdate" [label="includes"];
            "example_org_kolab::imap::mupdate" -> "example_org_kolab::imap" [label="inherits"];
            "example_org_kolab::imap::mupdate" -> "kolab::params::imap" [label="configures"];
            "example_org_kolab::imap::mupdate" -> "kolab::imap::mupdate" [label="includes"];

            "kolab::params::imap" -> "kolab::params" [label="inherits"];

            "kolab::imap::backend" -> "kolab::imap" [label="inherits"];
            "kolab::imap::frontend" -> "kolab::imap" [label="inherits"];

            "kolab::imap" -> "Package['cyrus-imapd']" [label="defines"];
            "kolab::imap::backend" -> "Package['cyrus-imapd']" [label="realizes"];
            "kolab::imap::backend" -> "File['/etc/imapd.conf']" [label="realizes"];
            "kolab::imap::frontend" -> "Package['cyrus-imapd']" [label="realizes"];
            "kolab::imap::frontend" -> "File['/etc/imapd.conf']" [label="realizes"];
            "kolab::imap::mupdate" -> "Package['cyrus-imapd']" [label="realizes"];
            "kolab::imap::mupdate" -> "File['/etc/imapd.conf']" [label="realizes"];

            "kolab::imap" -> "kolab::common" [label="inherits"];
            "kolab::common" -> "kolab::params" [label="inherits"];

            "kolab::common" -> "kolab::pkg" [label="includes"];
            "kolab::common" -> "kolab::yum" [label="includes"];
            "kolab::pkg" ->
            "kolab::pkg::${os}" ->
            "kolab::pkg::${os}::${osname}" ->
            "kolab::pkg::${os}::${osname}::${environment}" ->
            "kolab::pkg::${os}::${osname}::${environment}::${kolab_version}" [label="includes"];

            "kolab::pkg::${os}::${osname}::${environment}::${kolab_version}" -> "kolab::params" [label="configures"];

            "kolab::params::imap" -> "File['/etc/imapd.conf']" [label="sets configdir"];
            "kolab::params" -> "File['/etc/imapd.conf']" [label="configures"];
            "kolab::params" -> "Package['cyrus-imapd']" [label="sets version for"];
        }

Example ``example_org_kolab`` Class
===================================

In this example class, we re-iterate how it is built up, and why.

First, the bare bones of it all:

.. parsed-literal::

    # The module class wrapper.
    class example_org_kolab {

        # The common class, that includes some basic configuration
        # information shared across all (most) Kolab nodes.
        class common inherits example_org_kolab { }

        # A container class for all things IMAP.
        class imap inherits common {
        }
    }

Next, we populate some of the information (not all of the relevant
information, for that see later on):

.. parsed-literal::

    class example_org_kolab {
        class common inherits example_org_kolab {
            class { "kolab::params":
                imap_admin_login => "cyrus-admin",
                imap_admin_password => "password"
            }
        }

        class imap inherits common {
            include kolab::imap::full
        }
    }

This gives us a base structure so that a node manifest might look as
follows:

.. parsed-literal::

    node 'imap.example.org' {
        include example_org_kolab::imap
    }

The structure allows us to distinguish certain parameter values between
environments:

.. parsed-literal::

    class example_org_kolab {
        class common inherits example_org_kolab {
            case $environment {
                "development": {
                    class { "kolab::params":
                        imap_admin_login => "cyrus-admin",
                        imap_admin_password => "password",
                        (...)
                    }
                }
                "testing": {
                    class { "kolab::params":
                        imap_admin_login => "cyrus-admin",
                        imap_admin_password => "anotherpassword",
                        (...)
                    }
                }
                "production": {
                    class { "kolab::params":
                        imap_admin_login => "cyrus-admin",
                        imap_admin_password => "verysecretpassword",
                        (...)
                    }
                }
            }
        }

        class imap inherits common {
            include kolab::imap::full
        }
    }

Or, alternatively:

.. parsed-literal::

    class example_org_kolab {
        class common inherits example_org_kolab {
            class { "kolab::params":
                imap_admin_login => "cyrus-admin",
                imap_admin_password => $environment ? {
                    "development" => "password",
                    "testing" => "anotherpassword",
                    "production" => "verysecretpassword"
                }
            }
        }

        class imap inherits common {
            include kolab::imap::full
        }
    }

However, there are reasons to do it the way it was done the first time
around:

*   Instead of defining ``Class['kolab::params']``, include a class that
    comes from a file external to ``example_org_kolab`` class
    definition (and hide the actual value from prying eyes).

*   Not all environment stages need to contain all values for all
    parameters.

Sub-classing ``example_org_kolab`` further, to wrap individual more
specific roles might give you something like this:

.. parsed-literal::

    class example_org_kolab {
        class common inherits example_org_kolab {
            case $environment {
                "development": {
                    class { 'kolab::params':
                        imap_admin_login => "cyrus-admin",
                        imap_admin_password => "somepass",
                        ldap_domain_base_dn => "ou=Domains,dc=example,dc=org",
                        imap_enable_notify => undef,
                        imap_enable_pop => true,
                        imap_enable_ptloader => true,
                        imap_hostname => "imap.example.org",
                        imap_port => 993,
                        imap_scheme => "imaps",
                        imap_socket_path => "/var/lib/imap/socket",
                        kolab_cache_sql_uri => "mysql://kolab:somepass@mysql-write.example.org/kolab_cache",
                        ldap_bind_dn => "cn=Directory Manager",
                        ldap_bind_pw => "somepass",
                        ldap_hostname => "ldap.example.org",
                        ldap_port => 389,
                        ldap_root_dn => "dc=example,dc=org",
                        ldap_service_bind_dn => "uid=kolab-service,ou=Special Users,dc=example,dc=org",
                        ldap_service_bind_pw => "somepass",
                        memcache_hosts => [ 'memc.example.org:11211' ],
                        roundcubemail_db_dsnw => "mysqli://roundcube:somepass@mysql-write.example.org/roundcube",
                        roundcubemail_db_dsnr => "mysqli://roundcube:somepass@mysql-read.example.org/roundcube",
                        roundcubemail_des_key => "somestringthatis24chars.",
                        smtp_hostname => "smtp.example.org",
                        smtp_port => 587
                    }
                }
                "testing": {
                    (...)
                }
                "production": {
                    (...)
                }
            }
        }


    class imap inherits common {
        class backend inherits imap {
            class { "kolab::params::imap":
                    imap_configdir => "/srv/imap/config",
                    imap_duplicate_db_path => "/var/tmp/cyrus-imapd/deliver.db",
                    imap_ptscache_db_path => "/var/tmp/cyrus-imapd/ptscache.db",
                    imap_sievedir => "/srv/imap/config/sieve/",
                    imap_socket_path => "/srv/imap/config/socket",
                    imap_statuscache_db_path => "/var/tmp/cyrus-imapd/statuscache.db",
                    imap_storage_partitions => [ "default", "archive" ],
                    imap_storage_meta_base_path => "/srv/imap/meta",
                    imap_storage_spool_base_path => "/srv/imap/spool",
                    imap_temp_path => "/var/tmp/cyrus-imapd/",
                    imap_tlscache_db_path => "/var/tmp/cyrus-imapd/tls_sessions.db"
                }

            file { "/srv/imap/":
                ensure => directory
            }

            file { [
                    "/srv/imap/config/",
                    "/srv/imap/meta/",
                    "/srv/imap/spool/"
                ]:
                ensure => directory,
                owner => "cyrus",
                group => "mail",
                mode => 750,
                require => Mount["/srv/imap"],
                notify => [
                        Exec["_usr_lib_cyrus-imapd_mkimap"],
                        Service["cyrus-imapd"]
                    ]
            }

            file { "/srv/imap/config/proc/":
                ensure => "/var/tmp/cyrus-imapd/proc/",
                force => true,
                links => manage,
                noop => false,
                require => File["/var/tmp/cyrus-imapd/proc/"],
                notify => Service["cyrus-imapd"]
            }

            file { "/var/tmp/cyrus-imapd/":
                ensure => directory,
                owner => "cyrus",
                group => "mail",
                mode => 750,
                noop => false,
                notify => Service["cyrus-imapd"]
            }

            file { "/var/tmp/cyrus-imapd/proc/":
                ensure => directory,
                owner => "cyrus",
                group => "mail",
                mode => 750,
                noop => false,
                require => Mount["/var/tmp/cyrus-imapd"],
                notify => Service["cyrus-imapd"]
            }

            mount { "/srv/imap":
                atboot => true,
                device => "/dev/vg_imap/lv_imap",
                options => "defaults",
                fstype => "ext4",
                remounts => true,
                ensure => mounted,
                noop => false,
                require => File["/srv/imap/"],
                notify => Service["cyrus-imapd"]
            }

            mount { "/var/tmp/cyrus-imapd":
                atboot => true,
                device => "tmpfs",
                options => "defaults",
                fstype => "tmpfs",
                remounts => true,
                ensure => mounted,
                noop => false,
                require  => File["/var/tmp/cyrus-imapd/"],
                notify => Service["cyrus-imapd"]
            }

            include kolab::imap::backend
        }
    }

    node 'imapb01.example.org' {
        include example_org_kolab::imap::backend
    }
