.. _installation-guide-winterfell-fedora-23:

=============================================
Installation of Kolab Winterfell on Fedora 23
=============================================

.. WARNING::

    Kolab Winterfell eats babies, for breakfast. There is potential data-loss included.

1.  Install the Kolab Groupware repository configuration:

    .. parsed-literal::

        # :command:`cd /etc/yum.repos.d/`
        # :command:`wget http://obs.kolabsys.com/repositories/Kolab:/Winterfell/Fedora_23/Kolab:Winterfell.repo`

2.  Import the GPG key used to sign the packages:

    .. parsed-literal::

        # :command:`rpm --import https://ssl.kolabsys.com/community.asc`

3.  Make sure that the packages from the Kolab repositories have a higher priority than the stock repositories:

    .. parsed-literal::

        # :command:`for f in /etc/yum.repos.d/Kolab*.repo; do echo "priority = 60" >> $f; done`

4.  Install Kolab Groupware:

    .. parsed-literal::

        # :command:`yum install kolab`

Continue to :ref:`installation-guide-setup-kolab`.
