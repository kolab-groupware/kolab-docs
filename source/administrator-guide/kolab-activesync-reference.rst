.. _admin_kolab-activesync-settings:

===========================================
Kolab ActiveSync Service Settings Reference
===========================================

The web service is based on Roundcube Framework and because of that it uses
the same configuration file as the webmail application i.e. ``/etc/roundcubemail/config.inc.php``.

Basic Configuration
===================

``activesync_debug``
^^^^^^^^^^^^^^^^^^^^

Enables ActiveSync protocol debuging. This will store the complete communication between
server and activesync client into ``logs/console`` file. Default is ``false``.

``activesync_user_log``
^^^^^^^^^^^^^^^^^^^^^^^

Enables logging to a separate directory for every user/device. Default is ``false``.

``activesync_user_debug``
^^^^^^^^^^^^^^^^^^^^^^^^^

Enables per-user debugging only if /var/log/kolab-syncroton/<username>/ folder exists.
Default is ``false``.

``activesync_log_file``
^^^^^^^^^^^^^^^^^^^^^^^

If specified all ActiveSync-related logs will be saved to this file. Default is ``null``.
Note: This doesn't change Roundcube Framework log locations.

``activesync_addressbooks``
^^^^^^^^^^^^^^^^^^^^^^^^^^^

A list of global addressbooks (GAL). Default is ``array()``.
Note: If empty ``autocomplete_addressbooks`` setting will be used.

``activesync_gal_fieldmap``
^^^^^^^^^^^^^^^^^^^^^^^^^^^

ActiveSync to Roundcube contact fields map for GAL search.
Default:

.. code-block:: php

   array(
       'alias'         => 'nickname',
       'company'       => 'organization',
       'displayName'   => 'name',
       'emailAddress'  => 'email',
       'firstName'     => 'firstname',
       'lastName'      => 'surname',
       'mobilePhone'   => 'phone.mobile',
       'office'        => 'office',
       'picture'       => 'photo',
       'phone'         => 'phone',
       'title'         => 'jobtitle',
    );


``activesync_gal_sync``
^^^^^^^^^^^^^^^^^^^^^^^

List of device types that will sync the LDAP addressbook(s) as a normal folder.
For devices that do not support GAL searching, e.g. Outlook. Default is ``false``.
Example: ``array('windowsoutlook')``  # enable for Oultook only
Example: ``true``                     # enable for all

Note: To make the LDAP addressbook sources working we need two additional
fields ('uid' and 'changed') specified in the fieldmap array
of the LDAP configuration ('ldap_public' option). For example:

    .. code-block:: php
        'uid'     => 'nsuniqueid',
        'changed' => 'modifytimestamp',


``activesync_plugins``
^^^^^^^^^^^^^^^^^^^^^^

List of Roundcube plugins available for ActiveSync service.
WARNING: Not all plugins used in Roundcube can be listed here. Use the default!

``activesync_init_subscriptions``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When a device is reqistered (connects for the first time), by default a set of folders
is subscribed for syncronization, i.e. INBOX and personal folders with defined folder type:
mail.drafts, mail.wastebasket, mail.sentitems, mail.outbox, event, event.default,
contact, contact.default, task, task.default.

This default set can be extended by adding following values:
``1``  - all subscribed folders in personal namespace
``2``  - all folders in personal namespace
``4``  - all subscribed folders in other users namespace
``8``  - all folders in other users namespace
``16`` - all subscribed folders in shared namespace
``32`` - all folders in shared namespace

``activesync_multifolder_blacklist``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Defines a blacklist of devices (device type strings) that do not support folder hierarchies.
When set to an array folder hierarchies are used on all devices not listed here.
When set to ``null`` an old whitelist approach will be used where we do opposite
action and enable folder hierarchies only on device types known to support it.

Note: To enable multi-folder for all devices set it to ``array()``.

``activesync_multifolder_blacklist_*``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Blacklist overwrites for specified object type. If set to an array
it will have a precedence over ``activesync_multifolder_blacklist`` list only for that type.
Note: Outlook does not support multiple folders for contacts, in that case use ``$config['activesync_multifolder_blacklist_contact'] = array('windowsoutlook');``.
Supported types: mail, event, contact, note, task.

``activesync_fix_from``
^^^^^^^^^^^^^^^^^^^^^^^

Enables adding sender name in the From: header of an email sent via ActiveSync
when a device uses email address only (e.g. iOS devices). Default is ``false``.


Performance Related Configuration
=================================

``activesync_cache'``
^^^^^^^^^^^^^^^^^^^^^

A type of ActiveSync cache. Supported values: ``'db'``, ``'apc'`` and ``'memcache'``.
Default is ``'db'``.
Note: This cache is only for some additional data like timezones mapping.

``activesync_cache_ttl``
^^^^^^^^^^^^^^^^^^^^^^^^

A lifetime of ActiveSync cache entries. Possible units: s, m, h, d, w. Default is ``'1d'``.

``activesync_auth_cache``
^^^^^^^^^^^^^^^^^^^^^^^^^

A type of ActiveSync authentication cache. Supported values: ``'db'``, ``'apc'`` and ``'memcache'``.
Default is ``'db'``.
Note: This is only for username canonification.

``activesync_auth_cache_ttl``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A lifetime of ActiveSync authentication cache. Possible units: s, m, h, d, w. Default is ``'1d'``.

``activesync_gal_cache``
^^^^^^^^^^^^^^^^^^^^^^^^

Global Address List cache. As reading all contacts from LDAP may be slow, caching is recommended.
Supported values: ``'db'``, ``'apc'`` and ``'memcache'``. Default is ``'db'``.

``activesync_gal_cache_ttl``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

TTL of GAL cache entries. Technically this causes that synchronized
contacts will not be updated (queried) often than the specified interval. Default is ``'1d'``.

``activesync_ping_timeout``
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Defines for how many seconds we'll sleep between every action for detecting changes in folders.
Default is ``60``.

``activesync_ping_interval``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Defines maximum Ping interval in seconds. Default is ``900`` (15 minutes).

``activesync_quiet_time``
^^^^^^^^^^^^^^^^^^^^^^^^^

We start detecting changes n seconds since the last sync of a folder. Default is ``180``.
