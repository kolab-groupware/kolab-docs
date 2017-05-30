===================================
Upgrade Notes from KE14 to Kolab 16
===================================

The purpose of this document is, to describe the procedure of upgrading a Kolab Goupware installation from a default installed KE14 to Kolab 16 on Enterprise Linux 7 (or CentOS 7).

.. WARNING::

    If your Kolab installation is a default standard installation, this guide is useful. Please consider any non default configurations of environment or software that you might have in play before upgrading.

    Customers of `Kolab Systems AG`_, please contact your account manager with any questions or concerns.


Upgrade Procedure
=================

#.  Remove the existing KE14 repositories:

    .. parsed-literal::

        # :command:`yum remove kolab-14-enterprise-release`

#.  Install the new Kolab 16 repositories:

    .. parsed-literal::

        # :command:`yum install https://ssl.kolabsys.com/kolab-16-for-el7.rpm`

#.  Update all:

    .. parsed-literal::

        # :command:`yum -y update`


Updating the Configuration
==========================

After upgrading the packages to Kolab 16 repository, the configuration needs to be updated.

1.  Update the IMAP configuration:

   .. parsed-literal::

	# :command:`setup-kolab imap`

2.  Configure the module "Guam":

    .. parsed-literal::

        # :command:`setup-kolab guam`


