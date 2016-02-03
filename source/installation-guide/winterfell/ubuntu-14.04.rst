.. _installation-winterfell-ubuntu-14.04:

================================================
Installation of Kolab Winterfell on Ubuntu 14.04
================================================

.. WARNING::

    Kolab Winterfell eats babies, for breakfast. There is potential data-loss included.

1.  Add the following two lines to ``/etc/apt/sources.list.d/kolab.list``:

    .. parsed-literal::

        deb http://obs.kolabsys.com/repositories/Kolab:/Winterfell/Ubuntu_14.04/ ./
        deb-src http://obs.kolabsys.com/repositories/Kolab:/Winterfell/Ubuntu_14.04/ ./

2.  Import the GPG key used to sign the packages:

    .. parsed-literal::

        # :command:`wget -q -O- https://ssl.kolabsys.com/community.asc | apt-key add -`

3.  To ensure the Kolab packages have priority over the Ubuntu packages, such as
    must be the case for PHP as well as Cyrus IMAP, please make sure the APT
    preferences pin the obs.kolabsys.com origin as a preferred source.

    Put the following in ``/etc/apt/preferences.d/kolab``:

    .. parsed-literal::

        Package: *
        Pin: origin obs.kolabsys.com
        Pin-Priority: 501

4.  Update the repository metadata:

    .. parsed-literal::

        # :command:`apt-get update`

5. Start the installation of the base package as follows:

    .. parsed-literal::

        # :command:`aptitude -y install kolab`

Continue to :ref:`install-setup-kolab`.
