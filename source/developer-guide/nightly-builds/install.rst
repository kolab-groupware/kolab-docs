.. _dev-packaging-install_nightly:

============================================
Install the nightly build on a test server
============================================

For development of the community version of Kolab, it is helpful to have nightly built packages of the master of https://git.kolab.org.

Note: these packages are only meant for development and testing, not at all for production use!!!

It is recommended to do a fresh install of the machine, when you want to go back to the Kolab Community version packages, without the nightly packages.

CentOS 7
=================================================

First the usual steps, that you do for installing Kolab3 (see also :ref:`installation-centos`):

.. parsed-literal::

    yum install epel-release
    cd /etc/yum.repos.d/
    wget http://obs.kolabsys.com/repositories/Kolab:/3.4/CentOS_7/Kolab:3.4.repo
    wget http://obs.kolabsys.com/repositories/Kolab:/3.4:/Updates/CentOS_7/Kolab:3.4:Updates.repo
    cd -

Now also install the repo for the `obs.kolabsys.com tpokorra Project <https://obs.kolabsys.com/project/show?project=home%3Atpokorra%3Abranches%3AKolab%3ADevelopment>`_:

.. parsed-literal::

    wget http://obs.kolabsys.com/home:/tpokorra:/branches:/Kolab:/Development/CentOS_7/home:tpokorra:branches:Kolab:Development.repo \\
              -O /etc/yum.repos.d/obs-tpokorra-nightly-kolab.repo

Now run:

.. parsed-literal::

    yum install kolab
    setup-kolab

Debian 7.0
==========

See also the usual steps, that you do for installing Kolab3 (see also :ref:`installation-debian`). We are adding another repository for the nightly built packages.

.. parsed-literal::
    username=tpokorra
    cat > /etc/apt/sources.list.d/kolab.list <<FINISH
    deb http://obs.kolabsys.com/repositories/Kolab:/3.4/Debian_7.0/ ./
    deb http://obs.kolabsys.com/repositories/Kolab:/3.4:/Updates/Debian_7.0/ ./
    deb http://obs.kolabsys.com/repositories/home:/$username:/branches:/Kolab:/Development/Debian_7.0/ ./
    FINISH
     
    wget http://obs.kolabsys.com/repositories/Kolab:/3.4/Debian_7.0/Release.key
    apt-key add Release.key; rm -rf Release.key
    wget http://obs.kolabsys.com/repositories/Kolab:/3.4:/Updates/Debian_7.0/Release.key
    apt-key add Release.key; rm -rf Release.key
    wget http://obs.kolabsys.com/repositories/home:/$username:/branches:/Kolab:/Development/Debian_7.0/Release.key
    apt-key add Release.key; rm -rf Release.key
    
    cat > /etc/apt/preferences.d/kolab <<FINISH
    Package: *
    Pin: origin obs.kolabsys.com
    Pin-Priority: 501
    FINISH
    
    apt-get update
    apt-get install kolab

And then run

.. parsed-literal::
    setup-kolab

Debian 8.0
==========

See also the usual steps, that you do for installing Kolab3 (see also :ref:`installation-debian`). We are adding another repository for the nightly built packages.

.. parsed-literal::
    username=tpokorra
    cat > /etc/apt/sources.list.d/kolab.list <<FINISH
    deb http://obs.kolabsys.com/repositories/Kolab:/3.4/Debian_8.0/ ./
    deb http://obs.kolabsys.com/repositories/Kolab:/3.4:/Updates/Debian_8.0/ ./
    deb http://obs.kolabsys.com/repositories/home:/$username:/branches:/Kolab:/Development/Debian_8.0/ ./
    FINISH
     
    wget http://obs.kolabsys.com/repositories/Kolab:/3.4/Debian_8.0/Release.key
    apt-key add Release.key; rm -rf Release.key
    wget http://obs.kolabsys.com/repositories/Kolab:/3.4:/Updates/Debian_8.0/Release.key
    apt-key add Release.key; rm -rf Release.key
    wget http://obs.kolabsys.com/repositories/home:/$username:/branches:/Kolab:/Development/Debian_8.0/Release.key
    apt-key add Release.key; rm -rf Release.key
    
    cat > /etc/apt/preferences.d/kolab <<FINISH
    Package: *
    Pin: origin obs.kolabsys.com
    Pin-Priority: 501
    FINISH
    
    apt-get update
    # workaround: first install apache2 from Jessie, we don't want apache2 from the Kolab repos which was needed for Wheezy
    apt-get install apache2 -t stable
    aptitude install kolab

And then run

.. parsed-literal::
    setup-kolab
