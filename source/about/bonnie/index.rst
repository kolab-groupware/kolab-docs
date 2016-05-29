.. _about-bonnie:

======
bonnie
======

Bonnie is a proto-type event listener for :ref:`about-cyrus-imapd`, that takes
events that occur in IMAP and puts the relevant information in
**Elasticsearch** or **Riak**.

It serves either or all of the following generic purposes:

#.  Archival
#.  Backup & Restore
#.  Audit Trail
#.  e-Discovery

Under these umbrellas, things like groupware item changelogs could be made
available.

.. toctree::
    :maxdepth: 1
    :glob:

    *
