Troubleshooting for HTTP-based services
========================================

A good first start to troubleshoot an issue with a HTTP-based service is to check your webserver's error log.
For Apache this usually resides in :file:`/var/log/apache2/`.

.. _troubleshooting_error-logging:

Enable General Error Logging
----------------------------

Before you start to debug your problem,
please make sure that you actually have error logging enabled.

You would edit the file :file:`/etc/roundcubemail/config.inc.php`
and verify that the debug level is set correctly.

.. parsed-literal::
    $config['debug_level'] = 1;

.. note::
    The :command:`tail -f` command can be helpful in identifying the right message during incoming requests.
    It displays changes to the log file on the screen as the log messages come in.

Kolab Webclient
---------------

After :ref:`enabling general error logging <troubleshooting_error-logging>`,
you should already find some messages in your webserver's error log.

Additionally, the following configuration options are available for specific debugging.

.. parsed-literal::
    // Log sent messages to /var/log/roundcubemail/sendmail
    $config['smtp_log'] = true;

    // Log session authentication errors to /var/log/roundcubemail/session
    $config['log_session'] = true;

    // Log SQL queries to /var/log/roundcubemail/sql
    $config['sql_debug'] = true;

    // Log IMAP conversation to /var/log/roundcubemail/imap
    $config['imap_debug'] = true;

    // Log LDAP conversation to /var/log/roundcubemail/ldap
    $config['ldap_debug'] = true;

    // Log SMTP conversation to /var/log/roundcubemail/smtp
    $config['smtp_debug'] = true;

It is also possible to debug the Kolab Webclient for individual users only
by creating a :file:`/var/log/roundcubemail/<username>/` folder
and setting the following configuration parameter.

.. parsed-literal::
    $config['per_user_logging'] = true;

Please make sure that this location is writeable by your webserver.

ActiveSync
----------

For debugging ActiveSync issues,
you would add the following to :file:`/etc/roundcubemail/config.inc.php`:

.. parsed-literal::
    $config['activesync_debug'] = true;

Useful messages should then appear in the :file:`/var/log/kolab-syncroton/console` file.
If there is no such file, please make sure that your webserver actually has the rights to create this file. 

It is also possible to debug ActiveSync sessions of individual users only
by creating a :file:`/var/log/syncroton/<username>/` folder
and setting the following configuration parameter.

.. parsed-literal::
    $config['activesync_user_debug'] = true;

Please make sure that this location is writeable by your webserver.

iRony
-----

After :ref:`enabling general error logging <troubleshooting_error-logging>`,
you should already find some messages in your webserver's error log.

Additionally, you can enable the debug console
that shows the internal function calls triggered by HTTP requests.

.. parsed-literal::
    $config['kolabdav_console'] = false;

This will write debug log messages to :file:`/var/log/iRony/console`.

It is also possible to debug DAV sessions of individual users only
by creating a :file:`/var/log/iRony/<username>/` folder
and setting the following configuration parameter.

.. parsed-literal::
    $config['kolabdav_user_debug'] = true;

Please make sure that this location is writeable by your webserver.

Sometimes it can be useful to track the full HTTP payload of DAV requests.
In order to do this, add the following setting.

.. parsed-literal::
    // (bitmask of these values: 2 = HTTP Requests, 4 = HTTP Responses)
    $config['kolabdav_http_log'] = 6;





