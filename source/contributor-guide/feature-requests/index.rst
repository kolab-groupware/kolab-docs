.. _contributor-guide-feature-requests:

================
Feature Requests
================

The Definition of a Feature Request
===================================

A feature request is a description of a problem space for which we may seek the
resolution to be provided within, or with the help of, Kolab.

Such a problem space is articulated in and by itself, and allows for
understanding to be formed and interpretation to be fine-tuned over the course
of a process with multiple parties contributing.

.. IMPORTANT::

    Using **problem spaces** re-inforces the importance of the human
    experience for the final product enhancement.

A bad example of a feature request would be:

    *Make the button background red.*

This example neither addresses the actual problem, nor the potential value of a
resolution.

A better example would be:

    *The contrast between the button background and page is too low.*

Any target use-case or workflow described must be considered only as a context
establishing a higher level of comprehension in elaboration, about the
dimensions of the problem space. Per the existing example:

    *Color vision deficiencies do not allow some people to distinguish the
    button from the background.*

This would allow us to clarify whether a high-contrast UI is needed, or a
slight adjustment suffices. We would also get to cover other angles.

Feature requests without a sufficiently accurate or encompassing description of
the problem space to address will not be accepted.

Where Do Feature Requests Go?
=============================

Feature requests can be entered in to the Kolab development platform using
`this form <https://git.kolab.org/maniphest/task/edit/form/12/>`_.

It's submitted to the backlog of the :red:`Architecture & Design` team.

The `Architecture & Design`_ team evaluates the enhancement requests, requests
additional feedback if needed, and assigns the priority should the request be
promoted.

The responsibility of this team is to ensure that, in the inception phase, and
before the elaboration phase;

*   we have an accurate and full problem space description, and

*   we understand the scope and dimensions of the problem space, and

*   we can successfully determine where the problem should be resolved, and

*   we can determine the resolution to this problem space makes sense for the
    product that is Kolab, or

*   we can determine that the problem space is better addressed by existing,
    external tooling, and find a means for that external tooling to be
    integrated with Kolab, or

*   we can determine that addressing the problem space does not enhance the
    Kolab product, and

*   an estimate value of resolving the problem space can be established.

This leads to a common understanding of scope of delivery, the definition of
done, and the way to verify the results.

**Backlog**

All feature enhancement requests put forth. Mostly with wishlist priority.

**Inception**

Would this change the world? How would this change the world?

**Elaboration**

How do we change the world?

**Construction**

The hardhats get to putting the brick and mortar in place.

**Transition**

.. This part of the process is called :ref:`developer-guide-process-inception`.

Inception Phase
===============

During the inception phase, the case for the feature is evaluated by the
Product Owner(-ship). The scope and interactions are discussed and a high-level
decision is made about the design. Use cases and described and it is discussed
how the feature is relating to the general vision of the product.

The case can include success criteria, risk assessment, Business context, and
an estimate of resources needed.

Decisions are documented in the Phabricator task.

The outcome of the inception phase is:

#.  An initial use-case

#.  An initial case for the feature.

#.  An initial understanding of the requirements

The feature may be cancelled or considerably re-thought during this phase.

Elaboration Phase
=================

The purpose of the elaboration phase is to analyze the problem domain,
establish a sound architectural foundation, and eliminate the highest risk
elements.

To accomplish these objectives, an understanding of the whole system needs to
be achieved. The Product Owner is working with Architects, developers and other
stakeholders to describe the feature in details, and perhaps build an
executable architecture prototype in one or more iterations, depending on the
scope, size, risk, and novelty of the feature. The result could address the
critical use cases identified in the inception phase, which typically expose
the major technical risks.

While an evolutionary prototype of a production-quality component is always the
goal, this does not exclude the development of one or more throwaway prototypes
to mitigate specific risks such as design/requirements trade-offs, component
feasibility study, or demonstrations to customers and end-users.

The outcome of the elaboration phase is:

#.  All use cases and actors have been identified, and most use-case details
    have been defined.

#.  A set of subtasks in phabricator which reflects a full overview of
    requirements and the Architecture.

#.  (Possibly) An executable architectural prototype.

#.  A revision of the original task in phabricator that reflects the revised
    envision of the feature.

#.  A skeleton development plan for the progress of the feature.

#.  Possibly the first iteration of documentation.

Construction Phase
==================

During the construction phase, all components are developed and integrated into
the feature, and the feature is thoroughly tested together with all other
features that has been touched in the same realm.

The construction phase is, in one sense, the manufacturing process. The work on
the feature is pushed through one or more sprints, and the outcome of the is a
product ready to packaged and delivered. At minimum, it consists of:

#.  The software product integrated on the appropriate platforms.

#.  The user manual (docs.kolab.org).

#.  A description of the current release (..to become errata).

Transition Phase
================

The purpose of the transition phase is to package the software, and transition
it to the user community.

Once the feature has been packaged (most possibly together with other features
in a bigger package), tested, and delivered to the end users, issues usually
arise that require you to develop new releases, correct some problems, or
finish subfeatures (subtasks) that were postponed.

The Transition phase results in:

#.  A (set of) package(s) ready for end user consumption available on the
    Kolab Systems mirror.

#.  An update to the documentation about the feature containing upgrade or
    install guide for the feature.

#.  Updated errata delivered together with the package.
