==========================================================================
HOWTO: Exchange Free/Busy Information between Kolab and Microsoft Exchange
==========================================================================

This HOWTO is useful for deployment scenarios that meet the following
specifications:

*   Kolab Groupware users are Contacts in Microsoft Active Directory, and
    Microsoft Exchange users are Contacts in Kolab Groupware (LDAP).

*   The domain name space(s) used between the two environments overlap and
    share at least one domain name space among all users.

*   Internet Calendar Publishing is enabled for Microsoft Exchange users.

*   The global search path for Contact's Free/Busy information is set to:

    .. parsed-literal::

        https://kolab.domain.tld/freebusy/%NAME%@%SERVER%.ifb

Configuring Microsoft Exchange
==============================

.. IMPORTANT::

    In Microsoft Exchange, it is the client that publishes its Free/Busy
    information. No rule or configuration can be applied to let the server
    automatically update the Free/Busy information of Microsoft Exchange
    users (on the basis of their then current calendar contents), therefore
    possibly, at times, rendering a misrepresentation of a user's
    availability information.

.. NOTE::

    While it is commonly referred to as a requirement, and perhaps recommended,
    the configuration of an external URL on the Outlook Web Access Virtual
    Directory is not strictly required **for Kolab**, so long as the Kolab
    server can use the internal URL.

*   Enable Calendaring Publishing on the CAS servers:

    .. parsed-literal::

        $ :command:`Get-OWAVirtualDirectory | Set-OWAVirtualDirectory –CalendarPublishingEnabled:$true`

*   Set a Sharing Policy for the domain to **Anonymous** and the "action(s)
    that apply to the entered federated domain" to: "Calendar Sharing with
    free/busy information only".

Configuring Kolab Free/Busy
===========================

*   Create a service user account for Kolab to use to bind to the Microsoft
    Active Directory LDAP service, in the Microsoft Active Directory. This
    account should be awarded sufficient privileges to search for and find all
    object entries for Microsoft Exchange user accounts.

*   Edit :file:`/etc/kolab-freebusy/config.ini`, and add a directory definition
    for Microsoft Exchange.

    Depending on the version of Exchange, and the ability to publish Free/Busy
    information to anonymous users, or only authenticated users, and the level
    of interoperability entertained by your Exchange deployment, one of the
    following directory examples may work for you:

    **With ICS Free/Busy Publishing:**

    .. code-block:: ini

        [directory "exchange-users"]
        type = ldap
        host = ldap://exchange.domain.tld:389
        bind_dn = "cn=Service User,cn=Users,dc=yourdomain,dc=com"
        bind_pw = "<service-bind-pw>"
        base_dn = "cn=Users,dc=yourdomain,dc=com"
        filter = "(&(objectClass=account)(objectclass=mail-recipient)(|(mail=%s)(proxyAddresses=smtp:%s)))"
        attributes = mail
        fbsource = https://exchange.domain.tld/owa/calendar/%mail/Calendar/calendar.ics

    **With proprietary Exchange format XML publishing:**

    .. code-block:: ini

        [directory "exchange-users"]
        type = ldap
        host = ldap://exchange.domain.tld:389
        bind_dn = "cn=Service User,cn=Users,dc=yourdomain,dc=com"
        bind_pw = "<service-bind-pw>"
        base_dn = "cn=Users,dc=yourdomain,dc=com"
        filter = "(&(objectClass=account)(objectclass=mail-recipient)(|(mail=%s)(proxyAddresses=smtp:%s)))"
        attributes = mail
        format = exchange2010
        fbsource = https://exchange.domain.tld/public/?cmd=freebusy&interval=30&u=SMTP:%mail

