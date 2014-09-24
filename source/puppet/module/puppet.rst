.. _puppet-module-puppet:

=========================
Puppet Module: ``puppet``
=========================

The Puppet module allows you to manage both Puppet agents as well as
Puppet masters.

It also provides you with an opportunity to correctly manage multiple
security domains, for which the domain name space of each system is
used.

Managing Multiple Security Domains
==================================

To suggest that the security domains are completely separated and
isolated would be false.

Storeconfig and Exported Resources
==================================


Module Dependencies
===================

The :ref:`puppet-module-puppet` depends on the following Puppet modules:

*   :ref:`puppet-module-git`

*   :ref:`puppet-module-webserver`

And the ``stdlib`` module from Puppetlabs (available from Puppet Forge),
and the ``puppetdbquery`` module (from ``dalen``) available from Puppet
Forge.
