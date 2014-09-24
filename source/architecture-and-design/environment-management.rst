======================
Environment Management
======================

The ability to manage one or more complete environments depends on at
least one but more likely multiple of the following capabilities of the
infrastructure as a whole, and IT processes associated with them;

*   :ref:`arch-system-life-cycle-management`
*   Inventory
*   Configuration Management
*   Standard Operating Procedure Control
*   Monitoring
*   Trending
*   :ref:`arch-log-centralization-analysis-and-storage`

Industry-Standard Components for Environment Management
=======================================================

Environments of a distributed nature will have found that determining
the cause of a system or service failure, the analysis of an
application's behaviour, and general monitoring of the environment's
health is a critical element in reducing the effort spent in collecting
and analyzing the information necessary to keep systems and services
running, maintain audit trails and/or answer (support) questions on
system and service performance.

.. _arch-system-life-cycle-management:

System Life-Cycle Management
============================

Not unlike many other life-cycles, an individual system's life-cycle
can be divided in to three main stages of *birth*, *life* and *death*.
If you want or need to, you may include an additional stage of
*retirement*, in which the system cannot yet be purged in full, and
needs to stay around for a little while longer, but not participate.

The distinction between these stages of life can be construed as
follows:

**Birth**

    The node's container is provided, the operating system is installed,
    and the node is rebooted in to its newly provisioned operating
    system. Next, *life* begins.

    This stage corresponds with the provisioning of a system. It is best
    practice to keep the provisioning stage to a minimal level, and only
    perform just enough tasks to allow the node to come back up after
    its operating system installation reboot with enough capacity to
    start *life*. Some such configuration may include networking
    configuration, for example, and perhaps also additional disk
    configuration.

**Life**

    During a system's life, it will need to be installed some software
    onto, which will need to be configured, of which the configuration
    may change during its lifetime. Software may be updated, and
    operational changes (of a temporary nature) may need to be applied.

    This stage corresponds with two separate yet interconnected
    operations:

        #.  Run-time Configuration Management

        #.  Execution of Standard Operating Procedures

**Death**

    Albeit the terminology being mostly self-explanatory, the death of
    a system includes replacement of the operating system (for it then
    becomes a different node in the same container) and the obsoletion
    of a node (by a "better" node).

.. _arch-log-centralization-analysis-and-storage:

Log Centralization, Analysis & Storage
======================================

This section outlines the functional components for an industry-standard
infrastructure with common components used for log centralization,
analysis and storage, providing environments with the capability to cope
with many dozens of millions of relevant log messages daily.

**Without** the ability to centralize, analyze and store log messages
and event notifications, the following scenarios are but a few examples
of common, every day occurrences;

*   **A message's delivery is delayed**;

    #.  A question about the message's delay is raised and logged
        through the appropriate channels.

    #.  A system administrator with an appropriate level of
        authorization to do so is assigned the task of discovery.

    #.  The system administrator iterates over all systems, using
        ``grep`` on ``/var/log/maillog`` to find all log lines
        mentioning the sender or intended recipient(s).

    #.  This results in a large number of so-called Queue IDs, one of
        which is associated with the original message in question (the
        delayed one).

    #.  Each Queue ID is associated with a number of other Queue IDs
        when;

        *   The message is delivered remotely,
        *   The message passes Anti-Spam & Anti-Virus and is re-inserted
            in to the MTA,
        *   The message is finally delivered.

    #.  For each of the original Queue IDs, the system administrator
        searches for log messages also mentioning the Queue ID.

    #.  For each set of log messages related to each Queue ID, the
        system administrator determines whether the log messages are in
        fact about the original message in question.

    #.  The delay is determined to exist or have existed, and the
        original question can be answered, however likely not resolved.

    #.  The system administrator is prompted to address the cause of the
        delay.

*   **A user says never to have received a particular message**;

    *   Steps #1, #2, #4 through #8 of the aforementioned process are
        repeated, with step #3 being substituted for the following:

        #.  Because the nature of this question is one likely to occur
            later in time (i.e. far past the original events in
            question) rather than sooner, the local systems' log file
            retention policy may have already rotated, rotated and
            compressed, or even rotated, compressed and subsequently
            purged the relevant log file off of the local filesystem.

            It must therefore first be determined *when* the original
            message was sent, *when* it should have been received
            -- standard settings put this period on 5 times 24 hours --,
            and subsequently *where* the relevant log messages might
            still be available (ranging from local filesystem to off-
            site tape).

        #.  In addition to the logs about MSA, MTA and MDA delivery
            statuses, the message may in fact have been;

            *   received, read, deleted and purged from one's mailbox.

            *   filtered in to a folder the user has forgotten to;

                *   subscribe to,

                *   read messages from.

            These situations require means that are beyond the
            capabilities of simple log centralization and analysis,
            however.

