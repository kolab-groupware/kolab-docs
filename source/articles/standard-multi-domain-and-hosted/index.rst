=======================================
Standard, Multi-Domain and Hosted Kolab
=======================================

Kolab Groupware is a flexible collaboration suite and in addition to
its standard deployment, also supports both *multi-domain* and *hosted*
deployments.

The difference between a standard Kolab Groupware environment, a
multi-domain, and a hosted deployments is as follows:

**Standard**

    A standard deployment of Kolab Groupware is designed to serve a
    single organization's collaboration needs.

    This includes features such as Shared Folders and Resource
    Management, Invitation Policies and Delegation, and Recipient
    Policies and Distribution Groups.

    A *standard* Kolab Groupware deployment also supports
    :term:`alias domain name spaces`, meaning that a setup for a
    domain name space of ``example.org`` can let its users have
    additional recipient email addresses in an alias domain name space
    of ``example.de`` and/or ``example.ch``.

**Multi-Domain**

    A multi-domain deployment of Kolab Groupware is designed to serve
    multiple organizations' collaboration needs based on a single
    deployment of Kolab Groupware.

    This is to say that an organization such as **Business, Inc.** with
    a primary domain name space of ``business.co.uk`` can use the same
    infrastructure as an organization **Competitor, Ltd.** with a
    primary domain name space of ``competitor.de``.

    Each of these organizations may, aside from their primary domain
    name space, hold one or more alias domain name spaces (rendering
    the primary domain name space a :term:`parent domain name space`).

    While the two organizations use the same deployment and the same
    infrastructure, information of neither organization may become
    available to the other organization -- accidentally nor otherwise.

    **Multi-domain** deployments are designed specifically such that
    there is a clear boundary between the spaces in which the users of
    each organization collaborate.

    However, not all of the most recent features added to Kolab
    Groupware are immediately also available to multi-domain
    environments. Resource Management for example is one of such recent
    features. This is why a default setup is not already configured to
    be or become a multi-domain setup, and the HOWTO for multi-domain
    is community-contributed.

**Hosted Kolab**

    A hosted Kolab Groupware deployment is very similar to a
    *multi-domain* deployment, but allows users (customers) to register
    accounts and domains themselves, and adds revenue to the deployment
    by invoicing the customers.

    Allowing customers to create accounts brings with it a set of
    additional requirements, such as new users confirming either one of
    the identifying pieces of information (a phone number, an email
    address or even just a physical address), which in your
    jurisdiction you may or may not be required to request.

    Furthermore, for customers that register a domain name space,
    you'll need to be able to confirm the customer's ownership of that
    domain name space.
