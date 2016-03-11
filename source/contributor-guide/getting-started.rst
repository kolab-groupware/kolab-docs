.. _contributor-guide-getting-started:

================================
Getting Started with Phabricator
================================

#.  Navigate to https://git.kolab.org. We recommend you use a browser.

#.  Determine whether you are a Kolab Systems employee, and act accordingly;

    #.  If you are a Kolab Systems employee, use your corporate credentials to
        login using LDAP.

    #.  If you are not a Kolab Systems employee, create yourself an account if
        you have not already done so. You can use any of the forms except for
        the one that requests LDAP credentials.

#.  `Set your date-time notation format <https://git.kolab.org/settings/panel/datetime>`_.

#.  Set your profile picture.

#.  `Upload an SSH public key <https://git.kolab.org/settings/panel/ssh/>`_.

#.  `Set your text-area font to fixed width <https://git.kolab.org/settings/panel/display/>`_.

#.  `Configure email notifications <https://git.kolab.org/settings/panel/emailpreferences/>`_,
    especially the ones for actions you place yourself.

#.  :ref:`contributor-guide-setup-tools`.

#.  Hook up **arcanist** to your Phabricator account:

    .. parsed-literal::

        $ :command:`arc install-certificate`

Projects
========

Software development projects use a communication icon (envelope) in
:blue:`blue`.

Each software development project is provided a workboard, such they could, at
their option, visualize a roadmap.

.. NOTE::

    The use of sub-projects and milestones in Phabricator is under review.

Teams
=====

Teams include groups of people that work on software development projects, or
form the :red:`Architecture & Design` team, :red:`Release Managers`, etc.

Membership of these teams usually provides you with commit access to a GIT
repository, and is used to authorize differentials in
:ref:`contributor-guide-peer-review`.

*   Software developer teams are used to authorize commit access, and use a
    group icon in :red:`red`.

*   You need to request membership from one of the existing members.

*   You only need membership in order to push to the GIT repositories directly.

Sprints
=======

Sprints are time-boxed team efforts with the duration of exactly one week --
running from Monday morning to Friday afternoon.

In Phabricator, sprints are projects named using the year and week number, such
as :green:`Sprint 201610`.

On Monday mornings, at 10:00 in the morning (Europe/Zurich timezone), a sprint
planning meeting is held, with all participants in the sprint attending. The
goal is to reiterate the priority of tasks for the sprint, raise doubts where
there are any, but also assign tasks and give them story points.

We use a sprint-specific backlog for the sprint planning, since the global
product backlog is just much too large to discuss.

That said, all users of Phabricator are encouraged to propose tasks to include
in the next sprint, as well as go ahead and seed the information for the tickets
they know are going to be assigned to them, and provide feedback on others.

At or near the end of the sprint, a meeting is held that shows off functional
software, also called a retrospective. To allow us to show functional software
a merge window is used between Thursday afternoon (at about 15:00 to 17:00 in
the Europe/Zurich timezone) all the way through Friday up to the retrospective.

At this point, all tickets in Review can be moved to Done, which happens on the
premises the differential associated with the ticket is accepted, merged,
pushed, tested (continuous integration) and delivered (packaging).

Release Targets
===============

Release targets are irrelevant for developers. The only release target that is
relevant for developers is |Winterfell|.

Distributions
=============

Distributions (target platforms) are irrelevant for developers. The only target
platform relevant to developers is the reference platform |maipo| (Enterprise
Linux 7).
