.. _installation-rhel-community:

========================================
Installation on Red Hat Enterprise Linux
========================================

1.  Install the :term:`EPEL`_ repository:

    .. parsed-literal::

        # :command:`rpm -Uhv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm`

2.  Install the Kolab Groupware repository configuration:

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`
        # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.4/CentOS_7/Kolab:3.4.repo`
        # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.4:/Updates/CentOS_7/Kolab:3.4:Updates.repo`

3.  Import the GPG key used to sign the packages:

    .. parsed-literal::

        # :command:`rpm --import https://ssl.kolabsys.com/community.asc`

4.  Install the **yum-plugin-priorities** package:

    .. parsed-literal::

        # :command:`yum --enablerepo=rhel-7-server-optional-rpms install kolab`

5.  Install Kolab Groupware:

    .. parsed-literal::

        # :command:`yum --enablerepo=rhel-7-server-optional-rpms install kolab`

Continue to :ref:`install-setup-kolab`.
