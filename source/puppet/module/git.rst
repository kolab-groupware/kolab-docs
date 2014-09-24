.. _puppet-module-git:

======================
Puppet Module: ``git``
======================

The ``git`` module for Puppet can manage central GIT repository hosts
along with the GIT repositories on that host, and can maintain clones of
GIT repositories.

Both these parts are used by the :ref:`puppet-module-puppet`.

Creating a GIT Repository
=========================

Creating a repository is performed by the ``git::repository`` resource
definition, with the following parameters:

**description** (``false``)

    A description for the GIT repository, which ends up in
    :file:`.git/description`.

    If not set, or set to ``false``, the :file:`.git/description` is
    left untouched.

**group** (``root``)

    The name of the (POSIX) group owner.

**localtree** (:file:`/srv/git/`)

    The parent directory of the new GIT repository, with a default of
    :file:`/srv/git/`.

**owner** (``root``)

    The name of the (POSIX) owner.

**prefix** (``false``)

    Set a prefix to the actual GIT repository location, such that a
    the filesystem path to the repository is unique.

**public** (``false``)

    If the repository is public, the permissions are set such that the
    xinetd ``git-daemon`` running under the unprivileged ``nobody``
    account can read the contents of the repository.

    Set this to ``false`` to disallow the ``nobody`` account to read any
    contents of the repository, therefore effectively disallowing
    anonymous access over the ``git://`` protocol.

**real_name** (``false``)

    Because resources can only be instantiated with unique names or
    titles, you can set ``real_name`` to a value that, if used as the
    name or title, would otherwise cause a duplicate definition.

**recipients** (``false``)

    A list of recipient email addresses, that should be notified when a
    commit is made.

    If not set, or set to ``false``, no notifications will be sent.

**shared** (``false``)

    A boolean value, this describes whether the GIT repository is shared
    (``true``) or private (``false``).

    The net result of setting this to true is the equivalent of
    executing the following commands:

    .. parsed-literal::

        # :command:`find $localtree/$name/ -type d -exec chmod g+rws {} \;`
        # :command:`find $localtree/$name/ -type f -exec chmod g+rw {} \;`

    The xinetd ``git-daemon`` service runs under the ``nobody`` account,
    and this boolean controls whether the ``nobody`` account should be
    allowed read access to the GIT repository.

**symlink_prefix** (``false``)

    The symbolic link in :file:`/git/`, a flat directory hierarchy,
    should be prefixed with the ``symlink_prefix``.

**symbolic_link** (``true``)

    Provide a symbolic link in :file:`/git/` to the new GIT repository
    (in ``$localtree``), so that users that use the SSH protocol do not
    have to use ``/srv/git/`` to get to the repository.

Example GIT repository for libkolabxml::

    git::repository { "libkolabxml.git":
        localtree => "/srv/git/",
        shared => true,
        public => true,
        owner => "vanmeeuwen",
        group => "git-kolab.org-developers",
        description => "libkolabxml",
        recipients => [
                "commits@lists.kolab.org"
            ]
    }

Example set of GIT repositories for Puppet modules::

    git::repository { [
            "git",
            "puppet",
            "webserver",
            "yum"
        ]:
        localtree => "/srv/git/",
        shared => true,
        public => true,
        owner => "vanmeeuwen",
        group => "git-kolab.org-developers",
        symlink_prefix => "puppet-module-",
        prefix => "puppet-",
        description => "Puppet Module",
        recipients => [
                "commits@lists.kolab.org"
            ]
    }

Cloning a GIT Repository
========================

To create a clone of a GIT repository, use the ``git::clone`` resource
definition.

The following parameters are available:

**source**

.. parsed-literal::

    define clone(   $source,
                    $localtree = "/srv/git/",
                    $real_name = false,
                    $branch = false,
                    $mirror = false) {


    git::clone { "modules/$branch/$real_name":
        source => $url ? {
            false => $base_url ? {
                false => "$url",
                default => $module_prefix ? {
                    false => $module_name ? {
                        false => "$base_url/$name",
                        default => "$base_url/$module_name"
                    },
                    default => $module_name ? {
                        false => "$base_url/$module_prefix-$name",
                        default => "$base_url/$module_prefix-$module_name"
                    }
                }
            },
            default => $url
        },
        localtree => "/var/lib/puppet/environments/$branch/modules/",
        real_name => "$real_name",
        branch => $branch
    }

    git::pull { "modules/$branch/$real_name":
        localtree => "/var/lib/puppet/environments/$branch/modules/",
        real_name => $real_name,
        require => Git::Clone["modules/$branch/$real_name"]
    }
