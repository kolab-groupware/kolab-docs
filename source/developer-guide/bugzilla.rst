========
Bugzilla
========

Our `bugzilla`_ is our primary tracker for tickets that involve our
development, release, planning, and project- and product-management
processes.

This document describes how you should consider working with Bugzilla.

.. _bugzilla-cloning-tickets:

Cloning Tickets
===============

Cloning tickets is a means to allow different target streams, such as;

*   A fix for version ``1.0`` versus a fix for a version ``2.0`` to be
    worked on with different priority, different timelines and possibly
    result in a different implementation of the resolution.

    In this case, the ticket should be cloned in to its two parts, when
    the ticket is initially assigned to a developer.

    A typical scenario in which this sort of multi-version ticket is
    prevelant is with product streams supported for longer periods of
    time.

    .. NOTE::

        Note that a ticket clone normally causes the clone to depend on
        the original ticket. The dependency should be evaluated
        separately, in that the ticket for the later version should
        probably block the ticket for the earlier version of the
        software, and not the other way around.

        It is normal to simply remove the dependency, however, and
        instead add a :ref:`bugzilla-see-also` link.

*   A fix for versions ``1.0`` and ``1.1``, which are two versions
    likely less different from one another than ``1.0`` and ``2.0``,
    could in fact be the same fix applied to both branches.

    In this case, a developer does not need two versions of what is
    otherwise the same ticket. However when the ticket is
    :ref:`bugzilla-status-resolved`, further actions on the ticket would
    require cloned tickets.

    It is recommended that a developer clone the ticket as many times as
    necessary, since it is typically the developer who knows best what
    branches the fix has been applied to, and what (other) branches
    still need work. Splitting the ticket at this point allows the
    product to which the ticket's resolution is successfully applied to
    continue with the rest of their respective processes, while one or
    more branches for which more work may be needed, can be held back
    and/or continued to be worked on.

    Failing that, a developer should at least mention the commit IDs and
    branches to which such commit IDs have been committed and pushed (if
    all relevant branches have resolutions applied successfully). It
    will enable a release manager to take the appropriate actions.

Different People's Overview
===========================

Developer Overview
------------------

So what would a developer be looking at for a list of tickets that have
some level of significance for a developer?

The following items should be of interest:

*   Naturally, tickets assigned to you are considered of interest to
    you.

    As to the relevant states in which these tickets may be, we consider
    the following states of interest:

    *   :ref:`bugzilla-status-new`

        Tickets with status :ref:`bugzilla-status-new` assigned to you
        may include a request to provide an estimate.

    *   :ref:`bugzilla-status-assigned`

        New tickets in your queue, freshly assigned.

    *   :ref:`bugzilla-status-in_progress`

        Tickets you are working on currently.

    *   :ref:`bugzilla-status-reopened`

        Tickets you have (presumably) already worked on, that have
        failed Quality Assurance.

    *   :ref:`bugzilla-status-needsinfo`

        Though it is not clear whether additional information is
        requested of or by you, this list should be relatively short
        anyway.

Quality Assurance Engineer Overview
-----------------------------------

From the perspective of a Quality Assurance engineer, all tickets in
state :ref:`bugzilla-status-in_testing` are interesting.

Bugzilla Status
===============

The following is a description of each state used in Bugzilla, just to
clarify any ambiguity in the terminology used, and to make sure everyone
is up-to-date on the expectations created from a certain ticket being in
a certain status, and what is expected before it moves on to the next
status.

.. _bugzilla-status-unconfirmed:

UNCONFIRMED
-----------

A ticket starts in status :ref:`bugzilla-status-unconfirmed` to indicate
it has not yet been "triaged" -- see
:ref:`bugzilla-triaging-bugzilla-tickets`.

In our Bugzilla, the assignee at this point may be devel@lists.kolab.org
(as in: *"Nobody's working on this"*), or the assignee may be one
particular person or multiple people that is/are deemed suitable for
triaging.

In this status, a person looking at the ticket should confirm that;

*   The product and product component against which the ticket is
    created is accurate, including the platform and operating system
    field(s).

    .. TODO::

        Document an inventory of products and components along with the
        method of creating the inventory.

*   The version of Kolab Groupware or the version of the Kolab Groupware
    software component is indeed accurate, and still supported.

    .. TODO::

        Document the inventory of package versions, product streams and
        product versions that are supported, along with the methodology
        of creating such inventory.

