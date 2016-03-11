The |roundcubemail| package contains the upstream web-application used
for the webmail interface in Kolab Groupware.

It's packaging is rather complex, with one tarball resulting in some 100
sub-packages.

The generic package |roundcubemail| is a so-called meta-package, that
depends on a set of sub-packages. As such, a
:command:`yum install roundcubemail` results in a fully function,
minimal installation of Roundcube (with only the core, few required
plugins, and one skin).

Among the Roundcube sources are three generic categories of source code
that are packaged separately -- the core, the plugins and the skins.

The core program and each plugin may contain static files (assets) for
the core program or the plugin to function, that are independent of the
skin being used, but may also contain static files (assets) that are
specific to a particular skin being used.

Program code, skins and assets are all packaged separately, so that
a particular server system can be made to serve only static contents.

.. seealso::

    *   :ref:`article-what-goes-in-to-a-documentroot-and-what-does-not-belong-there`

**Core Roundcube Library and Program**

    The core Roundcube library contains generic program code shared
    between applications such as :ref:`package-chwala`,
    :ref:`package-irony`, :ref:`package-kolab-freebusy` and
    :ref:`package-kolab-syncroton`.

    In packaging, the core Roundcube library is deployed to
    :file:`/usr/share/roundcubemail/program/lib/Roundcube/`, and
    configured using :file:`/etc/roundcubemail/config.inc.php` and
    :file:`/etc/roundcubemail/defaults.inc.php`.

    The core Roundcube program wraps up the core library, required
    plugins and the available skins in to the full webmail interface.

    The core is packaged as **roundcubemail-core**, providing a virtual
    capability of *roundcubemail(core) = %{version}-%{release}* that other
    packages depend on.

    This package also depends on the plugins that are required, and at
    least one skin (referred to by the virtual provides
    *roundcubemail(skin)*).

**Required Plugins**

    Required plugins are packaged separately, and include:

    *   ``filesystem_attachments``
    *   ``jqueryui``

**Additional Plugins**

    *   ``acl``
    *   ``additional_message_headers``
    *   ``archive``
    *   ``attachment_reminder``
    *   ``autologon``
    *   ``database_attachments``
    *   ``debug_logger``
    *   ``emoticons``
    *   ``enigma``
    *   ``example_addressbook``
    *   ``help``
    *   ``hide_blockquote``
    *   ``http_authentication``
    *   ``identity_select``
    *   ``legacy_browser``
    *   ``managesieve``
    *   ``markasjunk``
    *   ``new_user_dialog``
    *   ``new_user_identity``
    *   ``newmail_notifier``
    *   ``password``
    *   ``redundant_attachments``
    *   ``show_additional_headers``
    *   ``squirrelmail_usercopy``
    *   ``subscriptions_option``
    *   ``userinfo``
    *   ``vcard_attachments``
    *   ``virtuser_file``
    *   ``virtuser_query``
    *   ``zipdownload``

**Skins**

    *   ``classic``
    *   ``larry``
