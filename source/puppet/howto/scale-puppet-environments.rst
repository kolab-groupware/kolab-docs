=========================
Scale Puppet Environments
=========================

In this HOWTO:

*   Using Puppet with Git and GlusterFS
*   Load-balancing Puppet Masters
*   Cascading Puppet Masters
*   Separating the Dashboard UI interface
*   Separating the Reporting

Load-balancing Puppet Masters
=============================

Initially, one Puppet master may suffice for environment, though the
Puppet master may become very busy serving:

*   The Puppet master catalog server,
*   The Puppet certificate authority,
*   Git repositories (two per domain, one per module),
*   The Puppet reporting URL (puppet-dashboard),
*   The Puppet database (puppetdb),
*   MySQL for the Puppet dashboard,
*   The Puppet dashboard user interface (dynamic pages),
*   The Puppet dashboard user interface (static contents)

Double the Puppet Masters
-------------------------

In a simplified overview, the connection model between the components
that make up a Puppet environment, looks as follows:

.. graphviz::

    digraph puppet {
            rankdir = TB;
            splines = true;
            overlab = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11];
            node [style=filled, shape=record, fontname=Calibri, fontsize=11];

            subgraph cluster_puppet {
                    label = "Puppet Infrastructure";
                    "master";
                    "dashboard";
                    "db";
                    "mysql";
                }

            "agent" -> "master" [dir=none];
            "master" -> "git", "dashboard", "db" [dir=none];
            "dashboard" -> "mysql" [dir=none];
            "client" -> "dashboard", "git" [dir=none];
        }

A simple extension to this environment is to supply multiple Puppet
masters.

A pre-requisite becomes to either;

*   Split the Puppet certificate authority,

*   Share (at least) :file:`/var/lib/puppet/ssl/` between Puppet
    masters.

Note, however, it is recommended to not only share
:file:`/var/lib/puppet/ssl/`, but other directories as well. One example
is :file:`/var/lib/puppet/environments/`, which is were your
environments are served from, and another example is
:file:`/var/lib/puppet/files/`, the location of your private and/or
sensitive files.

Not sharing :file:`/var/lib/puppet/ssl/` requires you to separate the
Puppet certificate authority, for otherwise certificates will fail to
validate and agents have a semi-random chance of hitting the certificate
authority that does trust the agent's client certificate.

Failing to share the additional directories -- in addition to
:file:`/var/lib/puppet/ssl/` -- creates a scenario in which an agent
hitting one Puppet master then another receives two different catalogs
(and depending on your environment settings may apply changes
effectively going back and forth between two versions of its desired
state).

It is perfectly possible to balance traffic between multiple Puppet
masters without using proper load-balancing techniques; A ``puppet`` IN
A DNS RR could hold the IP addresses of the extra Puppet masters in
addition to the original one.

.. NOTE::

    Note however such environment does not introduce high-availability
    through load-balancing.

    If a Puppet master becomes unavailable, agents will still be
    attempting to connect to it.

.. parsed-literal::

    # :command:`host puppet`
    puppet.example.org has address 172.16.1.10
    puppet.example.org has address 172.16.4.26
    (...)

The environment would look as follows (new components in green):

.. graphviz::

    digraph puppet {
            rankdir = TB;
            splines = true;
            overlab = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11];
            node [style=filled, shape=record, fontname=Calibri, fontsize=11];

            subgraph cluster_puppet {
                    label = "Puppet Infrastructure";

                    "master #1" [label="master"];
                    "master #2" [label="master",color=green];

                    "agent-master" [shape=point,color=gray50];
                    "master-resources" [shape=point,color=gray50];

                    "dashboard";
                    "db";
                    "mysql";

                    "shared filesystem(s)" [color=green];

                }

            "agent" -> "agent-master" [dir=none];
            "agent-master" -> "master #1", "master #2" [dir=none];

            "master #1", "master #2" -> "master-resources" [dir=none];
            "master-resources" -> "git", "dashboard", "db" [dir=none];

            "master-resources" -> "shared filesystem(s)" [dir=none];

            "dashboard" -> "mysql" [dir=none];
            "client" -> "dashboard", "git" [dir=none];
        }

For true scalability, each component needs be separated from each other
component, scale up (or down) by itself, and remain available.

Further, it is recommended to back up the Puppet DB with PostgreSQL for
larger environments (>= 100 nodes).

