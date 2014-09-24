.. _puppet-module-nagios:

=========================
Puppet Module: ``nagios``
=========================

The Nagios module manages Nagios servers and clients, alongside plugins.

Module Classes
==============

``nagios::client::active``

    Installs, configures and starts NSCA.

``nagios::client::passive``

    Installs, configures and starts NRPE and ensures all available
    plugins are installed.

    This module sub-class also includes:

    .. parsed-literal::

        @@nagios_host { "$fqdn":
            alias => "$hostname",
            address => "$ipaddress",
            use => "generic-host",
            tag => [
                    "$domain",
                    "$environment"
                ]
        }

``nagios::server``

    Installs, configures and starts the Nagios service.

    At the configuration stage, this module sub-class also realizes
    exported resources Nagios_host and Nagios_service that are tagged
    with the NOC server's ``$domain``.

Module Definitions
==================

``nagios::plugin``

    Enable or disable a specific plugin. Intended to be used with
    plugins that are sourced from a central location.
