.. _admin_wallace:

Enabling SMTP Content Filters
=============================

:ref:`and_mta_wallace` is a Kolab Groupware content-filter, adding functionality to the
SMTP message pipeline like resource scheduling, enforcement of invitation policies, appending
of footers and signatures, etc.


.. _admin_wallace-invitation-policy:

Invitation policies
-------------------

The :ref:`invitationpolicy module <and_mta_wallace-invitation-policy>` of Wallace processes
incoming iTip invitations or replies which address a local user. Depending on the recipient's
invitation policy settings or the global default, the iTip message is either automatically
processed or forwarded to the user's inbox or calendar for manual confirmation.

To enable the resource scheduling module, add ``invitationpolicy`` to the list of active
wallace modules in ``/etc/kolab/kolab.conf``:

.. code-block:: ini

    [wallace]
    modules = invitationpolicy, ...

A user's invitation policy settings are stored in LDAP using the
``kolabInvitationPolicy`` which can contain multiple values which are processed
from top to bottom until one matches the situation. A global default can be defined
in ``/etc/kolab/kolab.conf`` with

.. code-block:: ini

    [wallace]
    (...)
    kolab_invitation_policy = EVENT_ACCEPT_IF_NO_CONFLICT:example.org, ALL_UPDATE_AND_NOTIFY, ALL_MANUAL

The following values can be used to compose the invitation policy set:

.. _admin_wallace-invitation-policy-global-values:

General invitation policy settings
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

(apply to all iTip object types)

*   ``ALL_MANUAL``

    Forwards the message to the user's inbox for manual processing in the client.

*   ``ALL_ACCEPT``

    Always accepts the event invitation or task assignment. This will reply to
    the organizer with ``PARTSTAT=ACCEPTED`` and store the event in the user's
    default calendar or tasklist respectively.

*   ``ALL_REJECT``

    Always rejects the invitation or assignment. This will also store a copy of the
    rejected invitation in the user's default calendar for later reference.

*   ``ALL_UPDATE``

    When receiving an iTip REPLY, this policy automatically updates the copy of the
    referring object in the user's personal folders with the updated participant status
    of the replying user.

*   ``ALL_UPDATE_AND_NOTIFY``

    Same as ``ACT_UPDATE`` but with an additional notification email being sent to
    the recipient reporting the updated participants status or object properties
    which have changed.

*   ``ALL_SAVE_TO_FOLDER``

    No automatic accepting or rejecting is being done for iTip invitations here
    but the invitation is being saved in the user's default calendar or tasklist
    respectively and the iTip message is not forwarded to the user's email inbox.

*   ``ALL_SAVE_AND_FORWARD``

    Same as ``ALL_SAVE_TO_FOLDER`` but forwarding the original iTip message
    to the user's email inbox for notification purposes.


Event-specific policy settings
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*   ``EVENT_ACCEPT``

    Same as ``ALL_ACCEPT`` but only applies for event invitations.

*   ``EVENT_ACCEPT_IF_NO_CONFLICT``

    Same as ``EVENT_ACCEPT`` but only if the invitation doesn't conflict with an
    existing event in the user's calendar(s).

*   ``EVENT_TENTATIVE``

    Same as ``EVENT_ACCEPT`` but replying with ``PARTSTAT=TENTATIVE``.

*   ``EVENT_TENTATIVE_IF_NO_CONFLICT``

    Same as ``EVENT_TENTATIVE_IF_NO_CONFLICT`` but replying with ``PARTSTAT=TENTATIVE``.

*   ``EVENT_REJECT``

    Same as ``ALL_REJECT`` but only applies for event invitations.

*   ``EVENT_REJECT_IF_CONFLICT``

    Same as ``ACT_REJECT`` but only rejects invitations if they conflict with an
    existing event in the user's calendar(s).

*   ``EVENT_SAVE_TO_FOLDER``

    Same as ``ALL_SAVE_TO_FOLDER`` but only applies for event invitations.

*   ``EVENT_SAVE_AND_FORWARD``

    Same as ``ALL_SAVE_AND_FORWARD`` but only applies for event invitations.


Task-specific policy settings
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Basically all values from the :ref:`admin_wallace-invitation-policy-global-values`
but with the ``TASK_`` prefix instead of ``ALL_``.


Per sender invitation policies
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Each policy identifier can have a sender filter appended with ``:[sender@]domain.tld``.
If present, the policy will only be applied if the sender of the iTip message matches
the given domain or email address substring. Otherwise the entry will be ignored and
the process continues with the next entry in the list.

.. _admin_wallace-invitation-policy-autoupdate-others:

Auto-updating all participant's calendars
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Along with the ``ALL_UPDATE`` policy, :ref:`Wallace <and_mta_wallace>` can also update
copies of the referenced event in all the participant's calendars. With the regular iTip
workflow, an iTip REPLY will only inform the organizer about the participation status of
an individual. Enabling the following config option in ``/etc/kolab/kolab.conf`` will
instruct the server to automatically update the status in the personal calendars of
each listed participant.

.. code-block:: ini

    [wallace]
    (...)
    invitationpolicy_autoupdate_other_attendees_on_reply = true

.. NOTE::

    Auto-updating of all event copies is only executed if the event organizer
    receiving the iTip reply has activated the ``ALL_UPDATE`` invitation policy.


Resource scheduling
-------------------

The :ref:`resource scheduling <and_mta_wallace-resource-scheduling>` module of Wallace can
pick up incoming messages and identify iTip invitations which address a resource.
The invited resource's calendar is then consulted and the invitation is either accepted
or declined depending on the resource's availability for the requested time.

To enable the resource scheduling module, add ``resources`` to the list of active
wallace modules in ``/etc/kolab/kolab.conf``:

.. code-block:: ini

    [wallace]
    modules = resources, ...


.. _admin_wallace-footer:

Footers and signatures
----------------------

Another Wallace module can append footers or signatures to outgoing messages. Enable this
module by adding ``footer`` to the list of active wallace modules in ``/etc/kolab/kolab.conf``:

.. code-block:: ini

    [wallace]
    modules = footer, ...
    footer_text = /etc/kolab/footer.text
    footer_html = /etc/kolab/footer.html

The module requires the following additional config options:

``footer_text``

    Absolute path to a text file holding the contents of the footer to be added
    to plain text messages.

``footer_html``

    Absolute path to a text file holding the HTML formatted contents of the footer
    to be added to outgoing HTML messages.

