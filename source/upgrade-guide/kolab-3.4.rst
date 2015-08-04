====================================
Upgrade Notes from Kolab 3.3 to 3.4
====================================

ChangeLog
=========

#.  **New skin for Roundcube: Chameleon**

    **Chameleon** is the new default skin for Kolab Groupware and replaces the
    default **larry** skin.

#.  **Freebusy now supports resource collections**

    If you have a resource collection of multiple resources freebusy can now
    provide an aggregated view on the data from all its members

#.  **CSRF is now enabled by default for Debian**

    In the previous release the CSRF patch was only enabled within the RPM
    packages. With Kolab 3.4 this security patch has been applied to the
    Debian packages as well. So make sure your webserver configuration needs
    to be adjusted in case you modified it.

#.  **Kolab Webadmin provides a 'Default' Type**

    You no longer have to switch from 'Contact' to 'Kolab User' when creating
    a new user.

#.  **Lots Of Bugfixes**

Updating the system
===================

These update procecures are just an example. They don't differ too much from
a basic installation.


CentOS 6
--------

Update the repo to the new location

 .. parsed-literal::

    # :command:`cd /etc/yum.repos.d/`
    # :command:`rm Kolab*.repo`
    # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.4/CentOS_6/Kolab:3.4.repo`
    # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.4:/Updates/CentOS_6/Kolab:3.4:Updates.repo`

run the upgrade process

 .. parsed-literal::

    # :command:`yum update`


Debian 7
--------

Update the repo to the new location

 .. parsed-literal::

    # :command:`echo "deb http://obs.kolabsys.com/repositories/Kolab:/3.4/Debian_7.0/ ./
    deb http://obs.kolabsys.com/repositories/Kolab:/3.4:/Updates/Debian_7.0/ ./" > /etc/apt/sources.list.d/kolab.list`

If you've don't have set a correct apt-pinning or release keys, please check the Installation Guide.

Update and Upgrade the system

 .. parsed-literal::

    # :command:`apt-get update`
    # :command:`apt-get dist-upgrade`

.. WARNING::

    You'll get ask if you want to replace your configuration files! DON'T overwrite them!
    You'll lose your configuration and credentials and end up with a broken frontend.


Update your configuration files
===============================

If you want to check want configuration files have changed, the best way is to
compare the previous and current version in the GIT repository.

/etc/imapd.conf
---------------

With the most recent upstream cyrus-imapd version a few config parameters have
changed.

    http://cgit.kolab.org/pykolab/diff/share/templates/imapd.conf.tpl?id=pykolab-0.7.6&id2=pykolab-0.7.1

The following parameters have been renamed:

 .. parsed-literal::

    tls_cert_file --> tls_server_cert
    tls_key_file --> tls_server_key
    tls_ca_file --> tls_server_ca_file || tls_client_ca_file

If you don't use server or client certificate validation feel free to remove
the ``tls_ca_file`` parameter and/or consult the cyrus-imapd 2.5 documentation
for clarification.

Additionally we can enable 2 more sieve_extensions (date + index) and remove
the flushseenstate option.

 .. parsed-literal::

    sieve_extensions: fileinto reject envelope body vacation imapflags notify include regex subaddress relational copy date index
    # flushseenstate: 1


/etc/postfix/ldap/virtual_alias_maps_sharedfolders.cf
-----------------------------------------------------

 .. note::

    This fix applies to other sharedfolders.cf configuration files as well
    (in a multidomain environment)

Change the result_format to be enclosed by quotes otherwise you can't deliver
mail messages to shared mailboxes that contains spaces in the mailbox name.

 .. parsed-literal::

    result_format = "shared+%s"

**Background**

There's a mailbox that's called ``The A Team`` with a delivery address of
``team@example.org``. The resulting IMAP Folder would/should be ``shared/The A Team@example.org``.

If you now send an email to ``team@example.org`` it will get remapped to
``"shared+shared/The A Team@example.org"@example.org``. Without the quotes you
get 3 non-delivery-reports because whitespace would be considered a delimiter.


/etc/kolab/kolab.conf
---------------------

You can see the configuration differences here:

    http://cgit.kolab.org/pykolab/diff/conf/kolab.conf?id=pykolab-0.7.6&id2=pykolab-0.7.1

We only have one new option for wallace, which can be ignored if you don't use
wallace for resource management. Restart wallace and kolab-server after upgrading
all python modules should be done anyway.


 .. parsed-literal::

    [wallace]
    resource_calendar_expire_days = 100

