.. _introduction-do-it-yourself-or-kolab:

=========================
Do It Yourself, or Kolab?
=========================

.. NOTE::

    While we put an emphasis on the benefits of using Kolab Groupware
    rather than you DIY groupware server, please do not feel
    discouraged to pursue a DIY groupware server on your own -- we
    believe that once you have, you may appreciate Kolab Groupware more,
    rather than less.

Should you choose to DIY a groupware server, you would typically start
with choosing a series of components that are available to you that
could be made to provide you with the set of features you desire. A
suggested set of such components might include:

*   A Mail Transfer Agent (MTA) such as **Postfix**,

*   An IMAP server such as **Cyrus IMAP**,

*   A web client such as **Roundcube**,

*   An LDAP server such as **389 Directory Server**.

You would be able to hook up Postfix to Cyrus IMAP, hook up Postfix to
LDAP for recipient email address verification and authentication, hook
up Cyrus IMAP to LDAP for authentication and authorization, and hook up
the web client to Postfix, Cyrus IMAP and LDAP, providing you with a
basic infrastructure to exchange emails.

Even just the initial setup can appear quite daunting -- something as
seemingly straight-forward as SMTP turns out to become quite complex
when you keep security and integrity in mind, but you want to enable
your users to send using an envelope sender address that is not their
authorization ID (i.e. their login username).

Additional configuration could be applied to provide the web client
with a Global Address Book for auto-completion and distribution groups,
and probably also a few other features of the software. However it
could not be set up to include additional user identities, alias sender
email addresses, delegation nor managed shared folders.

This may leave some items to be desired, but perhaps not all of them are
equally important to you personally;

In the category of **automation**:

*   The initial setup may lead you to read many, very many HOWTOs and
    more (or less) detailed documentation spread across the web, to see
    what components to use/prefer/choose for the set of functionality
    you desire, and how to configure the individual components in such
    a way they function together.

*   After you create a user in LDAP, you may still need to create a
    mailbox.

*   When you change a user's name or email address, those changes may
    still need to be reflected elsewhere, such as access control lists
    on IMAP folders, the user's INBOX path, the user's web client
    profile name, etc.

*   You may have to update your configuration each time you add a new
    domain.

*   When you're done, you may still only have a mail server and not a
    groupware server.

As such, a DIY groupware server might benefit from a little **glue** to
tie together the various components -- Kolab Groupware is that glue.

In the category of **features**:

*   You may wish to be able to provide calendaring, address books, task
    lists, and other such nifty groupware features to your users,

*   You may then also wish to be able to provide this content to
    various desktop clients, that may speak IMAP, CardDAV and/or
    CalDAV,

*   You may desire mobile device synchronization, such as your phone,
    phablet or tablet.

As such, to wrangle a full-featured groupware server yourself could
become cumbersome. An enjoyable learning experience perhaps, but
cumbersome nonetheless. Kolab Groupware provides these features, among
many others, out of the box.
