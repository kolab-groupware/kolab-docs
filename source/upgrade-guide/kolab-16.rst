==================================
Upgrade Notes from Kolab 3.4 to 16
==================================

The purpose of this document is, to describe the procedure of upgrading a Kolab Goupware installation from a default installed Kolab 3.4 (last "community verison") to Kolab 16.


Upgrade Procedure
=================

#.  Install the Kolab Groupware repository configuration:

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`
        # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/16/CentOS_7/Kolab:16.repo`

#.  Remove the existing Kolab 3.4 repositories:

    .. parsed-literal::

        # :command:`rm Kolab\\:3.4.repo`
        # :command:`rm Kolab\\:3.4\\:Updates.repo`

#.  Make sure that the packages from the Kolab repositories have a higher priority than eg. the :term:`EPEL` packages:

    .. parsed-literal::

        # :command:`for f in /etc/yum.repos.d/Kolab*.repo; do echo "priority = 60" >> $f; done`


#.  Replace php-mysql with php-mysqlnd:

    .. parsed-literal::

        # :command:`yum shell`
        > :command:`remove php-mysql`
        > :command:`install php-mysqlnd`
        > :command:`run`
        (Confirm as requested)
        > :command:`exit`

#.  Update all:

    .. parsed-literal::

        # :command:`yum -y update`


    .. NOTE:: During the cleanup, you might see the message:

        .. parsed-literal::

            `/var/tmp/rpm-tmp.TUmak9: line 1: fg: no job control`
            `Cleanup    : cyrus-imapd-2.5-108.3.el7.kolab_3.4.x86_64                                               347/404`
            `/var/tmp/rpm-tmp.K51Mal: line 2: fg: no job control`
            `warning: %postun(cyrus-imapd-2.5-108.3.el7.kolab_3.4.x86_64) scriptlet failed, exit status 1`
            `Non-fatal POSTUN scriptlet failure in rpm package cyrus-imapd-2.5-108.3.el7.kolab_3.4.x86_64`

        This is a warning, and the Cyrus-imapd package will be updated. This can be checked after the update with the command:

        .. parsed-literal::

            # :command:`rpm -qv cyrus-imapd`



Updating the Configuration
==========================

After upgrading the packages to Kolab 16 repository, the configuration needs to be updated.

1.  Configure the new module "Guam":

    .. parsed-literal::

        # :command:`setup-kolab guam`

2.  Configure the new module "Manticore":

    .. parsed-literal::

        # :command:`setup-kolab manticore`

    .. WARNING::

        If the Kolab 3.4 installation was a standard installation with no changes to the defaults, then the following 2 commands can be run at no risk (The correct password for the current roundcube database user is still needed for verification).

        However, if changes were made to the defaults, the original configuration should be copied off for later compare with the newly written configuration.

3.  Update the roundcube configuration:

    .. NOTE::

        As setup-kolab is unable to write to the already existing mysql database, an error message will show:

        .. parsed-literal::

            `ERROR 1007 (HY000) at line 1: Can't create database 'roundcube'; database exists`
            `ERROR 1050 (42S01) at line 8: Table 'session' already exists`

        The new and updated config file will however be written and restart the appropriate services.

        The correct password for the current roundcube database user is still needed for verification.

    .. parsed-literal::

        # :command:`setup-kolab roundcube`



4.  Update the imap configuration:

    .. parsed-literal::

        # :command:`setup-kolab imap`



