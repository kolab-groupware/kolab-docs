.. _contributor-guide-peer-review:

===========
Peer Review
===========

Peer review is a process in which code changes are submitted to a staging
environment, so that fellow developers have the opportunity to review the work
before the code changes are submitted back to the source code management
repository.

Peer view is assisted by `Differential`_. To use `Differential`_ effectively,
you must install **arcanist** and set it up.

.. seealso::

    *   :ref:`contributor-guide-setup-your-development-environment`

For structured contributions, and for sprint participants, the use of
`Differential`_ is obligatory, and further facilitates the process of
:ref:`contributor-guide-test-driven-development`.

Post-poning destabilizing changes stabilizes the day-to-day use of
|Winterfell|, and allows multiple changesets to land at once (enabling a single
feature to span multiple software projects).

The Process
===========

A task in a sprint should consist of a bite-size chunk of development work.

When you start work on the task, you write the tests first (and those tests
would fail, because they have not been backed by code changes).

You submit your differential at the earliest opportunity, however incomplete
your coverage may be at that point. This ensures peers can participate in
feedback cycles early, and shows progress being made as it is made.

Creating a Differential for Review
==================================

Your development takes place against the **master** branch, unless you find
yourself running in circles, interrupted by a support request.

Thus, make sure you have **master** checked out, and for the sake of preventing
superfluous merge and rebase exercises, ensure it's in sync with upstream:

.. parsed-literal::

    $ :command:`git checkout master`
    $ :command:`git fetch origin`
    $ :command:`git rebase origin/master --autostash`

Provided a ticket, such as :task:`1037`, you should branch off the GIT
repository;

.. parsed-literal::

    [kanarip\@dws06 docs.git (master u=)]$ :command:`git checkout -b dev/T1037`
    [kanarip\@dws06 docs.git (dev/T1037)]$

This will allow you to keep your changes out of a tracking working copy, and
allows you to switch back over to other work without stacking the changes on
top of one another.

Make your changes, and commit them in however many commits you think is
reasonable.

Then, create the `Differential`_:

.. parsed-literal::

    [kanarip\@dws06 docs.git (dev/T1037 %)]$ arc diff
    You have untracked files in this working copy.

      Working copy: /home/kanarip/devel/src/kolab/docs.git/

      Untracked changes in working copy:
      (To ignore these changes, add them to ".git/info/exclude".)
        quick-notes.txt

        Ignore these untracked files and continue? [y/N] :command:`y`

You will now be requested to provide some information about your proposed
changes.

The first line of the differential submission is the title for the
differential.

The template offers a ``Summary:`` line, and you are to make that line include
the phrase ``Resolves T1037``. This causes the differential to be associated
with the ticket, and will cause the ticket to change status to resolved when
the differential is accepted, merged and pushed back.

Use the remainder of the space under ``Summary: Resolves T1037`` to spout any
thoughts or comments.

In ``Test Plan:``, you list the steps needed to verify the work. This could be:

.. parsed-literal::

    Test Plan: Run the unittests with;

      $ NOSE_VERBOSE=2 nosetests tests/unit/

In ``Reviewers:``, you list the development team associated with the project
(such as :red:`PyKolab Developers` or :red:`Documentation Authors`). You are to
use hashtags here, so they would be ``#pykolab_developers`` or
``#documentation_authors``. **arcanist** will validate the entries and prompt
you if they do not exist.

In ``Subscribers:``, you may either not list anyone, or list the username(s) of
people you wish to be notified when the differential changes. Here too,
**arcanist** validates the input.

.. parsed-literal::

    Linting...
    No lint engine configured for this project.
    Running unit tests...
    No unit test engine is configured for this project.
    Updating commit message...
    Created a new Differential revision:
            Revision URI: https://git.kolab.org/D89

    Included changes:
      M       source/index.rst
      A       source/contributor-guide/index.rst

Review Process
==============

A reviewer must ensure code changes are verifiable, and validate unit,
functional and integration tests for the code changes before accepting the
differential.

A reviewer will want these tests to be automated, or ends up spending a lot of
time and effort on verifying the changes made.

.. IMPORTANT::

    Exceptions to this rule should only be made in extreme cases, and require
    even more pairs of eyeballs.

A reviewer must also verify there is a ticket associated with the differential,
and that the ticket associated with the differential will be closed
automatically, should the differential be accepted and merged.

Accepting the differential does not mean the code changes are automatically
merged, however. Acceptance of a differential outside of the merge window is
therefore allowed.

Your changes need to be reviewed by at least one other person, who is a
software development project member.

In :ref:`contributor-guide-test-driven-development`, the submission of the
differential associated with your review process aides in the staging of the
code changes.

The changes submitted should be reviewed on Thursday afternoons at the latest,
at which point of the :red:`Release Managers` team can pick them up and merge
the proposed changes with all the applicable branches.

The combined code changes and test should make the lives of
:red:`Release Managers` a lot easier -- the functionality of the backported
changes should be available for automated verification.

Landing a Differential Revision
-------------------------------

.. NOTE::

    This documentation applies to :red:`Release Managers` only.

#.  Take the review column of the `current sprint`_.

#.  Examine the tickets and their associated differentials.

#.  Move the tickets and differentials that have code changes depending on code
    changes to other projects that have not yet made it on to the next sprint,
    however, attempt to not negatively impact the team's velocity in doing so;

    You could close the current ticket in review and move it to the Done
    column, and create a ticket for the next sprint associated with your own
    team, at about 1-2 story points.

#.  Merge the code changes in order of the differential numbers, in a best
    effort to merge stacked changes as easily as possible. Those that fail to
    be applied need to be merged manually, or otherwise reassigned to the
    developer in question for the next sprint (the task is rebase). Again, do
    not impact the team's velocity too much, and consider splitting the
    original development effort with the rebase/merge attempt.

#.  Congratulate each developer on a job well done.

#.  Ensure merged code is available in |Winterfell|.

#.  Congratulate yourself on a job well done.
