.. _deployment-redundant-servers:

=====================================
Kolab Deployment on Redundant Servers
=====================================

This deployment provides high-availability to a Kolab Groupware
deployment through redundancy of its underlying storage.

Please see either of the following sections for details on their
semantics:

    *   :ref:`deployment-redundant-drbd`
    *   :ref:`deployment-redundant-shared-storage`
    *   :ref:`deployment-redundant-glusterfs`

.. _deployment-redundant-drbd:

Using DRBD
==========

When used solely for redundancy, `DRBD`_ replicates the disk of a single
node to another node, implying the replica master is the active server,
while the slave remains passive. That is to say, that the replica master
**can**, while the replica slave **can not** access the data on the
replicated volume.

.. graphviz::

    digraph drbd {
            rankdir=LR;
            subgraph cluster_master {
                rankdir=TB;
                style=filled;
                color=lightgrey;
                node [style=filled];
                "OS Disk 0" [label="OS Disk",color=green];
                "Data Disk 0" [label="Data Disk",color=green];
                label = "Master";
            }

            subgraph cluster_slave {
                rankdir=TB;
                node [style=filled];
                "OS Disk 1" [label="OS Disk",color=green];
                "Data Disk 1" [label="Data Disk",color=red];
                label = "Slave";
            }

            "Data Disk 0" -> "Data Disk 1" [label="One-Way Replication"];
        }

In this scenario, the master is the active server running all Kolab
servers, while the slave is completely passive (it cannot write to the
disk being replicated). A failover would ensure the master is not
running any longer, and start the services on the slave -- which
therefore becomes the master.

In a more complex scenario, two separate volumes could be replicated in
an cross-link scenario, allowing the resources of both nodes to be used
in parallel, establishing a limited form of load-balancing.

.. graphviz::

    digraph drbd {
            rankdir=LR;
            subgraph cluster_master {
                rankdir=TB;
                style=filled;
                color=lightgrey;
                node [style=filled];
                "OS Disk 0" [label="OS Disk",color=green];
                "Data Disk 0" [label="Data Disk",color=green];
                "Data Disk 1" [label="Data Disk",color=red];
                label = "Master";
            }

            subgraph cluster_slave {
                rankdir=TB;
                style=filled;
                color=lightgrey;
                node [style=filled];
                "OS Disk 1" [label="OS Disk",color=green];
                "Data Disk 2" [label="Data Disk",color=red];
                "Data Disk 3" [label="Data Disk",color=green];
                label = "Slave";
            }

            "Data Disk 0" -> "Data Disk 2" [label="One-Way Replication"];
            "Data Disk 3" -> "Data Disk 1" [label="One-Way Replication"];

            "LDAP?" -> "Data Disk 0";

            "Data Disk 3" -> "IMAP?" [dir=back];
        }

Using DRBD in a so-called *dual-primary* mode requires the use of a
*shared filesystem* such as *Global File System* (GFS, not to be
confused with GlusterFS).

Designing, installing, configuring and maintaining a DRBD cluster is
beyond the scope of this document, and not commonly a solution the Kolab
community supports.

For more assistence, please consider contacting a local IT solutions
provider, `Kolab Systems AG`_ or any its `Certified Partners`_.

.. _deployment-redundant-shared-storage:

Using Shared Storage
====================

Shared storage is usually external to node(s),

SAN
---

NAS
---

.. _deployment-redundant-glusterfs:

Using GlusterFS
===============

.. graphviz::

    digraph glusterfs {
            compound=true;

            rankdir=TB;

            subgraph cluster_gfs0 {
                label = "GlusterFS";

                rankdir=LR;

                subgraph cluster_gfs1 {
                    label = "GlusterFS Node 1";

                    rankdir=TB;

                    "OS Disk 2" [label="OS Disk"];
                    "Data Disk 2" [label="Data Disk"];
                    "OS Disk 2" -> "Data Disk 2" [style=invis];
                }

                subgraph cluster_gfs2 {
                    label = "GlusterFS Node 2";

                    rankdir=TB;

                    "OS Disk 3" [label="OS Disk"]
                    "Data Disk 3" [label="Data Disk"];
                    "OS Disk 3" -> "Data Disk 3" [style=invis];
                    "Data Disk 3" -> "Data Disk 2" [dir=both];
                }

                { rank=same; "OS Disk 2", "OS Disk 3" }
                { rank=same; "Data Disk 2", "Data Disk 3" }
            }

            subgraph cluster_kolab0 {
                label = "Kolab";

                rankdir=LR;

                subgraph cluster_kolab1 {
                    label = "Kolab Server 1";

                    rankdir=TB;

                    "OS Disk 0" [label="OS Disk"];
                    "GFS Mount 0" [label="GFS Mount"];
                    "OS Disk 0" -> "GFS Mount 0" [style=invis];
                }

                subgraph cluster_kolab2 {
                    label = "Kolab Server 2";

                    rankdir=TB;

                    "OS Disk 1" [label="OS Disk"]
                    "GFS Mount 1" [label="GFS Mount"];
                    "OS Disk 1" -> "GFS Mount 1" [style=invis];
                }

                { rank=same; "OS Disk 0", "OS Disk 1", "OS Disk 2", "OS Disk 3" }
                { rank=same; "GFS Mount 0", "GFS Mount 1", "Data Disk 2", "Data Disk 3" }

            }

            "GFS Mount 0" -> "Data Disk 3" [lhead=cluster_gfs0];
            "GFS Mount 1" -> "Data Disk 2" [lhead=cluster_gfs0];

        }

.. _DRBD: http://www.drbd.org/
.. _Kolab Systems AG: https://kolabsys.com
.. _Certified Partners: https://kolabsys.com/company/partners