*   **Log messages go unnoticed**

    Bearing in mind there's dozens of millions of log messages, finding
    the errors, alerts and notices among them is a task you would rather
    see automated.

    Error log messages, alerts, and notices will likely go unnoticed
    unless they are actively aggregated, analyzed and used as triggers
    for follow-up.

    Open Source log analysis technology allow for the storing in to
    multiple storage systems, and add triggering certain actions such as
    pager duty / Nagios / email / etc.

Log Centralization at Minimum
-----------------------------

Required functional components for the minimal functionality in log
centralization are as follows (pre-existing components grayed):

.. graphviz::

    digraph architecture {
            rankdir = LR;
            splines = true;
            overlab = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11];
            node [shape=record, fontname=Calibri, fontsize=11];

            "Log Source(s)" [color=gray50,style=filled];

            "Log Source(s)" ->
                "Central Log Server";
        }

This allows an environment to;

*   No longer depend on the individual system's local disk space for the
    retention of log messages, of which disk space consumed can grow
    beyond a reasonable size to be allocated to an individual system,
    and must be considered more appropriately spent on the runtime data
    for applications and services,

*   No longer require the continued availability of the individual
    system -- with its local disk space -- for the purpose of log
    message retention, while the system may corrupt or be discarded,

*   Perform manual analysis across the number of systems spent on
    centralization rather than the number of individual log sources.

Log Centralization with Analysis
--------------------------------

The environment's capabilities yet still insufficient, however, for no
analysis is possible on the current *flat file* structure of the log
messages written to disk. No two messages can be correlated, not
automatically, and no oversight view can be created.

Introducing analysis in to the log infrastructure causes the former
diagram to be extended as such (gray items already existed):

.. graphviz::

    digraph architecture {
            rankdir = LR;
            splines = true;
            overlab = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11];
            node [shape=record, fontname=Calibri, fontsize=11];

            "Log Source(s)" [color=gray50,style=filled];
            "Central Log Server" [color=gray50,style=filled];

            "Log Source(s)" ->
                "Central Log Server" ->
                "Log Analysis" ->
                "Log Storage";
        }

Under these circumstances, the features offered by the centralized
logging system now include, in addition to the former;

*   Log analysis to allow system administrators to query for correlated
    log messages.

However, the log messages can no longer be stored in to the same *flat
file* storage as these effectively do not allow querying.

Log Centralization, Analysis & Storage with Redundancy
------------------------------------------------------

The aforementioned diagrams are simplified overviews of functional
components however, and it is crucial to appreciate;

*   The use of TCP to transmit syslog messages on to a centralized
    syslog server is lossless compared to the use of UDP, but
    manipulates message payload to fit TCP datagram sizes, potentially
    rendering syslog unavailable should the TCP connection not be
    established and responsive, potentially locking up the
    system/service issuing log messages.

*   The use of the UDP protocol ensures fast dismissal of individual log
    messages, but the receiving end MUST be available and responsive for
    the message is otherwise lost.

*   Not all log messages (of an application) are suitable for inclusion
    in a syslog stream, such as those that implement the `LEMONADE`_
    architecture for groupware environments.

*   Avoidance of congestion is crucial to maintain the ability to
    continuously correlate log messages and event notifications, and
    maintain accurate statistics.

A practical implementation of an environment therefore features;

*   Redundant paths for individual log messages,

*   (optionally) load-balanced recipients of log messages,

*   Sufficient capacity and sufficient scalability for real-time and
    near real-time analysis of larger environments with greater volumes
    of traffic.

And would look like the following diagram;

.. graphviz::

    digraph architecture {
            rankdir = LR;
            splines = true;
            overlab = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11];
            node [shape=record, fontname=Calibri, fontsize=11];

            "Log Source - Central Log Server" [shape=point,color=gray50];
            "Log Source #1", "Log Source #2" -> "Log Source - Central Log Server" [dir=none];

            "Central Log Server - Log Source" [shape=point,color=gray50];
            "Central Log Server - Log Analysis" [shape=point,color=gray50];

            "Central Log Server - Log Source" -> "Central Log Server #1", "Central Log Server #2";
            "Central Log Server #1", "Central Log Server #2" -> "Central Log Server - Log Analysis" [dir=none];

            "Log Analysis - Central Log Server" [shape=point,color=gray50];
            "Log Analysis - Log Storage" [shape=point,color=gray50];

            "Log Analysis - Central Log Server" -> "Log Analysis #1", "Log Analysis #2";
            "Log Analysis #1", "Log Analysis #2" -> "Log Analysis - Log Storage";

            "Log Storage - Log Analysis" [shape=point,color=gray50];

            "Log Storage - Log Analysis" -> "Log Storage #1", "Log Storage #2";


            "Log Source - Central Log Server" -> "Central Log Server - Log Source" [dir=none];
            "Central Log Server - Log Analysis" -> "Log Analysis - Central Log Server" [dir=none];
            "Log Analysis - Log Storage" -> "Log Storage - Log Analysis" [dir=none];

        }

.. _LEMONADE: https://tools.ietf.org/html/rfc5442
