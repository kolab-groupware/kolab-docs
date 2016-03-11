.. _contributor-guide:

=================
Contributor Guide
=================

Kolab Groupware development largely follows an iterative and incremental
agile software development metholodogy also known as `Scrum`_.

In summary, the development process is divided into stages, with different
teams participating in getting tasks to the next stage of the process.

Kolab Groupware is a collaboration suite consisting of many components,
each of them separate software development projects, some of them
dependent on third-party software development projects, and some of them
separate altogether.

.. IMPORTANT::

    Still to do:

        *   Contributing to translations (l10n and i18n)

        *   Switch current documentation stuff over

        *   Fixing packaging issues

        *   Feature requests' inception/elaboration/construction/transition
            phases

        *   Testing Kolab

        *   Participation section on Peer Review -- the actual execution of
            things.

            Note that this includes the applying of a differential to review
            the work in its full context.

        *   Running docker containers

        *   (Ab)using Continuous Integration (fully testing locally)

        *   SCRUM details

        *   Packaging and Continuous Delivery

.. _contributor-guide-casual-contributions:

Casual Contributions
====================

The following guides are intended for casual contributors and contributions,
such as a one-time 5-line patch for that one itch to scratch.

.. toctree::
    :maxdepth: 1

    translations
    bug-reporting-casual
    documentation/index
    packaging/casual
    feature-requests/index
    testing

.. _contributor-guide-structured-contributions:

Structured Contributions
========================

The following guides set you up for regular, structured contributions to Kolab,
such as continued development and participation in sprints.

.. toctree::
    :maxdepth: 1

    getting-started
    setup-development-environment
    peer-review
    docker-containers
    continuous-integration
    scrum
    packaging
    bug-reporting-structured
