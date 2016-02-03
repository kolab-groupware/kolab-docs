.. _installation-guide-winterfell-centos-7:

============================================
Installation of Kolab Winterfell on CentOS 7
============================================

.. WARNING::

    Kolab Winterfell eats babies, for breakfast. There is potential data-loss included.

1.  Install the :term:`EPEL` repository:

    .. parsed-literal::

        # :command:`rpm -Uhv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm`

2.  Install the Kolab Groupware repository configuration:

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`
        # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/Winterfell/CentOS_7/Kolab:Winterfell.repo`

3.  Import the GPG key used to sign the packages:

    .. parsed-literal::

        # :command:`rpm --import https://ssl.kolabsys.com/community.asc`

4.  Install the **yum-plugin-priorities** package:

    .. parsed-literal::

        # :command:`yum install yum-plugin-priorities`

5.  Make sure that the packages from the Kolab repositories have a higher priority than eg. the Epel packages:

    .. parsed-literal::

        # :command:`for f in /etc/yum.repos.d/Kolab*.repo; do echo "priority = 60" >> $f; done`

6.  Install Kolab Groupware:

    .. parsed-literal::

        # :command:`yum install kolab`

Continue to :ref:`install-setup-kolab`.
