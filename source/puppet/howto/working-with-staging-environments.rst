========================================
HOWTO: Working with Staging Environments
========================================

This HOWTO outlines what staging environments are, what you could be
using them for, and to what purpose they are implemented in our default
Puppet master server configuration, and the Puppet modules we provide.

Why Stage Environments?
=======================

Like in any development process, whether it be software, infrastructure
or the combined article, it is generally beneficial to have one or more
pre-production stages in which work can take place, of which the
consequences are not necessarily clear.

For a variety of reasons, the exact structure of you environment's
Puppet manifests and classes tends to be under continuous development.

Typos and syntax errors in Puppet manifests, classes and modules
notwithstanding, you will likely want to avoid automatically applying
any changes to your production environment -- the risk tends to be it
stops making you money or costs you a bunch should it stop functioning.

Should everything go through rather smoothly, however, then the result
of the changes applied is still not necessarily the result actually
desired. Multiple iterations of modifications may be required to get the
desired state described well enough.

When such changes (and their iterations) accumulate, the divergent
nature of the development stage makes it harder to appreciate the
consequences of applying any changes to the production environment.
Furthermore, multiple topics may be in development in parallel, and some
may be ready for promotion, while others may not.

Such risky, asynchronous development must converge in a controlled
fashion, and verified the upgrade path for, in a stage between
development and production -- *testing*, perhaps.

Description of Default Environment Stages
=========================================

The modules and usually also the domain's manifests tend to use a source
code management repository for revision control, and in our case this is
GIT.

GIT makes it easy to read logs, review commits and merge, cherry-pick or
otherwise promote changes.

**development**

    The development environment stage is intended for free-for-all,
    lather-rinse-repeat type of environments.

    Several of many things are in development, including systems,
    services, infrastructure topology and applications.

    Application developers typically have full access to the systems in
    this stage, software is not necessarily running based on packaged or
    released versions, packages such as ``git`` and other development
    utilities are installed, and the update policy might amount to as
    much as "apply all of them as soon as they become available".

    As such, the development environment is highly volatile, and because
    too many people can mess around with it too much, should be
    completely reproducible fast, cheaply and from scratch.

    As such, while monitoring and trending is useful -- for your
    developers to autonomously recognize the current state, rather than
    ask you -- but the alerting policy may be different.

**testing**

    A pre-production staging environment, with intended uses of
    Quality Assurance (of applications developed) and verification of
    upgrade paths.

    For each one of the pending updates to production, and often a
    combination of multiple pending updates and/or upgrades, one resets
    the testing environment to the equivalent state of the (then
    current) production environment, and attempt to complete the update
    successfully.

**production**

    The production environment is your workhorse. This is a look-then-
    look-again-and-dont-touch environment.

System Administrator Workflow Diagram
=====================================

The following diagram depicts the workflow for a System Administrator to
apply changes, have the changes applied to each environment, and be
provided with the required feedback on its success or failure.

.. graphviz::

    digraph architecture {
            rankdir = LR;
            splines = true;
            overlab = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11];
            node [shape=record, fontname=Calibri, fontsize=11];

            subgraph cluster_puppet {
                    label = "Puppet Infra";

                    color = "white";
                    style = "filled";

                    "git", "puppet", "dashboard";
                    "git" -> "puppet" [label="(2)"];
                }

            subgraph cluster_server {
                    label = "example.org environments";

                    color = "white";
                    style = "filled";

                    "development" [color=gray50,style=filled];
                    "testing" [color=gray50,style=filled];
                    "production" [color=gray50,style=filled];
                }

            "development" ->
                "testing" ->
                "production";

            "puppet" -> "development" [label="(3)"];
            "puppet" -> "testing" [label="(4)"];
            "puppet" -> "production" [label="(5)"];

            "development" -> "dashboard" [label="(6)"];
            "testing" -> "dashboard" [label="(6)"];
            "production" -> "dashboard" [label="(6)"];

            "sysadmin" -> "git" [label="(1)"];
            "sysadmin" -> "dashboard" [dir=back,label="(7)"];
        }

(1) A system administrator commits a change to git, and pushes the
    changes back.

    .. NOTE::

        Note that a commit happens on a branch, and your branches could
        be named *development*, *testing* and *production*, or you could
        have multiple *remotes* to differentiate write- and/or read-
        access authorization. Furthmore, you could put review utilities
        and continued integration facilities in.

(2) The Puppet server is itself managed by Puppet, and fetches new
    revisions of the configured git repositories during every run.

    The run interval is normally 30 minutes, so it may take up to 30
    minutes before the change is at all available to the Puppet master
    itself, and up to another 30 minutes before the changes are applied
    to relevant Puppet clients.

(3) The *development* environment is configured to apply all changes
    automatically, except for resources that have specifically been
    supplied a ``noop => true`` meta-parameter -- this is Puppet-speak.

(4) The *testing* environment still applies configuration changes
    automatically, and is supposed to be treated as such, in that it
    retains a state somewhat comparable to current production and few
    steps beyond that.

(5) The *production* environment does **not** apply **any** change
    automatically, except for resources that have specifically been
    supplied a ``noop => false`` meta-parameter -- again, Puppet speak.

(6) Each of the systems in each of the environments reports back to the
    Puppet master server. This master server is configured to submit the
    report to a dashboard web interface.

(7) A system administrator can review the current and past states of the
    managed system resources.

These steps bring the required feedback cycle full circle.

