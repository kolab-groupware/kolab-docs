======================
Installation on CentOS
======================

1.  Install the :term:`EPEL`_ repository:

    .. parsed-literal::

        # :command:`rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm`

2.  Install the Kolab Groupware repository configuration:

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`
        # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.3/CentOS_7/Kolab:3.3.repo`
        # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.3:/Updates/CentOS_7/Kolab:3.3:Updates.repo`

3.  Import the GPG key used to sign the packages:

    .. parsed-literal::

        # :command:`rpm --import https://ssl.kolabsys.com/community.asc`

4. 
4.  Install Kolab Groupware:

    .. parsed-literal::

        # :command:`yum install kolab`

Continue to :ref:`install-setup-kolab`.

.. _EPEL for CentOS 6: http://download.fedoraproject.org/pub/epel/6/i386/repoview/epel-release.html
.. _EPEL for CentOS 7: http://download.fedoraproject.org/pub/epel/beta/7/x86_64/repoview/epel-release.html
