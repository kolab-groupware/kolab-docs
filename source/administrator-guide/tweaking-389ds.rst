=============================
Tweaking 389 Directory Server
=============================

The 389 Directory Server is one of the most important parts of your
Kolab deployment, as it is the sole authoritative source of all user,
group, role, resource, shared folder and mail routing information and
configuration.

..
    Currently not included in this segment:

    *   Narrowing the permissions in LDAP, of the Kolab credentials used, to
        the bare minimum required for Kolab to continue to function.

    *   Configuring Kolab (via :manpage:`kolab.conf(5)`) to not have access
        to directory manager credentials.

    *   Using a different LDAP hierarchy

.. _admin_ldap_controlling_indexes_and_indexing:

Controlling Indexes and Indexing
================================

Indexes are created for individual attributes, and may consist of one or
more of the following three types:

#.  Presence

    A presence index for attributes services queries with a filter such
    as "``(cn=*)``".

#.  Equality

    An equality index for an attribute services queries with a filter
    such as "``(mail=john.doe@example.org)``".

#.  Substring

    A substring index for an attribute services queries with a filter
    such as "``(mail=*joh*)``".

Presence and substring indexes may be used with, for example, auto-
completion, while equality indexes may be used in, for example, LDAP
lookup tables for Postfix.

Listing the current indexes for a database could be done using a script
such as:

    https://git.kolab.org/kolab-scripts/plain/utils/list-attribute-indexes.sh

Adding new attribute indexes for a database, and executing the task to
create the index, could be done with a script such as:

    https://git.kolab.org/kolab-scripts/plain/utils/add-attribute-index.sh

Recommended Additional Indexes
------------------------------

``alias``

    Kolab Groupware by default uses the ``alias`` attribute to store
    additional recipient email addresses for users. This attribute is
    not indexed by default.

``mailAlternateAddress``

    While the ``mailAlternateAddress`` is used, by default, as a
    container of any external email addresses for a user (such as a
    private or personal email address), you may find it is searched as
    part of auto-completion.

    Especially when using VLV/SSS, should the ``mailAlternateAddress``
    attribute index be a substring index, but it only contains an
    equality index by default.

.. _admin_ldap_configure-vlv:

Configuring Virtual List View Control
=====================================

