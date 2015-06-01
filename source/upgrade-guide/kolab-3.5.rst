====================================
Upgrade Notes from Kolab 3.4 to 3.5
====================================

ChangeLog
=========

#.  **empty**

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
    # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.5/CentOS_6/Kolab:3.5.repo`
    # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.5:/Updates/CentOS_6/Kolab:3.5:Updates.repo`

run the upgrade process

 .. parsed-literal::

    # :command:`yum update`


Debian 7
--------

Update the repo to the new location

 .. parsed-literal::

    # :command:`echo "deb http://obs.kolabsys.com/repositories/Kolab:/3.5/Debian_8.0/ ./
    deb http://obs.kolabsys.com/repositories/Kolab:/3.5:/Updates/Debian_8.0/ ./" > /etc/apt/sources.list.d/kolab.list`

If you've don't have set a correct apt-pinning or release keys, please check the Installation Guide.

Update and Upgrade the system

 .. parsed-literal::

    # :command:`apt-get update`
    # :command:`apt-get dist-upgrade`

.. WARNING::

    You'll get ask if you want to replace your configuration files! DON'T overwrite them!
    You'll lose your configuration and credentials and end up with a broken frontend.


Database
========

mysql database: kolab
---------------------

The admin database got a few minor updates:

You can find the full sql file here:

XXX FIXME
#.  web: http://git.kolab.org/kolab-wap/tree/doc/kolab_wap.sql?id=kolab-webadmin-3.2.6
#.  locally: :file:`/usr/share/doc/kolab-webadmin/kolab_wap.sql`

.. ATTENTION::

    Don't forget to make **backups** of your database before applying
    the changes!


The kolab-webadmin package doesn't provide auto updates or upgrade files
for your database. Here's a summary of what has been changed.

Field for mail.alias is not a list for Mail-enabled POSIX user in
kolab-webadmin (#2219)
https://issues.kolab.org/show_bug.cgi?id=2219
http://cgit.kolab.org/webadmin/commit/?id=47653cb71fc68c083ef2cc95a97790f64f0b590e
http://cgit.kolab.org/webadmin/commit/?id=250f5938c1bd0cf021d01125e01eebe7e212ed0c
http://cgit.kolab.org/webadmin/commit/?id=d8dc3e2f241d66fb36126416c44f8303df36ba41

Warn when two Users have the same secondary mail address (#2983)
https://issues.kolab.org/show_bug.cgi?id=2983
http://cgit.kolab.org/webadmin/commit/?id=e484198c037a919a42d9c5a52dec107def982d27

If you've made changes on the user types you might want to change the
types manually in the settings section of kolab-webadmin (see below
for details).  Otherwise you can refresh the user_types table:

You can find the sample php script here:

XXX FIXME
#.  web: http://git.kolab.org/kolab-wap/tree/doc/kolab_wap.sql?id=kolab-webadmin-3.2.6
#.  locally: :file:`/usr/share/doc/kolab-webadmin/sample-insert-user_types.php.gz`

 .. parsed-literal::

    # :command:`gunzip < /usr/share/doc/kolab-webadmin/sample-insert-user_types.php.gz > /tmp/sample-insert-user_types.php`
    # :command:`cd /usr/share/kolab-webadmin/`
    # :command:`php /tmp/sample-insert-user_types.php`


Manually changing the user_types in the kolab-webadmin interface

Log on to the kolab-webadmin interface using "cn=Directory
Manager". Select "Settings" (Einstellungen) and select object type
"User" (Benutzer). You need to apply the following changes to each of
"Kolab User" and "Mail enabled POSIX User".

Switch to the tab "attributes", search the line "alias" and click the
pencil symbol to edit. Apply the following changes:

1. field_type select "list"
2. validate select "extended"
3. tick "optional"

To save your changes press "save", scroll to the bottom of the page, and
press "send".

After the database update has been applied. Logout from the kolab-webadmin interface
and login back in to load the new changes.

