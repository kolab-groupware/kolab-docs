The **roundcubemail** package contains the upstream web-application used
for webmail.

Among its sources are the following five categories:

**Core Roundcube Library**

    The core Roundcube library contains generic program code shared
    between applications such as :ref:`package-chwala`,
    :ref:`pacage-irony`, :ref:`package-kolab-freebusy` and
    :ref:`package-kolab-syncroton`.

    In packaging, the core Roundcube library is deployed to
    :file:`/usr/share/roundcubemail/program/lib/Roundcube/`, and
    configured using :file:`/etc/roundcubemail/config.inc.php` and
    :file:`/etc/roundcubemail/defaults.inc.php`.

**Core Roundcube Program**

    The core Roundcube program wraps up the core library, required
    plugins and the available skins in to the full webmail interface.

Both these categories are packaged as **roundcubemail-core**, providing
a virtual capability of *roundcubemail(core) = %{version}-%{release}*
that other packages depend on.

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