.. graphviz::

    digraph puppet {
            rankdir = TB;
            splines = true;
            overlab = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11];
            node [style=filled, shape=record, fontname=Calibri, fontsize=11];

            subgraph cluster_puppet {
                    label = "Puppet Infrastructure";

                    "master #1" [label="master"];
                    "dashboard #1" [label="dashboard(report)"];
                    "dashboard #3" [label="dashboard(ui)"];
                    "db #1" [label="db"];
                    "psql #1" [label="psql"];
                    "mysql #1" [label="mysql"];
                }

            "git #1" [label="git"];

            "agent" -> "master #1" [dir=none];

            "master #1" -> "glusterfs" [dir=none];

            "master #1" -> "git #1" [dir=none];
            "git #1" -> "glusterfs" [dir=none];

            "master #1" -> "dashboard #1" [dir=none];
            "dashboard #1" -> "glusterfs" [dir=none];
            "dashboard #1" -> "mysql #1" [dir=none];

            "master #1" -> "db #1" [dir=none];
            "db #1" -> "psql #1" [dir=none];

            "client" -> "git #1" [dir=none];
            "client" -> "dashboard #3" [dir=none];
            "dashboard #3" -> "glusterfs" [dir=none];
            "dashboard #3" -> "mysql #1" [dir=none];
        }

.. graphviz::

    digraph puppet {
            rankdir = TB;
            splines = true;
            overlab = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11];
            node [style=filled, shape=record, fontname=Calibri, fontsize=11];

            "load-balancer git" [label="load-balancer"];

            subgraph cluster_puppet {
                    label = "Puppet Infrastructure";

                    subgraph cluster_masters {
                            label = "Puppet Masters";

                            "master #1" [label="master"];
                            "master #2" [label="master"];
                        }

                    subgraph cluster_dashboards {
                            label = "Puppet Dashboards";

                            "dashboard #1" [label="dashboard(report)"];
                            "dashboard #2" [label="dashboard(report)"];
                            "dashboard #3" [label="dashboard(ui)"];
                            "dashboard #4" [label="dashboard(ui)"];
                        }

                    subgraph cluster_puppetdb {
                            label = "Puppet DBs";

                            "db #1" [label="db"];
                            "db #2" [label="db"];

                            "load-balancer db-psql" [label="load-balancer"];

                            subgraph cluster_psql {
                                    label = "PostgreSQL Servers";

                                    "psql #1" [label="psql"];
                                    "psql #2" [label="psql"];
                                }
                        }

                    subgraph cluster_mysql {
                            label = "MySQL Servers";

                            "mysql #1" [label="mysql"];
                            "mysql #2" [label="mysql"];
                        }

                    "load-balancer agent-master" [label="load-balancer"];

                    "load-balancer master-db" [label="load-balancer"];

                    "load-balancer master-dashboard" [label="load-balancer"];

                    "load-balancer client-dashboard" [label="load-balancer"];

                    "load-balancer dashboard-mysql" [label="load-balancer"];

                }

            "git #1" [label="git"];
            "git #2" [label="git"];

            "agent" -> "load-balancer agent-master" [dir=none];
            "load-balancer agent-master" -> "master #1", "master #2" [dir=none];

            "master #1", "master #2" -> "glusterfs" [dir=none];

            "master #1", "master #2" -> "load-balancer git" [dir=none];
            "load-balancer git" -> "git #1", "git #2" [dir=none];
            "git #1", "git #2" -> "glusterfs" [dir=none];

            "master #1", "master #2" -> "load-balancer master-dashboard" [dir=none];
            "load-balancer master-dashboard" -> "dashboard #1", "dashboard #2" [dir=none];
            "dashboard #1", "dashboard #2" -> "glusterfs" [dir=none];
            "dashboard #1", "dashboard #2" -> "load-balancer dashboard-mysql" [dir=none];

            "master #1", "master #2" -> "load-balancer master-db" [dir=none];
            "load-balancer master-db" -> "db #1", "db #2" [dir=none];
            "db #1", "db #2" -> "load-balancer db-psql" [dir=none];
            "load-balancer db-psql" -> "psql #1", "psql #2" [dir=none];

            "client" -> "load-balancer git" [dir=none];
            "client" -> "load-balancer client-dashboard" [dir=none];
            "load-balancer client-dashboard" -> "dashboard #3", "dashboard #4" [dir=none];
            "dashboard #3", "dashboard #4" -> "glusterfs" [dir=none];
            "dashboard #3", "dashboard #4" -> "load-balancer dashboard-mysql" [dir=none];

            "load-balancer dashboard-mysql" -> "mysql #1", "mysql #2" [dir=none];
        }
