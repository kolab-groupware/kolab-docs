.. _installation-guide-preparing-the-system:

====================
Preparing the System
====================

.. _installation-guide-preparing-the-system-partitioning:

Partitioning
============

When installing the Kolab server, we recommend using LVM when
partitioning the system. The following directories could benefit from
being on separate logical volumes, leaving about 10% of raw disk space
in the volume group unallocated:

*   :file:`/var/lib/dirsrv/`
*   :file:`/var/lib/mysql/`
*   :file:`/var/lib/imap/`
*   :file:`/var/spool/imap/`

.. NOTE::

    Partition and/or divide into logical volumes, configure the mount
    points and mount the filesystems prior to the installation of
    packages, as packages may deploy files into these directories.

Should you decide to partition only after the packages have already been
installed, or after the deployment has already been used, first mount
the filesystems somewhere else and synchronize the contents from the
original directories over to the new filesystem hierarchy. Please note
services should be stopped before doing so, or only corrupt data will be
transfered. Remove the original contents of the filesystem after having
synchronized, then mount the filesystems under their target mount
points.

For large or multi-domain installations, we suggest moving
:file:`/var/lib/imap/` and :file:`/var/spool/imap/` to
:file:`/srv/imap/[$domain/]config/` and
:file:`/srv/imap/[$domain/]default/` respectively.

In allowing :file:`/srv/imap/` to be one separate partition, backup
using LVM snapshots is easier. Note that ``$domain`` in the
aforementioned path is optional, and should only be used when multiple,
but separate, isolated IMAP servers are to be started.

.. NOTE::

    When partitions are mounted under the aforementioned directories,
    they do not necessarily have the correct filesystem permissions any
    longer. The following is a list of default permissions.

    .. parsed-literal::

        drwxr-xr-x.  3 root  root  4096 May 11 11:49 /var/lib/dirsrv/
        drwxr-xr-x. 7  mysql mysql 4096 May 11 15:34 /var/lib/mysql/
        drwxr-x---. 20 cyrus mail  4096 May 11 17:04 /var/lib/imap/
        drwx------. 3  cyrus mail  4096 May 11 15:36 /var/spool/imap/

.. _installation-guide-preparing-the-system-selinux:

SELinux
=======

Not all components of Kolab Groupware are currently completely
compatible with running under SELinux enforcing the targeted policy.

Please consider configuring SELinux to be permissive. Please let us
know what AVC denials occur so we can work on fixing the issue.

.. WARNING::

    The Kolab Web Administration Panel and Cyrus IMAP against the Kolab
    SASL authentication daemon currently require SELinux **NOT**
    enforcing the targeted policy.

To view the current mode SELinux operates in, execute the following
command:

.. parsed-literal::

    # :command:`sestatus`

To temporarily disable SELinux's enforcement of the targeted policy
(without rebooting the system), issue the following command:

.. parsed-literal::

    # :command:`setenforce 0`

To disable SELinux's enforcement of the targeted policy in a manner
persistent across system restarts, edit :file:`/etc/selinux/config` and set
SELINUX to permissive rather than enforcing. Doing so also changes the
``Mode from config file:`` line in the output of :command:`sestatus`.

.. _installation-guide-preparing-the-system-firewall:

System Firewall
===============

Kolab Groupware deliberately does not touch any firewall settings,
perhaps wrongly assuming you know best. Before you continue, you should
verify your firewall allows the standard ports used with Kolab
Groupware. These ports include:

+------+-----------+------------------------------------------+
| Port | Protocol  | Description                              |
+======+===========+==========================================+
| 25   | tcp       | Used to receive emails.                  |
+------+-----------+------------------------------------------+
| 80   | tcp       | Used for web interfaces.                 |
+------+-----------+------------------------------------------+
| 110  | tcp       | Used for POP.                            |
+------+-----------+------------------------------------------+
| 143  | tcp       | Used for IMAP.                           |
+------+-----------+------------------------------------------+
| 389  | tcp       | Used for LDAP directory services.        |
+------+-----------+------------------------------------------+
| 443  | tcp       | Used for secure web interfaces.          |
+------+-----------+------------------------------------------+
| 465  | tcp       | Used for secure mail transmission.       |
+------+-----------+------------------------------------------+
| 587  | tcp       | Used for secure mail submission.         |
+------+-----------+------------------------------------------+
| 636  | tcp       | Used for secure LDAP directory services. |
+------+-----------+------------------------------------------+
| 993  | tcp       | Used for secure IMAP.                    |
+------+-----------+------------------------------------------+
| 995  | tcp       | Used for secure POP.                     |
+------+-----------+------------------------------------------+
| 4190 | tcp       | Used for Managesieve.                    |
+------+-----------+------------------------------------------+
| 8080 | tcp       | Used for Manticore.                      |
+------+-----------+------------------------------------------+

CentOS / RHEL 6
---------------

