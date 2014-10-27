.. _and-bonnie-client-api:

=================
Bonnie Client API
=================


Client-Server Communication
===========================

While initially the Bonnie API will serve as a read-only service to respond on 
concrete requests from clients to deliver object changelogs, the protocol 
should remain capable of allowing a bi-directional communication between the 
participating end-points.

Technology
----------

The idea is to implement a stateless web service based on the JSON-RPC 2.0 
Protocol [#]_ using HTTPS as the underlying protocol.

In this document, RPC calls will be specified in the following manner:

**Method**:

.. parsed-literal::

     method.name ( named-arg: "<value-description>"[, optional-arg: [ <array values> ]] )

**Result**:

.. parsed-literal::

  { key: "value" }

For method arguments and results, JSON-like formatting is used to indicate the 
data types.


Client Authentication
---------------------

A connecting client must first authenticate itself in order to be allowed for 
further interactions with the API. This is primarily meant to abort 
unauthorized access to the web service from unknown clients in an early stage 
of the communication. Client credentials consists of 3 parts:

*   Client-ID
*   Password
*   *Client Secret*

HTTP Authentication
^^^^^^^^^^^^^^^^^^^

If the API requires HTTP authentication, every non-authenticated HTTP request 
shall be responded with a ``401 Authentication Required`` response which 
indicates that clients should send previously negotiated HTTP Basic 
authentication headers with subsequent requests.

The Client-ID and the password are sent via Basic HTTP authentication to 
identify the connecting client and to grant access on a transport layer (HTTP) 
level.


User Authentication
-------------------

Once the client is identified and authorized to use the Bonnie API, the actual 
human user accessing data through the API needs to be identified. This shall 
restrict access to stored data the requesting user is actually permitted to 
read based on privileges and/or organizational structures.

Although the API is meant to be a stateless service, certain means to restrict 
access are required because requests may (at least partially) be initiated by a 
user-facing client and therefore should be proof to manipulation.

With every request to an API method, the client shall supply the 
fully-qualified identifier of the requesting user together with a hashed value 
acting as a signature to prove the authenticity of the request. These values 
are provided as custom headers in the HTTP request to the API:

.. parsed-literal::

    X-Request-User: john.doe@example.org
    X-Request-Sign: M6NzoiY291bnRyeSI7czozOiJVU0EiO319czo1OiJwaG9uZSI7YToxOn

The signature shall be composed as a HMAC (SHA-256) value from the user identifier and the full request payload using the *client secret* which is never transmitted through this API.

Generating Request Signatures
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#.   Compose the JSON string for the RPC call

#.   Concatenate the user identifier and the JSON string:
     ``data = user-identifier ":" json-string``

#.   Generate the hash value with the HMAC method using the SHA-256 algorithm and the ``client-secret`` value.

#.   Send the hash value in the HTTP header ``X-Request-Sign`` together with the ``X-Request-User`` header before the actual JSON-RPC payload.


Before processing the RPC command, the web service provider shall verify the 
request signature and in case the signature doesn't match the payload, reject 
the request with a JSON-RPC error code ``-32600`` indicating an *invalid 
request*.


Retrieving Object Changes
=========================

The API exposes methods for every object type to get particular information about the history of a given groupware object. Method names have the following syntax:

.. parsed-literal::

    <object-type>.<action>

*Example*:

.. parsed-literal::

  event.diff


Fetch created date and user
---------------------------

*Method*: ``<object>.created ( uid: "<object-uid>"[, folder: "<IMAP-mailbox-identifier>" ])``

*Result*:

.. code-block:: json

    {
        uid: "<object-uid>",
        date: "<creation-date-time>",
        user: "<creating-user>",
        mailbox: "<IMAP-mailbox-identifier>"
    }

If no ``mailbox`` argument is provided, the object is searched in the given user's folders with priority on personal namespace.

Date value is provided as ISO 8601 Date/Time including timezone information.

*Example result*:

.. code-block:: json

    {
        uid: "0015c5fe-9baf-0561-11e3-d584fa2894b7",
        date: "20140109T13:22:49Z",
        user: "User, Sample <user.sample@example.org>"
        mailbox: "user/user.sample/Calendar@example.org"
    }

Fetch last change information
-----------------------------

*Method*: ``<object>.lastmodified ( uid: "<object-uid>"[, folder: "<IMAP-folder-path>" ] )``

*Result*:

.. code-block:: json

    {
        uid: "<object-uid>",
        rev: <revision-number>
        date: "<change-date-time>",
        user: "<changing-user>",
        mailbox: "<IMAP-mailbox-identifier>"
    }

Date value is provided as ISO 8601 Date/Time including timezone information.

Full Changelog
--------------

*Method*: ``<object>.changelog ( uid: "<object-uid>"[, folder: "<IMAP-folder-path>" ] )``

*Result*:

.. code-block:: json

    {
        uid: "<object-uid>",
        changes: [
            {
                rev: <revision-number>,
                op: "<operation>",
                date: "<change-date-time>",
                user: "<changing-user>",
                mailbox: "<IMAP-mailbox-identifier>"
            } *
        ]
    }

Date value is provided as ISO 8601 Date/Time including timezone information.

The ``op`` (operation) property reflects the IMAP operation performed and can contain one of the following values: ``APPEND, MOVE, DELETE``.

*Example Result*:

.. code-block:: json

    {
        uid: "0015c5fe-9baf-0561-11e3-d584fa2894b7",
        changes: [
            {
                rev: 1,
                op: "APPEND",
                date: "2014-01-09T13:22:49Z",
                user: "User, Sample <user.sample@example.org>",
                mailbox: "user/user.sample/Calendar/Personal@example.org"
            },
            {
                rev: 2
            },
            {
                rev: 3,
                op: "APPEND",
                date: "2014-04-16T19:51:22Z",
                user: "Doe, Jane <jane.doe@example.org>",
                mailbox: "shared/Calendars/Groupcal"
            },
            {
                rev: 4,
                op: "DELETE",
                date: "2014-06-29T07:32:11Z",
                user: "Doe, John <john.doe@example.org>",
                mailbox: "shared/Calendars/Groupcal"
            }
        ]
    }

Retrieving an Old Revision
--------------------------

*Method*: ``<object>.get ( uid: "<object-uid>", rev:"<revision>"[, folder: "<IMAP-folder-path>" ] )``

*Result*:

.. code-block:: json

    {
        uid: "<object-uid>",
        rev: <revision-number>,
        xml: "<raw-xml-data>"
    }

Retrieving Diffs between two Object Revisions
---------------------------------------------

Generating and applying diffs in XML documents is not a trivial topic and if we'd decide to go down the full diff route, we should use existing tools to generate those diffs. But the benefit of a real XML diff is limited in terms of displaying changes to groupware objects because in order to generate a meaningful diff view, the semantics of the individual XML nodes within a certain groupware object are important and pure xml-level differences don't simplify the work of a client.

Thus loading full version of different revisions is likely simpler for clients to derive changes than looking at a XML diff. But in order to optimize the exchanged payload, the API could provide a diff on interpreted "properties" of a groupware object:

*Method*: ``<object>.diff ( uid: "<object-uid>", rev:"<rev1>:<rev2>"[, folder: "<IMAP-folder-path>" ] )``

*Result*:

.. code-block:: json

    {
        uid: "<object-uid>",
        rev: <revision-number>,
        changes: [
            {
                property: "<prop-name>",
                index: <prop-index>,
                old: <old-node-value-as-struct-or-native-type>,
                new: <new-node-value-as-struct-or-native-type>
            } *
        ]
    }

*Example result*:

.. code-block:: json

    {
        uid: "0015c5fe-9baf-0561-11e3-d584fa2894b7",
        rev: 4,
        changes: [
           {
               property: "rev",
               old: "20140524T190412Z",
               new: "20140609T085603Z"
           },
           {
               property: "n",
               old: { "surname": "Foo", "given": "Bard" },
               new: { "given": "Bob" }
           },
           {
               property: "tel",
               index: 0,
               old: { "params": { "type": "home" } },
               new: { "params": { "type": "mobile" } }
           },
           {
               property: "tel",
               index: 1,
               new: { "params": { "type": "work" }, "text": "(044) 555-22449" }
           },
           {
               property: "email",
               index: 1,
               old: { "params": { "type": "other" }, "text": "sonofanarchy@fastmail.fm" },
               new: null
           }
        ]
    }

Properties are top-level nodes from the Kolab XML Format 3.0 and property names used in the diff data match the ``property-*`` identifiers as described in the XML Format Specification [#]_.

If a property is a struct, the ``new`` parameter only denotes the attributes which differ from the ``old`` value. If an attribute was removed, it shall be represented as an empty string.


.. rubric:: Footnotes

.. [#]

    JSON-RPC 2.0 Specification: http://www.jsonrpc.org/specification

.. [#]

    XML Format Specification http://wiki.kolab.org/User:Mollekopf/Drafts/KEP:17
