=====================================
What is the Recommended Distribution?
=====================================

When people first come around looking for Kolab, and they get in touch,
we often receive questions along the lines of;

    *What distribution can you recommend for Kolab?*

Our answer is always a sound;

    *Enterprise Linux 7.*

In our book, this means CentOS or Red Hat Enterprise Linux.

This may sound like a very narrow recommendation, and Kolab has been,
currently is, will soon, and will continue to be available to wide
variety of future versions of many more (GNU/)Linux distributions.

Why it is the Recommended Distribution
======================================

There are several reasons for an upstream project like Kolab to choose a
reference implementation -- these are, to a larger or a lesser extent;

*   It functions as the minimum bar for the product to work on, before
    development is considered principally feature-complete [#]_,

*   It allows continued focus on the existing facilities of the chosen
    reference implementation, allowing for quick repetition of tasks
    such as deployment (for development, quality assurance, etc.),

*   A reference implementation increases contributors' familiarity with
    the platform, which includes the versions of Python, PHP, MySQL,
    GCC, cmake, Qt, Postfix, Cyrus IMAP, OpenSSL, 389 Directory Server,
    httpd, and the many other languages, build requirements and
    components included with a Kolab Groupware deployment and its
    development,

*   A common default implementation allows contributors to ultimately
    work (together) yet a little quicker, since all of them are looking
    at very much the same thing, at the same file paths, with the same
    default configuration, and all of them have gathered experience
    over time, and all of them can help one another,

*   Packaging and release management can focus on achieving one thing
    first, before scarse time is spent on all things at the same time,

*   Documentation can be unified around a single primary platform, with
    all others becoming exceptions to the rule. This includes but is not
    limited to;

    #.  names of software packages,
    #.  paths to configuration files,
    #.  payload locations such as an IMAP spool or MariaDB database.

That said, this is naturally subject to lacking automated deployment and
quality assurance -- which could then be extended and repeated on other
platforms, or continuous integration with functional testing, but still
a build error on a platform that is not the reference implementation
could be considered a *bug* rather than a *release blocker*.

As to why Enterprise Linux specifically is the distribution of choice;

*   The majority of Kolab Systems employees is, and has been for a long
    time, intimately familiar with the Fedora Project in participatory
    fashion, and at leadership levels.

*   The majority of system engineers employed by Kolab Systems is RHCE
    certified.

*   The support cycle for the distribution is a predictable decade.

*   With running Fedora on our workstations, we become intimately
    familiar with the next generation of Enterprise Linux even before
    its vendor, Red Hat, Inc., is aware of the scope of delivery of
    their next generation of Enterprise Linux.

*   There's both a freely accessible version of it (CentOS), and a
    proper version under support (Red Hat Enterprise Linux). Both the
    community at large, businesses and individuals included, as well as
    organizations meaning serious business have a choice without the
    two distributions causing head-ache.

*   The platform has a very predictable life-cycle.

*   The subscription model does not lock you in with a particular
    version.

*   The platform has a very predictable release cycle.

.. rubric:: Footnotes

.. [#]

    For a development cycle to be *feature-complete* is not to say the
    product is *bug-free* or *portable*.