*   The targeted version for the ticket to be resolved in is
    appropriate, in that we tend to not work backwards.

    As a rule of thumb, everything is first implemented and/or resolved
    in the future version of software, and only considered for
    backporting afterwards.

    Note that an issue against a version ``1.0.1``, that needs to be
    resolved in the next ``1.0`` version, would originally have a
    milestone of ``1.0-next``.

    If the upstream program however is further ahead (such as a ``1.1``
    series), a clone of the original ticket should be created for the
    ``1.0-next`` milestone, and depend on the original ticket which is
    then set against the ``1.1-next`` milestone.

    This is to aid release management in composing lists of tickets
    resolved in certain releases or packaged versions of software.

*   The necessary information needed to resolve the ticket is available,
    such as;

    For tickets of type *bug*:

    *   issue symptoms,

    *   related software versions,

    *   platform, and platform version,

    *   configuration of the software, and the environment (including
        the type of deployment architecture),

    *   and other information that allow the next person to receive the
        ticket to reproduce the original issue.

    For tickets of type *enhancement*:

    *   A genuine, accurate, unambiguous description of the requested
        functionality is supplied, i.e. NOT "wish I could do $x".

When the necessary information is provided, the ticket can move forward
to status :ref:`bugzilla-status-new`.

When a ticket is not yet complete, it may be set to
:ref:`bugzilla-status-needsinfo`.

In rare circumstances, an :ref:`bugzilla-status-unconfirmed` ticket may
be directly moved to status :ref:`bugzilla-status-closed` -- usually
along with a resolution of DUPLICATE, WONTFIX, DEFERRED or NOTABUG.

.. _bugzilla-status-new:

NEW
---

A ticket in status :ref:`bugzilla-status-new` is waiting to be assigned
to a developer, and may as such be taken on by a product manager instead.

This status is a placeholder for all inbound tickets; bugs, tasks and
enhancements alike. At this stage, the ticket is deemed sufficiently
detailed and feasible to result in resolution.

Before the ticket is assigned to an actual developer, the following
items need to be verified;

*   The :ref:`bugzilla-priority-and-severity` of the ticket,

*   The appropriate :ref:`bugzilla-assignee` for the ticket,

and possibly also (for product management and/or project management);

*   An estimation of the :ref:`bugzilla-effort-involved`,

*   The target milestone, or target milestones for all products and
    product components involved,

*   Any ticket(s) to which the ticket is related (see:
    :ref:`bugzilla-see-also`), or in to which the request splits out
    (see
    :ref:`bugzilla-example-cyrus-imapd-sieve-date-extension-support`).

.. _bugzilla-status-assigned:

ASSIGNED
--------

The ticket has been assigned, hopefully by someone sufficiently
knowledgeable and otherwise someone eligible to allocate community
and/or corporate resources to the resolution of the ticket.

.. IMPORTANT::

    If a ticket had originally requested an estimate of the
    :ref:`bugzilla-effort-involved`, the assignee should verify the
    ticket state has been changed by someone in a position to
    acknowledge the :ref:`bugzilla-effort-involved` is accepted.

When a ticket is assigned, all its dependencies should be in order, and
the assignee may find the ticket blocking other tickets.

It is now up to the assignee to;

*   Verify the ticket, so that it is understood;

    *   The target milestone indicated in the ticket is the earliest
        version of the software to which the resolution should apply,

    *   The issue resolution should first be created for and applied to
        the latest and greatest (i.e. "next") version of the software,

    *   The issue's resolution can indeed be backported to the targeted
        branch of software. See
        :ref:`bugzilla-requirements-for-backporting`.

    Should the former conditions or validation steps not be complete,
    such as when an issue's resolution can be created for and applied to
    the "next" version of the software, but not the "current stable"
    version of the software, then it is the developer's responsibility
    to contact product management.

    .. NOTE::

        Supported versions of software have a corresponding milestone
        available. See also
        :ref:`bugzilla-supported-versions-of-software`.

*   Start work on the ticket (and change the status to
    :ref:`bugzilla-status-in_progress`). This will indicate acceptance
    of the ticket.

*   Set the status back to :ref:`bugzilla-status-new` to refuse the
    ticket.