Don't forget to restart the wallace service

**On Debian**

 .. parsed-literal::

    # :command:`service wallace restart`
    # :command:`service kolab-server restart`

**On CentOS**

 .. parsed-literal::

    # :command:`service wallace restart`
    # :command:`service kolabd restart`


/etc/kolab-freebusy/config.ini
------------------------------

You can see the configuration differences here:

    http://git.kolab.org/kolab-freebusy/diff/config/config.ini.sample?id=kolab-freebusy-1.0.6&id2=kolab-freebusy-1.0.5

Instead of editing the configuration by hand it's easier to just recreate the
configuration using the setup-kolab tool. The :command:`setup-kolab freebusy`
command has been fixed to generate a working default configuration right
of the box.

For Redhat/CentOS

 .. parsed-literal::

    # :command:`cp /etc/kolab-freebusy/config.ini.rpmnew /etc/kolab-freebusy/config.ini`

For Debian

 .. parsed-literal::

    # :command:`cp /etc/kolab-freebusy/config.ini.dpkg-dist /etc/kolab-freebusy/config.ini`

Recreate the configuation:

 .. parsed-literal::

   # :command:`setup-kolab freebusy`


/etc/roundcubemail/config.inc.php
---------------------------------

You can see the configuration differences here:

    http://cgit.kolab.org/pykolab/diff/share/templates/roundcubemail/config.inc.php.tpl?id=pykolab-0.7.6&id2=pykolab-0.7.1

The 'threading_as_default' no longer exists and therfore don't need to be
loaded. So you can safely remove it.

 .. parsed-literal::

    $config['plugins'] = array(
        ...
        // 'threading_as_default',
        ...
    );

add or update the following $config entries

 .. parsed-literal::

    $config['assets_dir'] = '/usr/share/roundcubemail/public_html/assets/';
    $config['useragent'] = 'Kolab 3.4/Roundcube ' . RCUBE_VERSION;
    $config['skin'] = 'chameleon';

With Kolab Groupware having now it's own skin you can savely remove the
skin_logo configuration.

 .. parsed-literal::

    // $config['skin_logo'] = 'skins/kolab/images/kolab_logo.png';

.. ATTENTION::

    Keep in mind that the CSRF patch has now been applied to the Debian
    packages as well. Make sure to update your webserver configuration and
    rewrite rules. Otherwise consider disabling **use_secure_urls**.


/etc/roundcubemail/managesieve.inc.php
--------------------------------------

You can see the configuration differences here:

    http://cgit.kolab.org/pykolab/diff/share/templates/roundcubemail/managesieve.inc.php.tpl?id=HEAD&id2=pykolab-0.7.1

Turn of debugging and add 2 additional entries:

 .. parsed-literal::

    $config['managesieve_debug'] = false;
    $config['managesieve_filename_extension'] = '';
    $config['managesieve_kolab_master'] = true;


/etc/roundcubemail/libkolab.inc.php
-----------------------------------

You can savely switch to a relative url for freebusy.

 .. parsed-literal::

    $config['kolab_freebusy_server'] = '/freebusy';


/etc/iRony/dav.inc.php
----------------------

You can see the configuration differences here:

    http://cgit.kolab.org/iRony/diff/config/dav.inc.php.sample?id=iRony-0.3.0&id2=iRony-0.2.8

If you use the global addressbook <> CardDAV gateway you might want to
take a look on the changes, otherwise you can just take the default
configuration.

For Redhat/CentOS

 .. parsed-literal::

    # :command:`cp /etc/iRony/dav.inc.php.rpmnew /etc/iRony/dav.inc.php`

For Debian

 .. parsed-literal::

    # :command:`cp /etc/iRony/dav.inc.php.dpkg-dist /etc/iRony/dav.inc.php`


Webserver
=========

Check for new versions of the apache configuration files (in case you modified)
them.

**For Centos / RHEL**

 .. parsed-literal::

    # :command:`find /etc/httpd/ -type f -name "*.rpm*"`

**For Debian / Ubuntu**

 .. parsed-literal::

    # :command:`find /etc/apache2/ -type f -name "*.dpkg*"`


If you're running a different webserver configuration (like nginx) please check
the howto or the configuration files for any changes and apply them to your
setup accordingly.


Database
========

mysql database: kolab
---------------------

The admin database got a few minor updates:

You can find the full sql file here:

