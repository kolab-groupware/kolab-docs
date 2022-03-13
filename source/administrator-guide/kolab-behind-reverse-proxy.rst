==================================
Using Kolab Behind a Reverse Proxy
==================================

Kolab's HTTP services work well behind a reverse proxy when properly
configured. This guide offers an example Apache configuration for a
reverse SSL proxy.

Configuring the Proxy
=====================
The following configuration examples use ``https://example.com`` as
external URL and ``http://192.168.0.1`` as internal URL.

A simple Apache configuration could be as follows. It only allows
secure connections, except for Thunderbird's autodiscovery.

.. parsed-literal::

    Define myservername example.com
    Define mykolabip 192.168.0.1
    
    <VirtualHost \*:80>
        ServerName ${myservername}
        ServerAlias www.${myservername}
        ServerAlias autodiscover.${myservername}
        # use e.g. for ACME verification:
        DocumentRoot /var/www/html
        
        RewriteEngine On

        # Thunderbird Autodiscovery (proxy)
        ProxyPreserveHost On
        RewriteRule ^/mail/config-v1.1.xml$ http://${mykolabip}/mail/config-v1.1.xml [P]
        RewriteRule ^/.well-known/autoconfig/mail/config-v1.1.xml$ http://${mykolabip}/mail/config-v1.1.xml [P]

        # CalDAV autodiscovery (redirect)
        RewriteRule ^/.well-known/caldav   https://%{SERVER_NAME}/iRony/ [L,R=301]
        RewriteRule ^/.well-known/carddav  https://%{SERVER_NAME}/iRony/ [L,R=301]

        # Redirect to secure site
        RewriteRule !^/.well-known https://%{SERVER_NAME}%{REQUEST_URI} [R=301,L]
    </VirtualHost>
    
    <VirtualHost \*:443>
        ServerName ${myservername}
        ServerAlias www.${myservername}
        ServerAlias autodiscover.${myservername}
        DocumentRoot /var/www/html

        ProxyPreserveHost On
        RewriteEngine On

        # Microsoft autodiscovery
        RewriteCond "%{HTTP_HOST}" "=autodiscover.${myservername}"
        RewriteRule !^/autodiscover https://%{SERVER_NAME}/autodiscover/autodiscover.xml [L,R=301,NC] 
        
        # CalDAV autodiscovery
        RewriteRule ^/.well-known/caldav   /iRony/ [L,R=301]
        RewriteRule ^/.well-known/carddav   /iRony/ [L,R=301]

        # Proxy everything to Kolab
        ProxyPass "/.well-known" "!"
        ProxyPass / http://${mykolabip}/
        ProxyPassReverse / http://${mykolabip}/
        
        # SSL configuration
        SSLEngine On
        SSLCertificateFile #PATH_TO_SSL_CERTIFICATE
        SSLCertificateKeyFile #PATH_TO_SSL_KEY
    </VirtualHost>

Within a more complicated setup, it might be required that only Kolab
services are proxied. In that case, add explicit ``ProxyPass`` and
``ProxyPassReverse`` directives for URLs used by Kolab:

.. parsed-literal::

	ProxyPass /roundcubemail http://${mykolabip}/roundcubemail
	ProxyPassReverse /roundcubemail http://${mykolabip}/roundcubemail
	ProxyPass /Microsoft-Server-ActiveSync http://${mykolabip}/Microsoft-Server-ActiveSync
	ProxyPassReverse /Microsoft-Server-ActiveSync http://${mykolabip}/Microsoft-Server-ActiveSync
	ProxyPass /freebusy http://${mykolabip}/freebusy
	ProxyPassReverse /freebusy http://${mykolabip}/freebusy
	ProxyPass /kolab-webadmin http://${mykolabip}/kolab-webadmin
	ProxyPassReverse /kolab-webadmin http://${mykolabip}/kolab-webadmin
	ProxyPass /iRony http://${mykolabip}/iRony
	ProxyPassReverse /iRony http://${mykolabip}/iRony
	ProxyPass /chwala http://${mykolabip}/chwala
	ProxyPassReverse /chwala http://${mykolabip}/chwala

Configure the Kolab Backend
===========================

Chwala and the Kolab Web Administration Panel may need to be told
explicitly which URLs to use for their APIs.

For Chwala and the Roundcube kolab_files plugin, add to the Roundcube
configuration file (see :ref:`admin_roundcube-settings`):

.. parsed-literal::

    $config['file_api_url'] = 'http://localhost/chwala/api/';
    $config['kolab_files_url'] = 'https://example.com/chwala/';

For kolab-webadmin, add to :file:`/etc/kolab/kolab.conf`:

.. parsed-literal::

    [kolab_wap]
    api_url = http://localhost/kolab-webadmin/api
