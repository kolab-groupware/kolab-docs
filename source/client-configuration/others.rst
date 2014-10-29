Other Clients
=============

You can basically connect every standard email application with support for the 
IMAP protocol with our service. Please use the following settings to connect:


.. index:: IMAP Server
.. _settings-clientconfig-imap-generic:

IMAP Settings
-------------

*Incoming server (IMAP):*
    |**imap_host**|

*Port/Security:*
    |**imap_port**| + |**imap_ssl**|

*Authentication:*
    **Password**

*Username:*
    |**useremail**|

Please use your **full and primary email address** as username here.


.. index:: SMTP Server
.. _settings-clientconfig-smtp-generic:

SMTP Settings
-------------

*Outgoing server (SMTP):*
    |**smtp_host**|

*Port/Security:*
    |**smtp_port**| + |**smtp_ssl**|

*Authentication:*
    **Password**

*Username:*
    |**useremail**|

Please use your **full and primary email address** as username here.


.. only:: tls

    .. note::

        We offer TLS  encryption for the connection to these services and 
        advise  to always use it.


.. only:: dav

    .. index:: CalDAV, CardDAV
    .. _settings-clientconfig-dav-generic:

    CardDAV and CalDAV Settings
    ---------------------------

    Please point your `CalDAV <https://en.wikipedia.org/wiki/CalDAV>`_ and 
    `CardDAV <https://en.wikipedia.org/wiki/CardDAV>`_ capable client to either 
    one of these addresses:

    *For CalDAV:*
        |**caldav_uri**|

    or
        |**caldav_uri_long**|

    *For CardDAV:*
        |**carddav_uri**|

    or
        |**carddav_uri_long**|


.. only:: webdav

    .. index:: WenDAV
    .. _settings-clientconfig-webdav-generic:

    Files
    -----

    The easiest way to access your files is using the web client. In the top 
    right corner, you can just choose 'Files'.

    You can also use any `WebDAV <https://en.wikipedia.org/wiki/WebDAV#Clients>`_ 
    capable client to get access to your files. 
    Just point it to one of the following locations.

    **https://**\ |**webdav_host**|

    **webdavs://**\ |**webdav_host**|

    **davs://**\ |**webdav_host**|

    The first should work for most people. Try the others only if the first one 
    does not work for you.
