.. _installation-centos-community:

======================
Installation on CentOS
======================

.. NOTE::
    Please note that currently the packages will not install for CentOS 7.2. The OBS at Kolab Systems still builds against CentOS 7.1 which causes a conflict with the newer version of libical that comes with CentOS 7.2.
    As an alternative, you can use the Kolab packages provided in a Copr repository, see instructions at: https://github.com/TBits/KolabScripts/tree/Kolab3.4/copr#installing-kolab-from-the-copr-repositories

1.  Install the :term:`EPEL` repository:

    .. parsed-literal::

        # :command:`rpm -Uhv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm`

2.  Install the Kolab Groupware repository configuration:

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`
        # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.4/CentOS_7/Kolab:3.4.repo`
        # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/3.4:/Updates/CentOS_7/Kolab:3.4:Updates.repo`

3.  Install the **yum-plugin-priorities** package:

    .. parsed-literal::

        # :command:`yum install yum-plugin-priorities`

4.  Make sure that the packages from the Kolab repositories have a higher priority than eg. the Epel packages:

    .. parsed-literal::

        # :command:`for f in /etc/yum.repos.d/Kolab*.repo; do sed -i "s#enabled=1#enabled=1\npriority=1#g" $f; done`

5.  Import the GPG key used to sign the packages:

    .. parsed-literal::

        # :command:`rpm --import https://ssl.kolabsys.com/community.asc`

6.  Install Kolab Groupware:

    .. parsed-literal::

        # :command:`yum install kolab`

Continue to :ref:`install-setup-kolab`.
