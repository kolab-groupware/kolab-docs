============================================
Upgrade Guide from Kolab Enterprise 13 to 14
============================================

This document guides you through the process of upgrading Kolab Enterprise 13 to Kolab Enterprise 14.
We recommend to try this upgrade on a test system before upgrading your production installation
to ensure that everything will work smoothly with your specific setup.

ChangeLog
=========

Kolab Enterprise 14 compared to Kolab Enterprise 14 ships the following additional components:

#.  **Birthday Calender**

    Users may opt to show the birthdays of their contacts in the Kolab Web Application.

#.  **Web Application Paths**

    The folder structure has changed. The web application has moved its public
    web content into a *public_html/* folder. While it tries to be backwards
    compatible, you might want to check your virtual host configuration to match the new paths.

#.  **E-Mail Tagging**

    The roundcube plugin *kolab_tags* supports tanging of e-mails

#.  **Notes**

    The roundcube plugin *kolab_notes* supports writing and sharing notes.
    Via syncroton these notes can be synchronised via the ActiveSync protocol.

    You can also create shared Notes folders for groups.

#.  **Resource Management**

    While managing resources was already included in the Kolab Webadmin GUI,
    the roundcube received a new component to search, check and book
    resources. This part makes use of freebusy information to actually
    show the available resources.

#.  **Freebusy**

    The freebusy web daemon now supports caching of freebusy informations
    and resources. You might want to update/replace your configuration to
    support resources, etc.

#.  **Wallace**

    The wallace daemon now includes modules for checking iTip invitations
    and resource booking requests automatically.
    Wallace is now enabled by default in new installations.
    If you want to make use of it, you must integrate it in the postfix mail flow.

#.  **IMAP ACL editor (kolab-webadmin)**

    You can now create share folders within the kolab-webadmin and manage
    and enforce initial access control lists for those folders.

#.  **Organizatioal Unit Editor (kolab-webadmin)**

    Those installations that make use of bigger LDAP Directories or
    manage corporate address books within LDAP can now make use of the OU
    Editor instead of relying on external LDAP Editors. The ou management
    includes an ACL Editor for LDAP targets.



Updating Kolab Enterprise
=========================

These procedures are meant as an example to show you how an upgrade could work.
They don't differ too much from a basic installation.


RHEL 6 & CentOS 6
-----------------

Update the Kolab Enterprise repository to the new location:

 .. parsed-literal::

    # :command:`cd /etc/yum.repos.d/`
    # :command:`rm Kolab*.repo`
    # :command:`wget https://ssl.kolabsys.com/kolab-enterprise-14-for-el6.rpm`
    # :command:`yum localinstall kolab-enterprise-14-for-el6.rpm`

Run the upgrade process:

 .. parsed-literal::

    # :command:`yum update`


Updating Configuration Files
============================

/etc/kolab/kolab.conf
---------------------

These values have been updated. Please change them in your configuration
depending on your installation and needs:

 .. parsed-literal::

    [ldap]
    sharedfolder_acl_entry_attribute = acl
    modifytimestamp_format = %Y%m%d%H%M%SZ

    [kolab_smtp_access_policy]
    delegate_sender_header = True
    alias_sender_header = True
    sender_header = True
    xsender_header = True
    cache_uri = <copy and paste mysql uri from the kolab_wap section>

    [wallace]
    modules = resources, invitationpolicy, footer
    kolab_invitation_policy = ACT_ACCEPT_IF_NO_CONFLICT:example.org, ACT_MANUAL

If you're planning to make use of wallace please make sure wallace is enabled to start
using :command:`chkconfig` on RHEL/Centos.

Restart the services

 .. parsed-literal::

    # :command:`service kolab-server restart`
    # :command:`service wallace restart`


/etc/kolab-freebusy/config.ini
------------------------------

Instead of editing the configuration by hand, it can be easier to just recreate the
configuration using the setup-kolab tool if you have not a specific configuration.

For Redhat/CentOS

 .. parsed-literal::

    # :command:`cp /etc/kolab-freebusy/config.ini.rpmnew /etc/kolab-freebusy/config.ini`

Recreatae the configuation:

 .. parsed-literal::

   # :command:`setup-kolab freebusy`


/etc/roundcubemail/config.inc.php
---------------------------------

Change the plugin load order the following way:

#.  move *kolab_auth* to the top position
#.  move *kolab_config* after *kolab_addressbook*
#.  add *kolab_notes* after *kolab_folders*
#.  add *kolab_tags* after *kolab_notes*

If you want to make use of the new secure URLs feature, add 2 more $config entries

 .. parsed-literal::

    $config['use_secure_urls'] = true;
    $config['assets_path'] = '/roundcubemail/assets/';

And adjust the asset path to where your webserver makes the assets available.

.. ATTENTION::

    Keep in mind that some of those configuration changes are requiring an
    updated apache configuration. Kolab Enterprise 14 introduced a seperate public_html/
    folder to seperate webroot and application files. Keep this in mind if
    you've customized your webserver configuration and adjust it accordingly.
    Please pay special attention to the rewrite rules in place.


/etc/roundcubemail/password.inc.php
-----------------------------------

Change the password driver from **ldap** to **ldap_simple**.

 .. parsed-literal::

    $config['password_driver'] = 'ldap_simple';


/etc/roundcubemail/kolab_files.inc.php
--------------------------------------

Update the kolab_files_url to /chwala/ to be protocol independent.

 .. parsed-literal::

    $config['kolab_files_url'] = '/chwala/';

/etc/roundcubemail/managesieve.inc.php
--------------------------------------

If you want to include the dedicated vacation settings, please add this setting:

 .. parsed-literal::

    $config['managesieve_vacation'] = 1;

/etc/iRony/dav.inc.php
----------------------

The iRony configuration doesn't have anything special configurations.
You might want to consider just to take the new default config file
or change it based on the differences between the previous version.

For Redhat/CentOS

 .. parsed-literal::

    # :command:`cp /etc/iRony/dav.inc.php.rpmnew /etc/iRony/dav.inc.php`

.. NOTE::

    You can now expose the global address list via CalDAV
    by defining $config['kolabdav_ldap_directory'] for your installation.
    The URL for users to access this address book is
    https://<kolab-server>/iRony/addressbooks/<user-email>/ldap-directory
    while specifics depend on your web server configuration.

/etc/postfix/ldap/virtual_alias_maps_sharedfolders.cf
-----------------------------------------------------

To fix the handling of resource invitations you've to adjust your existing
virtual alias maps, otherwise you end up with non-delivery-reports.

Please update your filter with this new default configuration:

.. parsed-literal::

    query_filter = (&(|(mail=%s)(alias=%s))(objectclass=kolabsharedfolder)(kolabFolderType=mail))

Restart the postfix daemon

.. parsed-literal::

    # :command:`service postfix restart`


/etc/postfix/master.cf
----------------------

Here, you can optionally enable wallace if you want it to handle resource booking and invitations automatically.
This will put wallace as the next content-filter after the mail has been
returned from amavis to postfix. If you're don't want to make use of iTip
processing or resource management you can skip this section.

 .. parsed-literal::

    [...]
    127.0.0.1:10025     inet        n       -       n       -       100     smtpd
        -o cleanup_service_name=cleanup_internal
        -o content_filter=smtp-wallace:[127.0.0.1]:10026
        -o local_recipient_maps=
    [...]

Restart the postfix daemon

 .. parsed-literal::

    # :command:`service postfix restart`

The mail flow will be the following:

#.  postfix receives mail (running on port :25 and port :587)
#.  postfix sends mail to amavisd (running on port 127.0.0.1:10024)
#.  amavisd checks mail
#.  amavisd sends mail to postfix (running on port 127.0.0.1:10025)
#.  postfix sends mail to wallace (running on port 127.0.0.1:10026)
#.  wallace checks the message for itip, resources, etc
#.  wallace sens mail to postfix (running on port 127.0.0.1:10026)
#.  postfix will start delivering the mail (external or internal)


mysql database: kolab
---------------------

A couple new features are relying new tables (organizational units).
The shared folder have been extended to make use of the **acl** editor.

You can find the full sql file here:

#.  web: https://git.kolab.org/diffusion/WAP/browse/master/doc/kolab_wap.sql;kolab-webadmin-3.2.1
#.  locally: :file:`/usr/share/doc/kolab-webadmin/kolab_wap.sql`

To not mess with your existing configuration,
the kolab-webadmin package doesn't provide auto updates or upgrade files
for your database. Here's a summary of what has been changed.

If you've made changes on the shared folder types you might want to
change the types manually in the settings section of kolab-webadmin.

Open the mysql cli:

 .. parsed-literal::

    # :command:`mysql -u root -p -D kolab`

and apply the following changes: The tables will be deleted and recreated.
Don't forget: if you've made changes to shared folder types, please update
them manually!

 .. code-block:: sql

    --
    -- Table structure for table `ou_types`
    --

    DROP TABLE IF EXISTS `ou_types`;
    /*!40101 SET @saved_cs_client     = @@character_set_client */;
    /*!40101 SET character_set_client = utf8 */;
    CREATE TABLE `ou_types` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `key` text NOT NULL,
      `name` varchar(256) NOT NULL,
      `description` text NOT NULL,
      `attributes` longtext NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `name` (`name`)
    ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
    /*!40101 SET character_set_client = @saved_cs_client */;

    --
    -- Dumping data for table `ou_types`
    --

    LOCK TABLES `ou_types` WRITE;
    /*!40000 ALTER TABLE `ou_types` DISABLE KEYS */;
    INSERT INTO `ou_types` VALUES (1,'unit','Standard Organizational Unit','A standard organizational unit definition','{\"auto_form_fields\":[],\"fields\":{\"objectclass\":[\"top\",\"organizationalunit\"]},\"form_fields\":{\"ou\":[],\"description\":[],\"aci\":{\"optional\":true,\"type\":\"aci\"}}}');
    /*!40000 ALTER TABLE `ou_types` ENABLE KEYS */;
    UNLOCK TABLES;


    --
    -- Table structure for table `sharedfolder_types`
    --

    DROP TABLE IF EXISTS `sharedfolder_types`;
    /*!40101 SET @saved_cs_client     = @@character_set_client */;
    /*!40101 SET character_set_client = utf8 */;
    CREATE TABLE `sharedfolder_types` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `key` text NOT NULL,
      `name` varchar(256) NOT NULL,
      `description` text NOT NULL,
      `attributes` longtext NOT NULL,
      PRIMARY KEY (`id`),
      UNIQUE KEY `name` (`name`)
    ) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
    /*!40101 SET character_set_client = @saved_cs_client */;

    --
    -- Dumping data for table `sharedfolder_types`
    --

    LOCK TABLES `sharedfolder_types` WRITE;
    /*!40000 ALTER TABLE `sharedfolder_types` DISABLE KEYS */;
    INSERT INTO `sharedfolder_types` VALUES (1,'addressbook','Shared Address Book','A shared address book','{\"auto_form_fields\":[],\"fields\":{\"kolabfoldertype\":[\"contact\"],\"objectclass\":[\"top\",\"kolabsharedfolder\"]},\"form_fields\":{\"acl\":{\"type\":\"imap_acl\",\"optional\":true,\"default\":\"anyone, lrs\"},\"cn\":[]}}'),(2,'calendar','Shared Calendar','A shared calendar','{\"auto_form_fields\":[],\"fields\":{\"kolabfoldertype\":[\"event\"],\"objectclass\":[\"top\",\"kolabsharedfolder\"]},\"form_fields\":{\"acl\":{\"type\":\"imap_acl\",\"optional\":true,\"default\":\"anyone, lrs\"},\"cn\":[]}}'),(3,'journal','Shared Journal','A shared journal','{\"auto_form_fields\":[],\"fields\":{\"kolabfoldertype\":[\"journal\"],\"objectclass\":[\"top\",\"kolabsharedfolder\"]},\"form_fields\":{\"acl\":{\"type\":\"imap_acl\",\"optional\":true,\"default\":\"anyone, lrs\"},\"cn\":[]}}'),(4,'task','Shared Tasks','A shared tasks folder','{\"auto_form_fields\":[],\"fields\":{\"kolabfoldertype\":[\"task\"],\"objectclass\":[\"top\",\"kolabsharedfolder\"]},\"form_fields\":{\"acl\":{\"type\":\"imap_acl\",\"optional\":true,\"default\":\"anyone, lrs\"},\"cn\":[]}}'),(5,'note','Shared Notes','A shared Notes folder','{\"auto_form_fields\":[],\"fields\":{\"kolabfoldertype\":[\"note\"],\"objectclass\":[\"top\",\"kolabsharedfolder\"]},\"form_fields\":{\"acl\":{\"type\":\"imap_acl\",\"optional\":true,\"default\":\"anyone, lrs\"},\"cn\":[]}}'),(6,'file','Shared Files','A shared Files folder','{\"auto_form_fields\":[],\"fields\":{\"kolabfoldertype\":[\"file\"],\"objectclass\":[\"top\",\"kolabsharedfolder\"]},\"form_fields\":{\"acl\":{\"type\":\"imap_acl\",\"optional\":true,\"default\":\"anyone, lrs\"},\"cn\":[]}}'),(7,'mail','Shared Mail Folder','A shared mail folder','{\"auto_form_fields\":[],\"fields\":{\"kolabfoldertype\":[\"mail\"],\"objectclass\":[\"top\",\"kolabsharedfolder\",\"mailrecipient\"]},\"form_fields\":{\"acl\":{\"type\":\"imap_acl\",\"optional\":true,\"default\":\"anyone, lrs\"},\"cn\":[],\"alias\":{\"type\":\"list\",\"optional\":true},\"kolabdelegate\":{\"type\":\"list\",\"autocomplete\":true,\"optional\":true},\"kolaballowsmtprecipient\":{\"type\":\"list\",\"optional\":true},\"kolaballowsmtpsender\":{\"type\":\"list\",\"optional\":true},\"kolabtargetfolder\":[],\"mail\":[]}}');
    /*!40000 ALTER TABLE `sharedfolder_types` ENABLE KEYS */;
    UNLOCK TABLES;

After the database update has been applied. Logout from the kolab-webadmin interface
and login back in to load the new changes.

Congratulations, your Kolab Enterprise 13 installation should now be upgraded sucessfully.
If you encounter any problems during the upgrade, please `file a support ticket <https://kolabenterprise.com/support>`__.
