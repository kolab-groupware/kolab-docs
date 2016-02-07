.. _installation-guide-rhel-7:

======================================================
Installation of Kolab 16 on Red Hat Enterprise Linux 7
======================================================

The installation of Kolab Groupware on Red Hat Enterprise Linux installs
a number of additional packages, from the :term:`EPEL` software
repository.

Installation Procedure
======================

1.  Install the :term:`EPEL` repository:

    .. parsed-literal::

        # :command:`rpm -Uhv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm`

2.  Install the Kolab Groupware repository configuration:

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`
        # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/16/RHEL_7/Kolab:16.repo`

3.  Import the GPG key used to sign the packages:

    .. parsed-literal::

        # :command:`rpm --import https://ssl.kolabsys.com/community.asc`

4.  Install the **yum-plugin-priorities** package:

    .. parsed-literal::

        # :command:`yum install yum-plugin-priorities`

5.  Make sure that the packages from the Kolab repositories have a higher priority than eg. the :term:`EPEL` packages:

    .. parsed-literal::

        # :command:`for f in /etc/yum.repos.d/Kolab*.repo; do echo "priority = 60" >> $f; done`

6.  Install Kolab Groupware:

    .. parsed-literal::

        # :command:`yum install --enablerepo=rhel-7-server-optional-rpms kolab`

Continue to :ref:`installation-guide-setup-kolab`.

