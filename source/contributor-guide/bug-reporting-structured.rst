.. _contributor-guide-structured-contributions-reporting-bugs:

===========================================================
Reporting Bugs Against (Long-Term) Supported Kolab Versions
===========================================================

Long-term support versions of Kolab maintain larger sets of different versions
of software, and it becomes important to ensure that the fix for an issue in
`foo-1.0` does not require a properly entitled customer to upgrade to a later
version of Kolab, or even a later version of `foo`.

The stability requirements imply that support be able to track issues with
specific versions of the software, targets these issues to be resolved in
certain newer versions of the software, and trusts the resolution of the issue
to be verifiable against multiple versions of the software collection.

Example
=======

The following table depicts the versions of the |roundcubemail| package, and
the |roundcubemail-plugins-kolab| package, as distributed for each product
stream.

.. table:: Version table for Roundcubemail and Kolab Plugins

    +--------------+-----------------+-------------------------------+
    |              | |roundcubemail| | |roundcubemail-plugins-kolab| |
    +==============+=================+===============================+
    | |KE13|       |         `1.0.4` |                      `3.1.16` |
    +--------------+-----------------+-------------------------------+
    | |KE14|       |         `1.1.4` |                      `3.2.11` |
    +--------------+-----------------+-------------------------------+
    | |K16|        |           `1.2` |                         `3.3` |
    +--------------+-----------------+-------------------------------+
    | |Winterfell| |           `1.2` |                         `3.3` |
    +--------------+-----------------+-------------------------------+

Stability requirements for |KE13| demand the following:

*   The version of |roundcubemail| shipped to the product stream is one of
    the **1.0 series** of upstream releases,

*   Upstream maintains a **stable** 1.0 series for roundcubemail,

*   The version of |roundcubemail-plugins-kolab| shipped to the product
    stream is one of the **3.1 series** of upstream releases,

*   Upstream maintains a **stable** 3.1 series for roundcubemail-plugins-kolab,

*   Future versions of |roundcubemail| in the 1.0 series remain backward
    compatibility for consumers of its API (such as
    |roundcubemail-plugins-kolab|),

*   Added functionality in |roundcubemail-plugins-kolab|, if any, does not
    require any changes in |roundcubemail| that would break other compatibility,

*   The aforementioned conditions all last for up to 5 years,

*   For a large number of target platforms.

The same conditions apply to |KE14| and |K16| -- with different version series,
different timelines and sometimes different stacks.

Further down the dependency stack, this includes maintenance for
**libkolabxml**, **libkolab** and **libcalendaring**.

In the future, this will extend up to 6 product streams that will need to be
maintained.

It is therefore important that an issue logged against a version 1.0.1, with
the current version in the 1.0 series perhaps being 1.0.10, needs to go through
the following stages:

#.  Is the issue reproducible in the unstable development version of the
    software suite?

    a.  If it is, it is a development issue; `report a bug`_ in Phabricator.

        Developer teams become responsible for testing the resolution of the
        issue first, and fixing the issue second (see
        :ref:`contributor-guide-test-driven-development`).

        For each of the product streams in between current development and
        the original issue report, create a ticket in `bugzilla`_.

        .. seealso::

            *   Something about backporting with the verification included.

    b.  If it is not, in what product stream can the issue still be reproduced?

        This process can be a very costly lather-rinse-repeat exercise, and
        therefore needs to be covered ahead of time, through
        :ref:`contributor-guide-test-driven-development`.

        Create a `bugzilla`_ ticket for the appropriate

        .. seealso::

            *   Something about constructive troubleshooting efforts

#.  Using the input of 1) and outcome of 1a) or 1b), describe the range of
    targets;

        *   branch 1.2 for |K16|: yes or no?
        *   branch 1.1 for |KE14|: yes or no?
        *   etc.

    Each becomes a separate `bugzilla`_ ticket, each of them depending on the
    resolution of the more recent product stream('s software version).

Example
=======

Let's assume "yay" fails on all versions of Roundcube.

#.  Issue:

    *Yay fails on Roundcube 1.0.1 on* :gray:`Enterprise Linux 6`

    This is an original ticket. The intended milestone for the resolution is
    `1.0-next`.

#.  Support:

    #.  *Does yay fail in* |Winterfell| *on* |maipo| *?*

        Yes, this is a new development issue; `Report a bug`_. Add a project
        tag for :orange:`Winterfell`

    #.  *Does yay fail in* |K16| *on* |maipo| *?*

        Yes, and |K16| is on the same software version series as |Winterfell|;

        It is thus a new development issue; `Report a bug`_ and have it
        blocked by the bug created in 2.1).

        Associate the |K16| release target with the bug.

        Also create a `bugzilla`_ ticket. The milestone here is `1.2-next`.
        Refer to the task created in Phabricator.

    #.  *Does yay fail in* |KE14| *on* |santiago| *?*

        Yes, create a `bugzilla`_ ticket and block it with the ticket created
        in 2.2). The milestone here is `1.1-next`.

    #.  *Does yay fail in* |KE13| *on* |santiago| *using version 1.0.4?*

        Yes, block the original ticket in 1) with the ticket from 2.3).
