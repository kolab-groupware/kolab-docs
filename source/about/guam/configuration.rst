=============
Configuration
=============

The **Guam** configuration lives in
:file:`rel/kolab_guam/releases/*/sys.config` when running from source
directly, and in :file:`/etc/guam/sys.config` for installation from packages.

The configuration file consists of sections for each of the applications to
configure, where it needs to be understood that **kolab_guam** is one such
application, and **lager** for logging, and **sasl** for authentication, are
two of the other sections.

This documentation only involves the **kolab_guam** section, and we refer you
to the documentation upstream for the others.

Since **Guam** is a reverse IMAP proxy, it needs to be configured against an
IMAP server (the backend "imap_servers"), and it needs to be configured to
receive client connections (the "listeners").

IMAP (backend) Server Configuration
===================================

The default configuration for **imap_servers** looks as follows:

.. code-block:: erlang
    :linenos:

            {
                imap_servers, [
                    {
                        imap, [
                            { host, "127.0.0.1" },
                            { port, 143 },
                            { tls, starttls }
                        ]
                    },
                    {   
                        imaps, [
                            { host, "127.0.0.1" },
                            { port, 993 },
                            { tls, true }
                        ]
                    }
                ]
            },

On line *4* and line *11* each start the configuration for a new backend
server, named *imap* and *imaps* respectively.

.. NOTE::

    Strictly speaking, only one backend is required. The default configuration
    only uses two to show how multiple backends could be configured. One
    could configure completely different backends (say, 'kolabnow.com' and
    'myhome.dyndns.org' for example).

The *imap* backend connects to host `127.0.0.1` on port `143` and is
configured to use `STARTTLS`.

The *imaps* backend however connects to host `127.0.0.1` on port `993` and is
configured to use implicit SSL/TLS.

Listener Configuration
======================

The following **listeners** are configured by default:

.. code-block:: erlang
       :linenos:

            {
                listeners, [
                    {
                        imap, [
                            { port, 9143 },
                            { imap_server, imap },
                            {
                                rules, [
                                    { filter_groupware, [] }
                                ]
                            },
                            {
                                tls_config, [
                                    { certfile, "/etc/pki/tls/private/localhost.pem" }
                                ]
                            }
                        ]
                    },
                    {
                        imaps, [
                            { port, 9993 },
                            { implicit_tls, true },
                            { imap_server, imaps },
                            {
                                rules, [
                                    { filter_groupware, [] }
                                ]
                            },
                            {
                                tls_config, [
                                    { certfile, "/etc/pki/tls/private/localhost.pem" }
                                ]
                            }
                        ]
                    }
                ]
            }

Again, each listener is provided with an identity (*imap* and *imaps*
respectively), listens on a different port (*9143* and *9993* respectively),
with subtly different configuration;

*   The *imap* listener on port *9143* is supposed to be used by clients that
    are configured to use `STARTTLS`,

*   The *imaps* listener on port *9993* is supposed to be used by clients that
    are configured to use implicit SSL/TLS (hence the `{ implicit_tls, true }`
    on line *22*.

The **imap_server** configuration for each of the listeners contains the name
of the backend IMAP server configuration to use.

.. NOTE::

    Note that a plaintext, STARTTLS and implicit SSL/TLS **listener** can,
    each of them separately, use a plaintext, STARTTLS and/or implicit SSL/TLS
    backend IMAP server (configured in the **imap_servers** section).

Configuration in a Kolab Groupware Setup
========================================

In a Kolab Groupware setup, **Guam** is configured with **listeners** on ports
`143` and `993`, against an **imaps** IMAP server on `localhost` port `9993`.
