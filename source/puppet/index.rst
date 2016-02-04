====================================
Configuration Management with Puppet
====================================

This article describes a scalable Puppet setup that allows serving more
than a single security domain from a single Puppet master server
infrastructure, in any of three default :term:`staging environments`.

.. NOTE::

    The packages referred to in this document are available in the
    Puppet add-on software repository to Kolab Enterprise 14.

.. rubric:: HOWTO Articles

.. toctree::
    :maxdepth: 2

    howto/bootstrap-puppet-server
    howto/working-with-staging-environments

.. rubric:: Module Documentation

.. toctree::
    :maxdepth: 1

    module/git
    module/kolab
    module/munin
    module/nagios
    module/puppet
    module/puppetdbquery
    module/selinux
    module/stdlib
    module/webserver
    module/yum

.. toctree::
    :hidden:

    howto/scale-puppet-environments 