.. _bugzilla-status-in_progress:

IN_PROGRESS
-----------

While a ticket is in status :ref:`bugzilla-status-in_progress`, a
developer is actually working on the ticket.

While in this status ticket's assignee field **MUST** be set to the
physical human being performing the work.

A developer will ultimately have a patch or result of labour to be
committed and pushed out some place.

When the work is completed, and the issue's resolution has been made
available, the status of the ticket is to be moved to
:ref:`bugzilla-status-resolved`, usually with a resolution of FIXED.

It is the developer's responsibility to re-iterate the branches to which
any revisions or commit IDs related to the resolution have been
committed and pushed.

.. seealso::

    *   :ref:`bugzilla-cloning-tickets`

.. _bugzilla-status-resolved:

RESOLVED
--------

The RESOLVED status indicates that a commit has been made and pushed,
that is believed to resolve the issue (i.e. "fix the bug" or "implement
the enhancement").

It is the developer's responsibility to set a ticket to status RESOLVED.

Release engineering and project management are now responsible for the
ticket, however the assignee **SHOULD NOT** be changed from this point
on forward.

An extra ticket should be created for each target milestone in which the
resolution to this ticket is to be included (by creating a clone of this
ticket).

As the next status for the ticket could be either of the two following:

*   :ref:`bugzilla-status-pending_release`, which tends to be the status
    used to indicate the availability of the resolution can wait until
    the software is properly released,

*   :ref:`bugzilla-status-in_packaging`, which tends to indicate the
    resolution is packaged in the form of a patch or even a source code
    management repository snapshot.

.. _bugzilla-status-pending_release:

PENDING_RELEASE
---------------

A ticket set to PENDING_RELEASE is awaiting the upstream release of a
versioned piece of the software that includes the resolution to this
ticket.

When a ticket is changed to PENDING_RELEASE it is apparent the
availability of the ticket's resolution can wait for the upstream
release of the next version of the software.

When a ticket is changed to IN_PACKAGING it is implicitly requesting;

*   the ticket's resolution is included in to the packaging as a patch
    on top of the current -- otherwise stable -- release(d package).

*   a new release is created to subsequently result in a new package --
    this includes snapshot releases.

Tickets that move from PENDING_RELEASE (on to the next status
IN_PACKAGING) imply that a variety of other aspects of our Bugzilla have
also been updated, including versions, milestones and
**Fixed in Version** fields.

.. _bugzilla-status-in_packaging:

IN_PACKAGING
------------

Somebody is to package the ticket's resolution.

After the status IN_PACKAGING is completed, the ticket is to move in to
IN_TESTING, provided the details about which product stream the new
package has been made available in (i.e. target platform, product
version, edition, repository stage, package NEVRA).

Before a ticket can be moved to IN_TESTING, a draft errata should be
made available, especially where additional instructions are to be
included (to facilitate upgrades, and/or new configuration items).

.. _bugzilla-status-in_testing:

IN_TESTING
----------

Tickets in testing are pending verification by Quality Assurance.

.. _bugzilla-status-verified:

VERIFIED
--------

Quality Assurance has successfully verified the upgrade path to the new
software as well as the issue's resolution.

This opens up the path for release engineering and/or product management
to release the update as stable.

.. _bugzilla-status-closed:

CLOSED
------

The ticket has been resolved, and all subsequent tasks have been
completed.

.. _bugzilla-status-reopened:

REOPENED
--------

.. _bugzilla-status-needsinfo:

NEEDSINFO
---------

:ref:`bugzilla-status-needsinfo` is a status that indicates the ticket
needs additional information before it can move on to the next stage.

.. TODO::

    Install the :ref:`bugzilla-status-needsinfo` extension, so that not
    only can the status be set, one can explicitly supply from whom the
    additional information is needed, said person is notified, and said
    person can "clear" the :ref:`bugzilla-status-needsinfo` state when
    the requested information is supplied.

Status Workflow
---------------

You need administrative privileges to view the actual configuration of
the status workflow in Bugzilla, but we can provide you with a
screenshot (Sunday, August 3rd, 2014):

.. figure:: bugzilla_workflow.png
    :width: 100%

.. NOTE::

    All statuses that are in red are considered closed tickets. All
    statuses in green are considered open tickets.

Here is a more dynamic diagram:

.. graphviz::

    digraph {
            "UNCONFIRMED" [color=green];
            "NEW" [color=green];
            "ASSIGNED" [color=green];
            "IN_PROGRESS" [color=green];
            "NEEDSINFO" [color=green];
            "RESOLVED" [color=red];
            "PENDING_RELEASE" [color=red];
            "IN_PACKAGING" [color=red];
            "IN_TESTING" [color=red];
            "VERIFIED" [color=red];
            "CLOSED" [color=red];
            "REOPENED" [color=green];

            "UNCONFIRMED" -> "NEW" [label="(1)"];
            "UNCONFIRMED" -> "NEEDSINFO" [label="(18)",dir=both];
            "UNCONFIRMED" -> "CLOSED" [label="(19)"];

            "NEW" -> "ASSIGNED" [label="(2)"];
            "NEW" -> "NEEDSINFO" [label="(18)",dir=both];
            "NEW" -> "CLOSED" [label="(19)"];

            "ASSIGNED" -> "NEW" [label="(3)"];
            "ASSIGNED" -> "IN_PROGRESS" [label="(4)"];
            "ASSIGNED" -> "NEEDSINFO" [label="(18)",dir=both];
            "ASSIGNED" -> "CLOSED" [label="(19)"];

            "IN_PROGRESS" -> "NEEDSINFO" [label="(18)",dir=both];
            "IN_PROGRESS" -> "RESOLVED" [label="(5)"];
            "IN_PROGRESS" -> "CLOSED" [label="(19)"];

            "RESOLVED" -> "PENDING_RELEASE" [label="(6)"];
            "RESOLVED" -> "IN_PACKAGING" [label="(7)"];
            "RESOLVED" -> "CLOSED" [label="(19)"];

            "IN_PACKAGING" -> "PENDING_RELEASE" [label="(8)"];
            "IN_PACKAGING" -> "IN_TESTING" [label="(10)"];
            "IN_PACKAGING" -> "CLOSED" [label="(20)"];

            "PENDING_RELEASE" -> "IN_PACKAGING" [label="(9)"];
            "PENDING_RELEASE" -> "IN_TESTING" [label="(11)"];
            "PENDING_RELEASE" -> "CLOSED" [label="(21)"];

            "IN_TESTING" -> "REOPENED" [label="(12)"];
            "IN_TESTING" -> "VERIFIED" [label="(13)"];
            "IN_TESTING" -> "CLOSED" [label="(22)"];

            "VERIFIED" -> "CLOSED" [label="(14)"];
            "VERIFIED" -> "CLOSED" [label="(19)"];

            "CLOSED" -> "REOPENED" [label="(15)"];

            "REOPENED" -> "ASSIGNED" [label="(16)"];
            "REOPENED" -> "RESOLVED" [label="(17)"];
        }

Workflow Steps
^^^^^^^^^^^^^^

When a ticket is entered, it starts in an
:ref:`bugzilla-status-unconfirmed` state. From here:

1.  A ticket is set to :ref:`bugzilla-status-new` from
    :ref:`bugzilla-status-unconfirmed`, if the ticket is valid, accepted
    and contains sufficient information.

2.  A :ref:`bugzilla-status-new` ticket is generally
    :ref:`bugzilla-status-assigned` to an individual developer by
    project, release and/or product management, but could be assigned to
    anyone by anyone.

3.  If an :ref:`bugzilla-status-assigned` ticket is set back to status
    :ref:`bugzilla-status-new`, the assignee in question has "bounced"
    the ticket, with hopefully a comment that clarifies why.

4.  An :ref:`bugzilla-status-assigned` ticket that is set to
    :ref:`bugzilla-status-in_progress` is a ticket being worked on by
    the assignee.

    .. NOTE::

        Before the assignee sets the ticket to
        :ref:`bugzilla-status-in_progress`, the assignee should consider
        :ref:`bugzilla-cloning-tickets`, if it is already clear that the
        work on different versions of the software is likely not to be
        the same work.

5.  The assignee of a ticket sets the status of a ticket to
    :ref:`bugzilla-status-resolved` when the work is complete.

    .. NOTE::

        The assignee should consider :ref:`bugzilla-cloning-tickets` if;

        *   the ticket's resolution applies to multiple versions of the
            software, and/or

        *   the resolution applies to one or more versions of the
            software, but not to other versions where the resolution is
            also required or requested (according to the original
            ticket's target milestone).

From the :ref:`bugzilla-status-resolved` state of a ticket, two possible
paths are available:

6.  Setting the :ref:`bugzilla-status-resolved` ticket to state
    :ref:`bugzilla-status-pending_release` means to indicate that
    shipping the fix is waiting for an actual upstream release of a new
    version of the software.

    This tends to occur for low-priority tickets and tickets for
    low-priority product streams such as Kolab Development.

    Continue with step 10.

7.  Setting the ticket (from state :ref:`bugzilla-status-resolved`) to
    state :ref:`bugzilla-status-in_packaging` means to indicate that the
    fix is being shipped as a patch to the currently packaged version of
    the software.

    This tends to occur for high-priority tickets, likely with fixes
    relatively easily patched in the current packaging, relatively
    easily tested and otherwise (such as with an actual release of the
    software) significantly harder to release as a stable update, in
    that;

    *   It is harder to quickly release an update for a piece of
        software that may have a couple of dozen of changes, compared to
        fixing (and testing) one single fix.

        Shipping a patch for a particular issue short-circuits the high-
        priority ticket and buys time to test the full update.

    .. NOTE::

        From the :ref:`bugzilla-status-in_packaging` state, the ticket
        **MUST** be cloned;

        *   the original will move forward to
            :ref:`bugzilla-status-in_testing` (step 9).

        *   the clone can be set to
            :ref:`bugzilla-status-pending_release` (step 8).

8.  A ticket that has been in state :ref:`bugzilla-status-in_packaging`
    could be set back to :ref:`bugzilla-status-pending_release`, but
    this should only be performed when the patch in step 7 can not be
    individually applied.

    A red flag should be raised with project/product management to raise
    awareness of the impending delay in the availability of the
    resolution to the (high-priority) ticket.

9.  When a ticket is set to state :ref:`bugzilla-status-in_packaging`
    from a previous state of :ref:`bugzilla-status-pending_release`, the
    upstream release has actually occurred, and release management has
    created the necessary *version*, and set relevant tickets to the
    appropriate *milestone* that corresponds with that release.

    Logically, the next step is step 10.

    .. seealso::

        *   :ref:`bugzilla-release-management`

10. When a ticket is set to state :ref:`bugzilla-status-in_testing`, a
    packaged version of the resolution is available through the product
    stream supply channels that Quality Assurance consumes.

    .. NOTE::

        A stable version of software may be targeted for inclusion with
        multiple product streams, such as perhaps the package
        **cyrus-imapd**.

        We employ tables such as :ref:`package-cyrus-imapd` to maintain
        an overview of version series available to product streams.

    This part of the process typically continues with step 12 or 13.

11. PENDING_RELEASE -> IN_TESTING

    To be honest, we're not sure why this change is allowed.

12. From the state :ref:`bugzilla-status-in_testing`, should Quality
    Assurance have failed, the status of the ticket should be set to
    :ref:`bugzilla-status-reopened`.

    It is worthwhile noting that simply changing the status may not
    necessarily spawn the appropriate amount of attention to the testing
    of the software having failed. In case the test having failed forms
    a blocker for the update being released as stable, the sooner
    someone's attention can be drawn to the issue at hand, the better it
    is.

13. Quality Assurance has succeeded, and the update is therefore
    eligible for release.

    After the update is made available, the process continues with step
    14.

14. VERIFIED -> CLOSED

15. CLOSED -> :ref:`bugzilla-status-reopened`

16. :ref:`bugzilla-status-reopened` -> :ref:`bugzilla-status-assigned`

17. :ref:`bugzilla-status-reopened` -> RESOLVED

18. :ref:`bugzilla-status-assigned`, :ref:`bugzilla-status-in_progress`, :ref:`bugzilla-status-new`, :ref:`bugzilla-status-unconfirmed` <-> :ref:`bugzilla-status-needsinfo`

19. :ref:`bugzilla-status-assigned`, :ref:`bugzilla-status-in_progress`, :ref:`bugzilla-status-new`, :ref:`bugzilla-status-unconfirmed`, RESOLVED, VERIFIED -> CLOSED

20. IN_PACKAGING -> CLOSED

21. PENDING_RELEASE -> CLOSED

22. IN_TESTING -> CLOSED

.. _bugzilla-requirements-for-backporting:

Requirements for Backporting
============================

.. _bugzilla-triaging-bugzilla-tickets:

Triaging Bugzilla Tickets
=========================

Triaging tickets is the exercise of ensuring tickets are complete and
accurate, such that;

*   the ticket type field accurately reflects the type of issue raised
    in the ticket.

    While the type of ticket is unknown, uncertain or simply not yet
    determined, the ticket types should remain ``---``.

*   when a **bug** is reported, a sufficiently accurate description of
    the symptoms is supplied.

    This tends to include things like, *"Steps to reproduce"* and where
    applicable, any configuration settings and deployment architecture.

*   the version field is set to the earliest version known to exhibit
    the symptoms, or to have the enhancement be applicable to.

    .. NOTE::

        The version field is usually set to the actual version
        installed, and needs to be at most the actual version of the
        software installed.

*   the version of software used is actually still supported.

    A software's currently supported versions have those versions (and
    only those versions) listed in the version field, and corresponding
    milestones available to them.

    If a version turns out to be outdated, the ticket can be CLOSED with
    a resolution of WONTFIX, with the version field set to
    ``unspecified`` and the milestone set to ``---``.

*   where appropriate, an attempt is made to resolve the issue without
    requiring the involvement of developers.

    This usually includes searching other tickets for the same symptoms,
    ensuring the latest available version of the software -- available
    to the product stream consumed -- is used.

Choosing a Version and Milestone
================================

Milestones represent the target branch or tag (in source code
management) to which the ticket's resolution is expected to be applied.

For consistency across the various software components that make up
Kolab, which commonly apply an $x.$y.$z versioning scheme, we have the
following "special" milestone notations:

*   ``$x.$y-next``

    The '-next' suffix to the major and minor version of the software
    is meant to indicate that the target of the ticket's resolution is
    the current stable branch versioned $x.$y, and HEAD thereof -- with
    one exception, see below.

    An example milestone is ``1.0-next`` for **libkolabxml**, which is
    HEAD of the libkolabxml-1.0 branch.

*   ``$x.($y+1)-next``

    It is wrong to refer to a milestone as 'master', which is what this
    special milestone represents, because 'master' is not a qualified
    point in the source code management history and release history --
    or future, for that matter.

    An example milestone is ``1.1-next`` for **libkolabxml**, which is
    HEAD of the master branch.

    Packaged versions of this type tend to occur in publically
    available, short-term supported releases only, and will typically
    have a ``$x.$y`` version, since a package with version ``$x.$y.0``
    is considered an update to version ``$x.$y`` by package managers.

*   ``$x.$y.($z+1)`` or ``$x.($y+1).0``

    The milestone that is one step beyond what is currently released is
    used in :ref:`bugzilla-release-management`.

As such, milestones relate directly to the source code management
repository branches, and ultimately also tags (releases).

This brings us to versions -- they too have ``$x.$y-next`` as valid
versions, again representing HEAD of a particular branch, but compiled
directly from said HEAD -- and not a released version.

These special versions should continue to be available for all branches
currently under some form of support (see also
:ref:`bugzilla-supported-versions-of-software`).

Assigning a Bugzilla Ticket
===========================

.. _bugzilla-assignee:

Assignee
--------

The assignee of a ticket is the person or the group of persons
responsible for the ticket.

A single person being the assignee of a ticket does not mean that ticket
also has to be resolved by that person (unless the ticket has status
:ref:`bugzilla-status-in_progress`). It is, however, the assignee's
responsibility to "bounce" a ticket.

A group of persons being the assignee(s), such as devel@lists.kolab.org,
puts the responsibility on to no one person in particular. Tickets with
these assignees tend to linger for a long time, as nobody in particular
feels responsible for it.

.. _bugzilla-cc-list:

CC List
-------

The CC list of a ticket is a list of people generally interested in its
progress.

.. _bugzilla-qa-contact:

QA Contact
----------

The QA contact of a ticket is the person or group of persons to contact
when the assignee wants to verify and/or coordinate how the validation
of the ticket's resolution is to be performed.

.. _bugzilla-see-also:

See Also
========

The **See Also** field can be used to refer to external Bugzilla
entries, such as those on the `KDE Bugzilla` or `Cyrus IMAP Bugzilla`.

.. _bugzilla-priority-and-severity:

Priority & Severity
===================

The priority field in a Bugzilla ticket establishes (between tickets)
the order in which tickets should be worked on (highest priority first).

As a rule of thumb, tickets that qualify for a higher priority are:

*   Blocking a number of other tickets,

*   Have gone unanswered and/or unresolved for too long,

*   Potentially have great impact, such as security issues and/or actual
    loss of data,

*   Generally need to be resolved sooner rather than later.

.. _bugzilla-effort-involved:

Effort Involved
===============

Estimating and tracking the effort involved with a certain ticket is a
feature used by and available to Kolab Systems employees exclusively.

.. _bugzilla-supported-versions-of-software:

Supported Versions of Software
==============================

Supported products have a corresponding classification and product in
Bugzilla. Supported versions of product have one or more corresponding
milestones.

In addition to supported versions of products having milestones, there
is also the *version* field.

Here's how they work together.

*   Past releases of software called ``foo`` include versions ``0.1.0``,
    ``0.1.1``, ``1.0.0``, ``1.0.1``, ``2.0.0``, ``2.1.0``.

*   The ``0.1`` branch [#]_ had been used for the alpha development
    stage, and had been included in a product stream made available to
    the community 2 years ago.

    Since the community does not support Kolab product streams that
    long, versions ``0.1.0`` and ``0.1.1`` are therefore no longer
    supported. The general answer to any ticket against these versions
    is *"Please upgrade to a supported version"*, and these tickets are
    CLOSED - WONTFIX.

    The versions should remain available in *version* field, however, so
    that people can indicate they do in fact run that old a version of
    the software.

    However, **no milestones** for the ``0.1`` branch are available any
    longer, indicating the version stream is no longer supported. This
    would include, for example, the following milestones:

    *   ``0.1.0`` -- already released and therefore not a valid target
        milestone.

    *   ``0.1.1`` -- already released and therefore not a valid target
        milestone.

    *   ``0.1-next`` -- further development as well as support on the
        ``0.1`` series has been suspended.

*   An issue reported against ``1.0.0`` may have already been resolved
    in ``1.0.1``.

    In such cases, there should be a ticket for the issue, to which a
    new ticket can be closed as a duplicate. In this scenario, the
    milestone has become irrelevant.

*   An issue reported against ``1.0.0`` may not yet have been resolved
    at all, and would therefore need to be resolved in a later ``1.0``-
    series release. The milestone to use is therefore ``1.0-next``, even
    though there may already a version available that is more recent
    than ``1.0.0``, namely ``1.0.1``.

    .. NOTE::

        Note that the resolution for this ticket may need to be applied
        to the following branches (in order):

        *   master
        *   foo-2.1
        *   foo-2.0
        *   foo-1.0

        See also :ref:`bugzilla-cloning-tickets`.

        Further note that an issue in one version of the software may
        simply not exist in other versions of the software (and may
        again pop up in yet later versions).

        It's recommended to clone such tickets as quickly as possible,
        so they may function as a reminder to check whether or not the
        issue exists in a version of the software you're not currently
        prioritizing.

.. _bugzilla-release-management:

Release Management
==================

Release Management includes the following steps:

#.  When a release is planned, a milestone ``$x.$y.($z+1)`` or
    ``$x.($y+1).0`` is created (exceptions apply to pre-releases, which
    have a format of ``$x.$y-{alpha,beta,rc}[0-9]+``).

    For example, when a release is planned for the stable *1.0* series
    of **libkolabxml**, a milestone **1.0.2** is created, as *1.0.1* had
    once been released.

#.  All tickets with milestones ``$x.$y-next`` (for a teeny release) or
    all tickets with milestones ``$x.($y+1)-next`` (for a minor
    release) are now evaluated.

    What actually happens with the tickets depends on their status:

    *   All tickets with status PENDING_RELEASE are set against the new
        milestone.

    *   After verifying the related modifications are available in the
        correct branch, all tickets with status RESOLVED are set against
        the new milestone, and set to PENDING_RELEASE.

        .. NOTE::

            For a 1.0 version issue resolved in a 1.1 release, should
            the targeted release include a backported version of the 1.1
            resolution, then the ticket should be cloned.

    *   All tickets with status IN_PACKAGING are set against the new
        milestone, and set to PENDING_RELEASE.

    *   All tickets with status :ref:`bugzilla-status-assigned` and
        :ref:`bugzilla-status-in_progress` are set against the new
        milestone.

        Doing so ensures tickets are assessed before a release button is
        triggered, and do not linger against a ``-next`` milestone
        indefinitely.

        It is at this moment that assignees are encouraged to review the
        tickets against the new milestone, and determine which ones they
        might be able to include resolutions for, without necessarily
        delaying the release significantly.

        The tickets that cannot be resolved within a reasonable
        timeframe are to be re-scheduled against a new appriopriate
        milestone.

#.  Bugzilla versions and milestones are up-to-date, including their
    active state.

#.  New milestones are created when a release is planned,

#.  New milestones are created when software is branched off,

#.  The versioning policy is consistent,

#.  The new milestone includes an assessment on each ticket of type
    *bug* possibly relevant to the upcoming release.

.. _bugzilla-example-cyrus-imapd-sieve-date-extension-support:

Example Ticket: Sieve Date Extension Support for Cyrus IMAP
===========================================================

The Sieve Date extension is targeted to be used as a means to clause
vacation actions to be applied during a window of time in the future.

For example, a user could configure to be on holiday next week (today is
Sunday, August 3rd, 2014):

.. parsed-literal:

    if allof(
            currentdate :is "year" "2014",
            currentdate :is "month" "08",
            currentdate :value "ge" "day" "04",
            currentdate :value "lt" "day" "08"
        ) {
            vacation [parameters];
    }

This is a coordinated effort between the following products:

#.  Cyrus IMAP
#.  Roundcube
#.  Kontact
#.  PyKolab
#.  Sievelib

An original ticket is created: `#3242`_. This is the generic feature
enhancement request for the Kolab Groupware server as a whole.

It is therefore not assigned to any one particular developer, but to
someone who can track the progress of the full implementation of the
functionality for all components involved.

.. NOTE::

    At the time of creation, `#3242`_ blocks a release tracker ticket
    to indicate the ticket's resolution is, at that point, intended to
    be included in the target release of the tracker ticket.

    In this example case, the tracker ticket being blocked is `KE14`_
    for Kolab Enterprise 14 -- this ticket is regrettably private and
    visible to Kolab Systems employees only.

    In other cases, the tracker ticket may be `K3.3`_, to indicate the
    feature or fix is to be included in Kolab 3.3.

This assignee is responsible for creating the additional tickets to
each individual component involved, including:

#.  `#3243`_ for Cyrus IMAP

    For the actual implementation of the Sieve Date Extension, Cyrus
    IMAP requires the enhancement first.

#.  `#3437`_ for Roundcube

    For the functionality in Cyrus IMAP to be meaningful, Roundcube will
    need to expose the necessary UI components for users.

#.  `#xxxx`_ for Kontact

    For the functionality in Cyrus IMAP to be meaningful, Roundcube will
    need to expose the necessary UI components for users.

#.  `#3529`_ for PyKolab

    The availability of the functionality depends on **pykolab** setting
    up Cyrus IMAP correctly (i.e. the setting ``sieve_extensions`` in
    :manpage:`imapd.conf(5)` needs the new extension name), and using
    sievelib, the Kolab daemon may use settings from LDAP.

#.  `#xxxx`_ for Sievelib

    The Python Sieve management library does not have a module to handle
    the new date extension, and may need amending.

.. rubric:: Footnotes

.. [#]

    The "0.1 branch" may have in fact not ever been a branch as such, as
    initial development may simply have moved the master branch forward
    fast.

.. _#3242: https://issues.kolab.org/show_bug.cgi?id=3242
.. _#3243: https://issues.kolab.org/show_bug.cgi?id=3243
.. _#3437: https://issues.kolab.org/show_bug.cgi?id=3437
.. _#3529: https://issues.kolab.org/show_bug.cgi?id=3529
.. _K3.3: https://issues.kolab.org/show_bug.cgi?id=K3.3
.. _KE14: https://issues.kolab.org/show_bug.cgi?id=KE14
.. _bugzilla: https://issues.kolab.org
.. _KDE Bugzilla: https://bugs.kde.org
.. _Cyrus IMAP Bugzilla: http://bugzilla.cyrusimap.org