Summarizing these changes into /etc/sysconfig/iptables, working off of
an original, default installation of Enterprise Linux 6, this file would
look as follows:

.. parsed-literal::

    # Firewall configuration written by system-config-firewall
    # Manual customization of this file is not recommended.
    \*filter
    :INPUT ACCEPT [0:0]
    :FORWARD ACCEPT [0:0]
    :OUTPUT ACCEPT [0:0]
    -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    -A INPUT -p icmp -j ACCEPT
    -A INPUT -i lo -j ACCEPT
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 25 -j ACCEPT
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 110 -j ACCEPT
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 143 -j ACCEPT
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 389 -j ACCEPT
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 465 -j ACCEPT
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 587 -j ACCEPT
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 636 -j ACCEPT
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 993 -j ACCEPT
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 995 -j ACCEPT
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 4190 -j ACCEPT
    -A INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT
    -A INPUT -j REJECT --reject-with icmp-host-prohibited
    -A FORWARD -j REJECT --reject-with icmp-host-prohibited
    COMMIT

After changing /etc/sysconfig/iptables, execute a service restart:

.. parsed-literal::

    # :command:`service iptables restart`

CentOS / RHEL 7
---------------

CentOS / RHEL 6 is using the ``firewalld`` to manage the kernel firewall.
You've to make use of the ``firewall-cmd`` command to add new rules to open the
required ports.

This script will open the required ports/services and make this changes
permanent and reboot-save.

.. parsed-literal::

    for s in ssh http https pop3s imaps smtp ldap ldaps
    do
        firewall-cmd --permanent --add-service=$s
    done
    for p in 110/tcp 143/tcp 587/tcp
    do
        firewall-cmd --permanent --add-port=$p
    done
    firewall-cmd --reload

System Users
============
 
*   No user or group with IDs 412, 413 or 414 may exist on the system
    prior to the installation of Kolab.

*   No user or group with the names kolab, kolab-n or kolab-r may exist
    on the system prior to the installation of Kolab.

.. _installation-guide-preparing-the-system-hostname-and-fqdn:

The System Hostname and FQDN
============================

The setup procedure of Kolab Groupware also requires that the Fully
Qualified Domain Name (FQDN) for the system resolves back to the system.
If the FQDN does not resolve back to the system itself, the Kolab
Groupware server components will refer to the system by the configured
or detected FQDN, but will fail to communicate with one another.

.. NOTE::

    Please see `Why Your System Should Have a Proper FQDN`_ for more
    information.

Should the FQDN of the system (found with hostname -f) be, for example,
``kolab.example.org``, then ``kolab.example.org`` should resolve to the
IP address configured on one of the network interfaces not the loopback
interface, and the IP address configured on said network interface
should have a reverse DNS entry resulting in at least
``kolab.example.org``.

Example Network and DNS Configuration
-------------------------------------

The following lists an example network and DNS configuration for a Kolab
Groupware server.

.. parsed-literal::

    # :command:`hostname -f`
    kolab.example.org
    # :command:`ping -c 1 kolab.example.org`
    PING kolab.example.org (192.168.122.40) 56(84) bytes of data.
    64 bytes from kolab.example.org (192.168.122.40): icmp_seq=1 ttl=64 time=0.014 ms

    --- kolab.example.org ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.014/0.014/0.014/0.000 ms
    # :command:`ip addr sh eth0`
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
        link/ether 52:54:00:72:10:83 brd ff:ff:ff:ff:ff:ff
        inet 192.168.122.40/24 brd 192.168.122.255 scope global eth0
        inet6 fe80::5054:ff:fe72:1083/64 scope link
        valid_lft forever preferred_lft forever

The following depicts what services like LDAP and others will be using:

.. parsed-literal::

    # :command:`python -c 'import socket; print socket.getfqdn();'`
    kolab.example.org

If you want to quickly fix your system's FQDN resolving back to your
server, an entry in :file:`/etc/hosts` suffices for the time being:

.. parsed-literal::

    # :command:`echo "$(ip addr sh eth0 | grep 'inet ' | awk '{print $2}' | cut -d'/' -f 1) $(hostname -f)" >> /etc/hosts`

LXC Containers
==============

LXC containers ("chroots on steroids") need ``/dev/shm/`` mounted
read/write for user accounts.

The permissions on /dev/shm/ need to be as follows:

.. parsed-literal::

    # ls -ld /dev/shm/
    drwxrwxrwt 2 root root        40 2012-11-20 20:34 shm

To make sure the permissions are correct even after a reboot, make sure
``/etc/fstab`` contains a line similar to the following:

.. parsed-literal::

    none /dev/shm tmpfs rw,nosuid,nodev,noexec 0 0

Note that alongside ``/dev/shm`` problems, resolving hostnames (especially
``localhost`` to ``127.0.0.1``, or inversely, ``127.0.0.1`` to
``localhost``) have also been reported.