#.  web: http://cgit.kolab.org/webadmin/tree/doc/kolab_wap.sql?id=kolab-webadmin-3.2.6
#.  locally: :file:`/usr/share/doc/kolab-webadmin/kolab_wap.sql`

The kolab-webadmin package doesn't provide auto updates or upgrade files
for your database. Here's a summary of what has been changed.

If you've made changes on the shared folder types you might want to
change the types manually in the settings section of kolab-webadmin.

Open the mysql cli or your favorite database administration frontend.

 .. parsed-literal::

    # :command:`mysql -u root -p -D kolab`

and apply the followin changes: The tables will be deleted and recreated.
Don't forget: if you've made changes to shared folder types, please update
them manually!

.. ATTENTION::

    Don't forget to make **backups** of your database before applying
    the changes!

Fix the name field length.

 .. code-block:: sql

    ALTER TABLE `group_types` CHANGE  `name`  `name` VARCHAR( 255 ) NOT NULL ;
    ALTER TABLE `ou_types` CHANGE  `name`  `name` VARCHAR( 255 ) NOT NULL ;
    ALTER TABLE `resource_types` CHANGE  `name`  `name` VARCHAR( 255 ) NOT NULL ;
    ALTER TABLE `role_types` CHANGE  `name`  `name` VARCHAR( 255 ) NOT NULL ;
    ALTER TABLE `sharedfolder_types` CHANGE  `name`  `name` VARCHAR( 255 ) NOT NULL ;
    ALTER TABLE `user_types` CHANGE  `name`  `name` VARCHAR( 255 ) NOT NULL ;

The old kolab was still in the latin1 format. We should unify everything into
the utf-8 format.

 .. code-block:: sql

    ALTER TABLE `group_types` CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
    ALTER TABLE `ou_types` CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
    ALTER TABLE `resource_types` CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
    ALTER TABLE `role_types` CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
    ALTER TABLE `sharedfolder_types` CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
    ALTER TABLE `user_types` CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;

A new field got introduced to mark the default type (for example 'Kolab User').

 .. code-block:: sql

    ALTER TABLE `group_types` ADD `is_default` tinyint(1) DEFAULT 0;
    ALTER TABLE `ou_types` ADD `is_default` tinyint(1) DEFAULT 0;
    ALTER TABLE `resource_types` ADD `is_default` tinyint(1) DEFAULT 0;
    ALTER TABLE `role_types` ADD `is_default` tinyint(1) DEFAULT 0;
    ALTER TABLE `sharedfolder_types` ADD `is_default` tinyint(1) DEFAULT 0;
    ALTER TABLE `user_types` ADD `is_default` tinyint(1) DEFAULT 0;

    UPDATE `user_types` SET `is_default` = 1 WHERE `key` = 'kolab';

After the database update has been applied. Logout from the kolab-webadmin interface
and login back in to load the new changes.

mysql database: roundcube
-------------------------

The libkolab plugin had some changes. These changes are effecting the
``kolab_cache*`` tables. SQL upgrades are usually run during the package
installation.

Please verify that we the tables have been upgraded to the lastest version.

 .. parsed-literal::

    # :command:`mysql -u root -p -D roundcube -e 'SELECT * FROM system WHERE name LIKE "libkolab%"'`
    +------------------+------------+
    | name             | value      |
    +------------------+------------+
    | libkolab-version | 2015020600 |
    +------------------+------------+

 .. note::

    The initial Kolab 3.4 roundcubemail-plugins-kolab rpm packages had this
    upgrade database procedure missing.

Under some circumstances it can be possible that his upgrade couldn't be
applied as expected. If you experience probems with your mysql database check
if the database was updated correctly and apply the pathces using the following
command and verify the result:

 .. parsed-literal::

    # :command:`/usr/share/roundcubemail/bin/updatedb.sh --dir /usr/share/roundcubemail/plugins/libkolab/SQL --package libkolab`

    # :command:`mysql -u root -p -D roundcube -e 'SELECT * FROM system WHERE name LIKE "libkolab%"'`
    +------------------+------------+
    | name             | value      |
    +------------------+------------+
    | libkolab-version | 2015020600 |
    +------------------+------------+

If you still have problems or the sql upgrade didn't went through as expected.
It is save to recreate the libkolab tables (kolab_folders, kolab_cache_*) as
they're only used to cache items from the imap storage.

 .. parsed-literal::

    # :command:`mysql -u root -p -D roundcube < /usr/share/roundcubemail/plugins/libkolab/SQL/mysql.initial.sql`