Virtual List View features in the LDAP server aid in listing
pre-indexed and pre-sorted LDAP entries in a paginated fashion, and is a
required configuration item for deployments with over 1.000 entries in
their LDAP hierarchies [#]_, when also using an address book,
auto-completion and/or the Web Administration Panel.

On the side of the LDAP server, Virtual List Views consist of two
separate configuration items:

#.  The search, with a base dn, scope and filter.

#.  The index that includes the Server-Side Sorting parameters.

For an LDAP client to successfully use Virtual List View controls, it is
crucially important that:

#.  The search base dn and scope match the configuration of the VLV
    search, and

#.  Any attributes searched in addition to the configured VLV search
    filter are appropriately indexed.

By default, the configuration of primarily the Kolab web client uses the
following configuration parameters for browsing the LDAP address book:

.. rubric:: For Individual Contact Entries

*   **Search Base DN**: *ou=People,$root_dn*

    where *$root_dn* is the relevant root suffix, such as
    ``dc=example,dc=org``.

*   **Search Scope**: *sub*
*   **Search Filter**: *(objectClass=inetOrgPerson)*

.. NOTE::

    The search parameters for address book entries are deliberately
    **not** limited to only include other Kolab user entries.

The configuration for the LDAP address book also lists the order of
attributes to use when sorting the entries:

#.  displayname,
#.  sn,
#.  givenname,
#.  cn

This configures the LDAP server to first attempt sorting by
``displayname`` attribute value, then ``sn``, then ``givenname``, etc.

When two entries hold the same value for an attribute used with sorting,
the next attribute configured for sorting is used, if any.

When configuring the sorting attributes, only use combinations of
meaningful attributes, and preferrably as few as possible at a time.

When, for example, you want one list to be sorted by user's names, and
another list sorted by phone number, do not combine the two different
lists in to one sorting configuration. Instead, use multiple values for
the ``vlvSort`` attribute.

.. rubric:: For Groups

*   **Search Base DN**: *ou=Groups,$root_dn*

    where *$root_dn* is the relevant root suffix, such as
    ``dc=example,dc=org``.

*   **Search Scope**: *sub*
*   **Search Filter**: *(|(objectClass=groupOfUniqueNames)(objectClass=groupOfUrls))*

.. NOTE::

    For groups too, the search parameters for address book entries are
    deliberately **not** limited to only include other Kolab user
    entries.

The configuration for the LDAP address book also lists the order of
attributes to use when sorting the entries:

#.  cn

Creating the VLV and SSS configuration objects in an LDAP server may be
achieved using the following example scripts, in order:

#.  Creating the VLV Search configuration in LDAP:

    https://git.kolab.org/kolab-scripts/plain/populate-ldap/10a-add-vlv-searches.sh

#.  Creating the VLV Indexes with Sorting configuration in LDAP:

    https://git.kolab.org/kolab-scripts/plain/populate-ldap/10b-add-vlv-indexes.sh

#.  Subsquently, the index tasks should be executed:

    https://git.kolab.org/kolab-scripts/plain/populate-ldap/10c-run-vlv-index-tasks.sh

.. _admin_ldap_configure-sss:

Configuring Server-side Sorting Control
=======================================

Server-side Sorting control is a pre-requisite for Virtual List View
control.

If you are using Virtual List View (see
:ref:`admin_ldap_configure-vlv`), you are also already using Server-Side
Sorting.

.. _admin_ldap_increasing-max-open-fds:

Increasing the Maximum Number of File Descriptors
=================================================

A 389 Directory Server is configured to open at most 1024 so-called file
descriptors, which include database pointers, logs, replicas, statistics
and (client) network sockets.

Increase the default number of maximum open file descriptors from 1024.

To change the number to 8192:

#.  Edit :file:`/etc/sysconfig/dirsrv`, adding a line:

    .. parsed-literal::

        ulimit -n 8192

    .. NOTE::

        Note that your operating system may have other security
        limitations, and may have a system-wide limitation on the number
        of files as well. See :command:`sysctl fs.file-max` for your
        current limit.

#.  Stop the directory server:

    .. parsed-literal::

        # :command:`service dirsrv stop`

#.  Edit :file:`/etc/dirsrv/slapd-*/dse.ldif` and replace the following
    line:

    .. parsed-literal::

        nsslapd-maxdescriptors: 1024

    with:

    .. parsed-literal::

        nsslapd-maxdescriptors: 8192

#.  Start the directory server back up:

    .. parsed-literal::

        # :command:`service dirsrv start`

.. _admin_ldap_7bit-password-check:

Disabling the 7-bit Password Enforcement
========================================

By default, 389 Directory Server has enabled a plugin to only allow
passwords to consist of 7-bit characters.

Older systems and software applications do not support the use of 8-bit
characters (i.e., non-ASCII) in passwords, and to prevent compatibility
issues, this plugin is enabled by default.

To allow 8-bit characters, disable the **7-bit check** plugin:

.. parsed-literal::

    # :command:`ldapmodify -x -h localhost -D "cn=Directory Manager" -W`
    Enter LDAP Password:
    dn: cn=7-bit check,cn=plugins,cn=config
    changetype: modify
    replace: nsslapd-pluginEnabled
    nsslapd-pluginEnabled: off

    modifying entry "cn=7-bit check,cn=plugins,cn=config"

A restart of the directory service is required for this change the
become active:

.. parsed-literal::

    # :command:`service dirsrv restart`

.. _admin_ldap_disable-access-logs:

Disabling the Access Logs
=========================

Access logs are accounts of new connections, searches and other such
information about who accesses what, where from, and when.

In larger environments, this log can grow very large, very quickly, and
while disk space consumption is the lesser concern, the related disk I/O
may be more relevant.

Larger environments could choose to put :file:`/var/log/dirsrv/` on a
separate disk (separate from :file:`/var/lib/dirsrv/`), possibly even
in-memory *tmpfs*, or disable the access logs altogether.

To disable the access logs, run the following command:

.. parsed-literal::

    # :command:`ldapmodify -x -h localhost -D "cn=Directory Manager" -W`
    Enter LDAP Password:
    dn: cn=config
    changetype: modify
    replace: nsslapd-accesslog-logging-enabled
    nsslapd-accesslog-logging-enabled: off

    modifying entry "cn=config"

The directory server does not need to be restarted for this setting to
take effect.

.. _admin_ldap_enable-audit-logs:

Enabling the Audit Logs
=======================

Audit trails are important, especially when the access logs have been
disabled.

Audit logs include diffs of LDAP entries being modified, along with a
timestamp and the credentials used. As such, despite explicitly lacking
the source of the modification, provided a set of differentiated bind
credentials per service allowed to modify LDAP entries this can still be
a complete audit trail.

To enable the audit logs, run the following command:

.. parsed-literal::

    # :command:`ldapmodify -x -h localhost -D "cn=Directory Manager" -W`
    Enter LDAP Password:
    dn: cn=config
    changetype: modify
    replace: nsslapd-auditlog-logging-enabled
    nsslapd-auditlog-logging-enabled: on

    modifying entry "cn=config"

The directory server does not need to be restarted for this setting to
take effect.

.. rubric:: Footnotes

.. [#]

    VLV/SSS is not strictly required, and one alternative is to disable
    the look-through, search and time limits for all users. Doing so
    however allows any user to unfairly load the LDAP server with the
    heavy operation of searching large numbers of entries.
