==================================
HOWTO: Use NGINX as the Web Server
==================================

This HOWTO consists of two separate approaches.

Simple Installation
===================

The simple configuration is supposed to provide only the webclient. This simple
setup only includes the webmail part (roundcubemail) and doesn't provide the
full experience (file browser, freebusy, caldav/carddav, etc).

If you look for a more complete setup including webadmin, irony, etc. take a
look on the complex setup.

#.  Install NGINX and PHP FPM:

    .. parsed-literal::

        # :command:`yum -y install nginx php-fpm`

#.  Configure **php-fpm** to listen on a local UNIX socket:

    .. parsed-literal::

        # :command:`sed -r -i \\
            -e 's|^listen = 127\.0\.0\.1.*$|listen = /var/run/php-fpm/php-fpm.sock|g' \\
            /etc/php-fpm.d/www.conf`

#.  Replace the contents of :file:`/etc/nginx/conf.d/default.conf`:

    .. parsed-literal::

        # :command:`cat > /etc/nginx/conf.d/default.conf` << EOF
        server {
            listen              8080 default_server;
            server_name         localhost:8080;

            # support |roundcubemail| secure urls
            rewrite "^/roundcubemail/[a-zA-Z0-9]{16}/(.*)" /roundcubemail/$1;

            # roundcube
            location /roundcubemail {
                alias /usr/share/roundcubemail/public_html;
                index index.php;

                location ~ \\.php$ {
                    include fastcgi_params;
                    fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;
                    fastcgi_split_path_info ^(.+.php)(/.*)$;
                    fastcgi_index index.php;
                    fastcgi_param SCRIPT_FILENAME $request_filename;
                }
            }
        }
        EOF

    .. note::

        On debian based systems you might want to take a look at the
        configuration :file:`/etc/nginx/sites-enabled/default` and a the
        the default php-fpm socket: :file:`/var/run/php5-fpm.sock`

#.  Start the **php-fpm** service and configure the service to start on boot:

    .. parsed-literal::

        # :command:`service php-fpm start`
        # :command:`chkconfig php-fpm on`

#.  Start the **nginx** service and configure the service to start on boot:

    .. parsed-literal::

        # :command:`service nginx start`
        # :command:`chkconfig nginx on`

More Complex Installation
=========================

The following configuration is tested for Kolab 3.4 on CentOS6. It
should also work under Debian and Ubuntu, provided you adjust paths
and filenames according to their defaults.

.. WARNING::

    To not create conflicts with the default apache configuration (which is
    installed due to dependencies) we should move the apache default port from
    80 to 8080.

    .. parsed-literal::

        # :command:`sed -i -e 's/^Listen 80$/Listen 8080/g' /etc/httpd/conf/httpd.conf`
        # :command:`service httpd restart`

    In theory we don't need the apache daemon anymore. We can turn it off.

    .. parsed-literal::

        # :command:`service httpd stop`
        # :command:`chkconfig httpd off`

Preperation and PHP-FPM
-----------------------

#.  Install NGINX and PHP FPM:

    .. parsed-literal::

        # :command:`yum -y install nginx php-fpm`

    Note that to get full WebDAV support, an additional module is needed for
    nginx. It's available from https://github.com/arut/nginx-dav-ext-module/,
    but requires a rebuild of nginx from source. Some clients work without it,
    others don't.

    .. note::

        On Debian just install the ``nginx-full`` package to get the full
        WebDAV support of nginx (adjust your configuration accordingly.

#.  Disable the default **php-fpm** configuration (optional):

    .. parsed-literal::

        # :command:`mv /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf.bak`

    .. note::

        On Debian the pool configuration folder is located here:
        ``/etc/php5/fpm/pool.d/``

#.  Create the PHP FPM Pools [#fpm_pools]_:

    .. parsed-literal::

        # :command:`cat > /etc/php-fpm.d/kolab.example.org_chwala.conf` << EOF
        [kolab.example.org_chwala]
        user = apache
        group = apache
        listen = /var/run/php-fpm/kolab.example.org_chwala.sock
        pm = dynamic
        pm.max_children = 40
        pm.start_servers = 15
        pm.min_spare_servers = 10
        pm.max_spare_servers = 20
        chdir = /
        php_value[upload_max_filesize] = 30M
        php_value[post_max_size] = 30M
        EOF
        # :command:`cat > /etc/php-fpm.d/kolab.example.org_iRony.conf` << EOF
        [kolab.example.org_iRony]
        user = apache
        group = apache
        listen = /var/run/php-fpm/kolab.example.org_iRony.sock
        pm = dynamic
        pm.max_children = 40
        pm.start_servers = 15
        pm.min_spare_servers = 10
        pm.max_spare_servers = 20
        chdir = /
        php_value[upload_max_filesize] = 30M
        php_value[post_max_size] = 30M
        EOF
        # :command:`cat > /etc/php-fpm.d/kolab.example.org_kolab-freebusy.conf` << EOF
        [kolab.example.org_kolab-freebusy]
        user = apache
        group = apache
        listen = /var/run/php-fpm/kolab.example.org_kolab-freebusy.sock
        pm = dynamic
        pm.max_children = 40
        pm.start_servers = 15
        pm.min_spare_servers = 10
        pm.max_spare_servers = 20
        chdir = /
        EOF
        # :command:`cat > /etc/php-fpm.d/kolab.example.org_kolab-syncroton.conf` << EOF
        [kolab.example.org_kolab-syncroton]
        user = apache
        group = apache
        listen = /var/run/php-fpm/kolab.example.org_kolab-syncroton.sock
        pm = dynamic
        pm.max_children = 40
        pm.start_servers = 15
        pm.min_spare_servers = 10
        pm.max_spare_servers = 20
        chdir = /
        php_flag[suhosin.session.encrypt] = Off
        EOF
        # :command:`cat > /etc/php-fpm.d/kolab.example.org_kolab-webadmin.conf` << EOF
        [kolab.example.org_kolab-webadmin]
        user = apache
        group = apache
        listen = /var/run/php-fpm/kolab.example.org_kolab-webadmin.sock
        pm = dynamic
        pm.max_children = 40
        pm.start_servers = 15
        pm.min_spare_servers = 10
        pm.max_spare_servers = 20
        chdir = /
        EOF
        # :command:`cat > /etc/php-fpm.d/kolab.example.org_roundcubemail.conf` << EOF
        [roundcubemail]
        user = apache
        group = apache
        listen = /var/run/php-fpm/kolab.example.org_roundcubemail.sock
        pm = dynamic
        pm.max_children = 40
        pm.start_servers = 15
        pm.min_spare_servers = 10
        pm.max_spare_servers = 20
        chdir = /
        # Derived from .htaccess of roundcube
        php_flag[display_errors] = Off
        php_flag[log_errors] = On

        php_value[upload_max_filesize] = 30M
        php_value[post_max_size] = 30M

        php_flag[zlib.output_compression] = Off
        php_flag[magic_quotes_gpc] = Off
        php_flag[magic_quotes_runtime] = Off
        php_flag[zend.ze1_compatibility_mode] = Off
        php_flag[suhosin.session.encrypt] = Off

        php_flag[session.auto_start] = Off
        php_value[session.gc_maxlifetime] = 21600
        php_value[session.gc_divisor] = 500
        php_value[session.gc_probability] = 1

        # http://bugs.php.net/bug.php?id=30766
        php_value[mbstring.func_overload] = 0
        EOF

    .. note::

        On Debian the pool configuration folder is located here:
        ``/etc/php5/fpm/pool.d/``

        Also there's no explizit folder for php5-fpm socket folders. This is
        how you can take of it and make it reboot safe.

        Adjust the file: :file:`/etc/default/php5-fpm`

        .. parsed-literal::

            # create /var/run/php5-fpm for all sockets
            # could be deleted during boot
            test -e /var/run/php5-fpm || install -m 755 -o root -g root -d /var/run/php5-fpm

        Now you can adjust all your socket files to:

        .. parsed-literal::

            listen = /var/run/php5-fpm/kolab.example.org_<app>.sock

        Or fix the files above with this quick command:

        .. parsed-literal::

            # :command:`sed -i -e 's|/var/run/php-fpm/|/var/run/php5-fpm/|g' /etc/php5/fpm/pool.d/kolab*`

#.  Backup your nginx configuration

    .. parsed-literal::

        # :command:`cp /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak`

Single Domain Configuration
---------------------------

If you've only one domain, one ssl certificate or for whatever reason get all
the kolab services under one host/domainname this is your configuration. The
iRony service will provide all 3 dav services on a single endpoint. ActiveSync
devices can be pointed to the main url. They'll find them Microsoft Url
automatically.

+---------------------------+-----------------------------------------------+
| Application / Service     | URL                                           |
+===========================+===============================================+
| Roundcubemail             | ``https://kolab.example.org``                 |
+---------------------------+-----------------------------------------------+
| CardDAV, CalDAV, WebDAV   | ``https://kolab.example.org/iRony``           |
+---------------------------+-----------------------------------------------+
| FreeBusy                  | ``https://kolab.example.org/freebusy``        |
+---------------------------+-----------------------------------------------+
| Chwala API / WebUI        | ``https://kolab.example.org/chwala``          |
+---------------------------+-----------------------------------------------+
| Kolab Web Admin Panel     | ``https://kolab.example.org/kolab-webadmin``  |
+---------------------------+-----------------------------------------------+
| ActiveSync Host           | ``https://kolab.example.org``                 |
+---------------------------+-----------------------------------------------+

#.  Replace the contents of :file:`/etc/nginx/conf.d/default.conf`:

    .. parsed-literal::

        #
        # Force HTTP Redirect
        #
        server {
            listen 80 default_server;
            server_name _;
            server_name_in_redirect off;
            rewrite ^ https://$http_host$request_uri permanent; # enforce https redirect
        }

        #
        # Full Kolab Stack
        #
        server {
            listen 443 ssl default_server;
            server_name kolab.example.org;
            access_log /var/log/nginx/kolab.example.org-access_log;
            error_log /var/log/nginx/kolab.example.org-error_log;

            # enable ssl

            ssl on;
            ssl_certificate /etc/pki/tls/private/localhost.pem;
            ssl_certificate_key /etc/pki/tls/private/localhost.pem;

            # Start common Kolab config

            ##
            ## Chwala
            ##
            location /chwala {
                index index.php;
                alias /usr/share/chwala/public_html;

                client_max_body_size 30M; # set maximum upload size

                # enable php
                location ~ \.php$ {
                    include fastcgi_params;
                    fastcgi_param HTTPS on;
                    fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_chwala.sock;
                    fastcgi_param SCRIPT_FILENAME $request_filename;
                    # Without this, PHPSESSION is replaced by webadmin-api X-Session-Token
                    fastcgi_param PHP_VALUE "session.auto_start=0
                        session.use_cookies=0";
                    fastcgi_pass_header X-Session-Token;
                }
            }

            ##
            ## iRony
            ##
            location /iRony {
                alias  /usr/share/iRony/public_html/index.php;

                client_max_body_size 30M; # set maximum upload size

                # If Nginx was built with http_dav_module:
                dav_methods  PUT DELETE MKCOL COPY MOVE;
                # Required Nginx to be built with nginx-dav-ext-module:
                # dav_ext_methods PROPFIND OPTIONS;

                include fastcgi_params;
                # fastcgi_param DAVBROWSER 1;
                fastcgi_param HTTPS on;
                fastcgi_index index.php;
                fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_iRony.sock;
                fastcgi_param SCRIPT_FILENAME $request_filename;
            }
            location ~* /.well-known/(cal|card)dav {
                rewrite ^ /iRony/ permanent;
            }

            ##
            ## Kolab Webclient
            ##
            location / {
                index index.php;
                root /usr/share/roundcubemail/public_html;

                # support for csrf token
                rewrite "^/[a-zA-Z0-9]{16}/(.*)" /$1 break;

                # maximum upload size for mail attachments
                client_max_body_size 30M;

                # enable php
                location ~ \.php$ {
                    include fastcgi_params;
                    fastcgi_param HTTPS on;
                    fastcgi_split_path_info ^(.+\.php)(/.*)$;
                    fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_roundcubemail.sock;
                    fastcgi_param SCRIPT_FILENAME $request_filename;
                }
            }

            ##
            ## Kolab Web Administration Panel (WAP) and API
            ##
            location /kolab-webadmin {
                index index.php;
                alias /usr/share/kolab-webadmin/public_html;
                try_files $uri $uri/ @kolab-wapapi;

                # enable php
                location ~ \.php$ {
                    include fastcgi_params;
                    fastcgi_param HTTPS on;
                    fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_kolab-webadmin.sock;
                    fastcgi_param SCRIPT_FILENAME $request_filename;
                    # Without this, PHPSESSION is replaced by webadmin-api X-Session-Token
                    fastcgi_param PHP_VALUE "session.auto_start=0
                        session.use_cookies=0";
                    fastcgi_pass_header X-Session-Token;
                }
            }
            # kolab-webadmin api
            location @kolab-wapapi {
                rewrite ^/kolab-webadmin/api/([^\.]*)\.([^\.]*)$ /kolab-webadmin/api/index.php?service=$1&method=$2;
            }

            ##
            ## Kolab syncroton ActiveSync
            ##
            location /Microsoft-Server-ActiveSync {
                alias  /usr/share/kolab-syncroton/index.php;

                client_max_body_size 30M; # maximum upload size for mail attachments

                include fastcgi_params;
                fastcgi_param HTTPS on;
                fastcgi_read_timeout 1200;
                fastcgi_index index.php;
                fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_kolab-syncroton.sock;
                fastcgi_param SCRIPT_FILENAME /usr/share/kolab-syncroton/index.php;
            }

            ##
            ## Kolab Free/Busy
            ##
            location /freebusy {
                alias  /usr/share/kolab-freebusy/public_html/index.php;

                include fastcgi_params;
                fastcgi_param HTTPS on;
                fastcgi_index index.php;
                fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_kolab-freebusy.sock;
                fastcgi_param SCRIPT_FILENAME /usr/share/kolab-freebusy/public_html/index.php;
            }
            # End common Kolab config
        }

    .. note::

        On Debian you can use the site configuration found at

        *   ``/etc/nginx/sites-available/``
        *   ``/etc/nginx/sites-enabled/``

#.  Adjust your kolab webadmin api url in the :file:`/etc/kolab/kolab.conf`
    configuration, otherwise webadmin or commandline tools will not work.

    .. parsed-literal::

        [kolab_wap]
        api_url = https://kolab.example.org/kolab-webadmin/api


Multi Subdomain Configuration
-----------------------------

Sometimes it's nice to create seperate host/domainnames for every service that
kolab offers. You can limit iRony to only provide a single dav-service on each
url endpoint. The Chwala API should be located on the webmail domain to not
create any cross-domain api call problems.

mtch the default configuration. If you like change your config
files you also move those to their url. But usually people don't often need
direct access to this url.

.. note::

    It helps to have a wildcard ssl certificate or a certificate that
    includes all needed hostnames as *SubjectAltNames*.

**URL Scheme**

+---------------------------+-----------------------------------------------+
| Application / Service     | URL                                           |
+===========================+===============================================+
| Roundcubemail             | ``https://webmail.example.org``               |
+---------------------------+-----------------------------------------------+
| CardDAV                   | ``https://carddav.example.org``               |
+---------------------------+-----------------------------------------------+
| CalDAV                    | ``https://caldav.example.org``                |
+---------------------------+-----------------------------------------------+
| WebDAV                    | ``https://webdav.example.org``                |
+---------------------------+-----------------------------------------------+
| FreeBusy                  | ``https://freebusy.example.org``              |
+---------------------------+-----------------------------------------------+
| Chwala API / WebUI        | ``https://webmail.example.org/chwala``        |
+---------------------------+-----------------------------------------------+
| Kolab Web Admin Panel     | ``https://kolab.example.org``                 |
+---------------------------+-----------------------------------------------+
| ActiveSync Host           | ``https://activesync.example.org``            |
+---------------------------+-----------------------------------------------+

You can also let the users use the serparte host/domain names for the non-web
services.

*   ``imap.example.org``
*   ``smtp.example.org``
*   etc.

But this all depends on you and your communication with your end users.

#.  Replace the contents of :file:`/etc/nginx/conf.d/default.conf`:

    .. parsed-literal::

        #
        # Force HTTP Redirect
        #
        server {
            listen 80 default_server;
            server_name _;
            server_name_in_redirect off;
            rewrite ^ https://$http_host$request_uri permanent; # enforce https redirect
        }

        #
        # Webmail + Chwala + Freebusy
        #
        server {
            listen 443 ssl default_server;
            server_name webmail.example.org;
            access_log /var/log/nginx/webmail.example.org-access_log;
            error_log /var/log/nginx/webmail.example.org-error_log;

            # enable ssl

            ssl on;
            ssl_certificate /etc/pki/tls/private/localhost.pem;
            ssl_certificate_key /etc/pki/tls/private/localhost.pem;

            # Start common Kolab config

            ##
            ## Chwala
            ##
            location /chwala {
                index index.php;
                alias /usr/share/chwala/public_html;

                client_max_body_size 30M; # set maximum upload size

                # enable php
                location ~ \.php$ {
                    include fastcgi_params;
                    fastcgi_param HTTPS on;
                    fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_chwala.sock;
                    fastcgi_param SCRIPT_FILENAME $request_filename;
                    # Without this, PHPSESSION is replaced by webadmin-api X-Session-Token
                    fastcgi_param PHP_VALUE "session.auto_start=0
                        session.use_cookies=0";
                    fastcgi_pass_header X-Session-Token;
                }
            }

            ##
            ## Kolab Webclient
            ##
            index index.php;
            root /usr/share/roundcubemail/public_html;

            # support for csrf token
            rewrite "^/[a-zA-Z0-9]{16}/(.*)" /$1 break;

            # maximum upload size for mail attachments
            client_max_body_size 30M;

            # enable php
            location ~ \.php$ {
                include fastcgi_params;
                fastcgi_param HTTPS on;
                fastcgi_split_path_info ^(.+\.php)(/.*)$;
                fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_roundcubemail.sock;
                fastcgi_param SCRIPT_FILENAME $request_filename;
            }
        }

        #
        # CardDAV
        #
        server {
            listen 443 ssl;
            server_name carddav.example.org;
            access_log /var/log/nginx/carddav.example.org-access_log;
            error_log /var/log/nginx/carddav.example.org-error_log;

            # enable ssl

            ssl on;
            ssl_certificate /etc/pki/tls/private/localhost.pem;
            ssl_certificate_key /etc/pki/tls/private/localhost.pem;

            # Start common Kolab config

            ##
            ## DAV Discovery redirect
            ##
            location ~* /.well-known/carddav {
                rewrite ^ / permanent;
            }

            ##
            ## iRony
            ##
            root  /usr/share/iRony/public_html;
            index index.php;
            try_files $uri $uri/ /index.php?$args;

            client_max_body_size 30M; # set maximum upload size

            # If Nginx was built with http_dav_module:
            dav_methods  PUT DELETE MKCOL COPY MOVE;
            # Required Nginx to be built with nginx-dav-ext-module:
            # dav_ext_methods PROPFIND OPTIONS;

            location ~ \.php$ {
                include fastcgi_params;
                fastcgi_param CARDDAV 1;
                # fastcgi_param DAVBROWSER 1;

                fastcgi_param HTTPS on;
                fastcgi_index index.php;
                fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_iRony.sock;
                fastcgi_param SCRIPT_FILENAME $request_filename;
            }
        }

        #
        # CalDAV
        #
        server {
            listen 443 ssl;
            server_name caldav.example.org;
            access_log /var/log/nginx/caldav.example.org-access_log;
            error_log /var/log/nginx/caldav.example.org-error_log;

            # enable ssl

            ssl on;
            ssl_certificate /etc/pki/tls/private/localhost.pem;
            ssl_certificate_key /etc/pki/tls/private/localhost.pem;

            # Start common Kolab config

            ##
            ## DAV Discovery redirect
            ##
            location ~* /.well-known/caldav {
                rewrite ^ / permanent;
            }

            ##
            ## iRony
            ##
            root  /usr/share/iRony/public_html;
            index index.php;
            try_files $uri $uri/ /index.php?$args;

            client_max_body_size 30M; # set maximum upload size

            # If Nginx was built with http_dav_module:
            dav_methods  PUT DELETE MKCOL COPY MOVE;
            # Required Nginx to be built with nginx-dav-ext-module:
            # dav_ext_methods PROPFIND OPTIONS;

            location ~ \.php$ {
                include fastcgi_params;
                fastcgi_param CALDAV 1;
                # fastcgi_param DAVBROWSER 1;

                fastcgi_param HTTPS on;
                fastcgi_index index.php;
                fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_iRony.sock;
                fastcgi_param SCRIPT_FILENAME $request_filename;
            }
        }

        #
        # WebDAV
        #
        server {
            listen 443 ssl;
            server_name webadv.example.org;
            access_log /var/log/nginx/webadv.example.org-access_log;
            error_log /var/log/nginx/webadv.example.org-error_log;

            # enable ssl

            ssl on;
            ssl_certificate /etc/pki/tls/private/localhost.pem;
            ssl_certificate_key /etc/pki/tls/private/localhost.pem;

            # Start common Kolab config

            ##
            ## iRony
            ##
            root  /usr/share/iRony/public_html;
            index index.php;
            try_files $uri $uri/ /index.php?$args;

            client_max_body_size 30M; # set maximum upload size

            # If Nginx was built with http_dav_module:
            dav_methods  PUT DELETE MKCOL COPY MOVE;
            # Required Nginx to be built with nginx-dav-ext-module:
            # dav_ext_methods PROPFIND OPTIONS;

            location ~ \.php$ {
                include fastcgi_params;
                fastcgi_param WEBDAV 1;
                # fastcgi_param DAVBROWSER 1;

                fastcgi_param HTTPS on;
                fastcgi_index index.php;
                fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_iRony.sock;
                fastcgi_param SCRIPT_FILENAME $request_filename;
            }
        }

        #
        # Kolab Web Admin Panel + API
        #
        server {
            listen 443 ssl;
            server_name kolab.example.org;

            access_log /var/log/nginx/kolab.example.org-access_log;
            error_log /var/log/nginx/kolab.example.org-error_log;

            # enable ssl

            ssl on;
            ssl_certificate /etc/pki/tls/private/localhost.pem;
            ssl_certificate_key /etc/pki/tls/private/localhost.pem;

            # Start common Kolab config

            ##
            ## Kolab Web Administration Panel (WAP) and API
            ##
            root /usr/share/kolab-webadmin/public_html;
            index index.php;
            try_files $uri $uri/ @kolab-wapapi;

            # enable php
            location ~ \.php$ {
                include fastcgi_params;
                fastcgi_param HTTPS on;
                fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_kolab-webadmin.sock;
                fastcgi_param SCRIPT_FILENAME $request_filename;
                # Without this, PHPSESSION is replaced by webadmin-api X-Session-Token
                fastcgi_param PHP_VALUE "session.auto_start=0
                    session.use_cookies=0";
                fastcgi_pass_header X-Session-Token;
            }

            # kolab-webadmin api
            location @kolab-wapapi {
                rewrite ^/api/([^\.]*)\.([^\.]*)$ /api/index.php?service=$1&method=$2;
            }
        }

        #
        # Syncroton / ActiveSync
        #
        server {
            listen 443 ssl;
            server_name activesync.example.org;

            access_log /var/log/nginx/kolab.example.org-access_log;
            error_log /var/log/nginx/kolab.example.org-error_log;

            # enable ssl

            ssl on;
            ssl_certificate /etc/pki/tls/private/localhost.pem;
            ssl_certificate_key /etc/pki/tls/private/localhost.pem;

            ##
            ## Kolab syncroton ActiveSync
            ##
            location /Microsoft-Server-ActiveSync {
                alias  /usr/share/kolab-syncroton/index.php;

                client_max_body_size 30M; # maximum upload size for mail attachments

                include fastcgi_params;
                fastcgi_param HTTPS on;
                fastcgi_read_timeout 1200;
                fastcgi_index index.php;
                fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_kolab-syncroton.sock;
                fastcgi_param SCRIPT_FILENAME /usr/share/kolab-syncroton/index.php;
            }

            ##
            ## Return to Webmail any other invalid request
            ##
            location / {
                rewrite ^ https://webmail.example.org permanent;
            }
        }

        #
        # FreeBusy
        #
        server {
            listen 443 ssl;
            server_name freebusy.example.org;

            access_log /var/log/nginx/freebusy.example.org-access_log;
            error_log /var/log/nginx/freebusy.example.org-error_log;

            # enable ssl

            ssl on;
            ssl_certificate /etc/pki/tls/private/localhost.pem;
            ssl_certificate_key /etc/pki/tls/private/localhost.pem;

            # Start common Kolab config

            ##
            ## Kolab Free/Busy
            ##
            root  /usr/share/kolab-freebusy/public_html/index.php;
            index index.php;
            try_files $uri $uri/ /index.php?$args;

            location ~ \.php$ {
                include fastcgi_params;
                fastcgi_param HTTPS on;
                fastcgi_index index.php;
                fastcgi_pass unix:/var/run/php-fpm/kolab.example.org_kolab-freebusy.sock;
                fastcgi_param SCRIPT_FILENAME /usr/share/kolab-freebusy/public_html/index.php;
            }
        }

    .. note::

        On Debian you can use the site configuration found at

        *   ``/etc/nginx/sites-available/``
        *   ``/etc/nginx/sites-enabled/``


#.  Adjust your kolab webadmin api url in the :file:`/etc/kolab/kolab.conf`
    configuration, otherwise webadmin or commandline tools will not work.

    .. parsed-literal::

        [kolab_wap]
        api_url = https://kolab.example.org/api

#.  Since Freebusy has moved to a different location we've to adjust the api
    endpoint in :file:`/etc/roundcubemail/libkolab.inc.php`

    .. parsed-literal::

        $config['kolab_freebusy_server'] = 'https://freebusy.example.org';

#.  iRony basedir has to be adjusted in :file:`/etc/iRony/dav.inc.php`

    .. parsed-literal::

        $config['base_uri'] = '/';

#.  We can now set the absolute urls for the CalDAV/CardDAV integration

    :file:`/etc/roundcubemail/calendar.inc.php`

    .. parsed-literal::

        $config['calendar_caldav_url'] = "https://caldav.example.org/calendars/%u/%i";

    :file:`/etc/roundcubemail/kolab_addressbook.inc.php`

    .. parsed-literal::

        $config['kolab_addressbook_carddav_url'] = "https://carddav.example.org/addressbooks/%u/%i";

Finalize / Common
-----------------

#.  Since we run Roundcube in the base directory ``/`` of the server, we've to
    set the correct asset path

    .. parsed-literal::

        $config['assets_path'] = '/assets/';

#.  For configurations that use SSL, make sure to work around a known issue in
    PHP pear module HTTP_Request2, and include in
    :file:`/etc/roundcubemail/config.inc.php`:

    .. parsed-literal::

        $config['ssl_verify_host'] = false;
        $config['ssl_verify_peer'] = false;

#.  Start the **php-fpm** service and configure the service to start on boot:

    .. parsed-literal::

        # :command:`service php-fpm start`
        # :command:`chkconfig php-fpm on`

#.  Start the **nginx** service and configure the service to start on boot:

    .. parsed-literal::

        # :command:`service nginx start`
        # :command:`chkconfig nginx on`

Tips, tweaks and optimizations
==============================

Tweaking ssl cipher settings
----------------------------

To ensure Perfect Forward Secrecy is enabled when possible

#. Add the following into **http** section of :file:`/etc/nginx/nginx.conf`:

    .. parsed-literal::

        # These cipher settings should ensure Perfect Forward Secrecy is
        # enabled when possible.
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_prefer_server_ciphers on;

        ssl_ciphers "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM
        EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384
        EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA RC4 !aNULL
        !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS";

        ssl_session_cache shared:SSL:10m;

#.  Restart the **nginx** service:

    .. parsed-literal::

        # :command:`service nginx restart`

Adding open file cache to nginx
-------------------------------

Open file cache will make nginx cache static files, that were accessed
``open_file_cache_min_uses`` times.

#.  Add the following into **http** section of :file:`/etc/nginx/nginx.conf`:

    .. parsed-literal::

       open_file_cache max=16384 inactive=5m;
       open_file_cache_valid 90s;
       open_file_cache_min_uses 2;
       open_file_cache_errors on;

#.  Restart the **nginx** service:

    .. parsed-literal::

        # :command:`service nginx restart`

Adding fastcgi_cache to nginx
-----------------------------

#.  Create and set ownership on the following directories:

    *   :file:`/var/lib/nginx/fastcgi/`

    .. parsed-literal::

        # :command:`mkdir -p /var/lib/nginx/fastcgi/`
        # :command:`chown -R nginx:nginx /var/lib/nginx/fastcgi/`
        # :command:`chmod -R 700 /var/lib/nginx/fastcgi/`

#.  Add the following into **http** section of :file:`/etc/nginx/nginx.conf`:

    .. parsed-literal::

        fastcgi_cache_key "$scheme$request_method$host$request_uri";
        fastcgi_cache_use_stale error timeout invalid_header http_500;
        fastcgi_cache_valid 200 302 304 10m;
        fastcgi_cache_valid 301 1h;
        fastcgi_cache_min_uses 2;

#.  Add the following outside **server** sections of :file:`/etc/nginx/conf.d/default.conf`:

    .. parsed-literal::

        fastcgi_cache_path /var/lib/nginx/fastcgi/ levels=1:2 keys_zone=key-zone-name:16m max_size=256m inactive=1d;

#.  Add the following into **ssl server** section of :file:`/etc/nginx/conf.d/default.conf`:

   .. parsed-literal::

        fastcgi_cache key-zone-name;

#.  Restart the **nginx** service:

    .. parsed-literal::

        # :command:`service nginx restart`

Browse CalDAV/CardDAV/WebDAV with your browser
----------------------------------------------

In the default configuration iRony only supports the default DAV commands. If
you want to use GET to browse through your DAV instance to make sure everything
is working, just uncomment the ``fastcgi_param DAVBROWSER 1`` option in the php
section and point your browser to it.

Splitting Kolab nginx config for use with multi-domain
------------------------------------------------------

You can put common Kolab config into separate file and include it into
server configurations, if you need different settings for
different domains in a multi-domain setup (eg. different ssl
certificates).

This way you wount have to keep up to date lines common to all Kolab
servers in multitude of server configurations.

#.  Common Kolab config is between lines:

    .. parsed-literal::

        # Start common Kolab config
        ...
        # End common Kolab config

    move it into separate file (eg. :file:`/etc/nginx/kolab_common.conf`)

#.  Use ``include`` directive to include the new file into configuration:

    .. parsed-literal::

        # Start common Kolab config
        include /etc/nginx/kolab_common.conf
        # End common Kolab config

   So your server configuration file can look like similar to this:

    .. parsed-literal::

        fastcgi_cache_path /var/lib/nginx/fastcgi/ levels=1:2 keys_zone=kolab1-key-zone-name:16m max_size=256m inactive=1d;

        server {
            listen 80 default_server;
            server_name kolab1.example.org;
            rewrite ^ https://$http_hosts$request_uri permanent; # enforce https redirect
        }

        server {
            listen 443 ssl;
            server_name kolab1.example.org;

            access_log /var/log/nginx/kolab1.example.org-access_log;
            error_log /var/log/nginx/kolab1.example.org-error_log;

            ssl on;
            ssl_certificate /etc/pki/tls/certs/kolab1.example.org.pem;
            ssl_certificate_key /etc/pki/tls/certs/kolab1.example.org.pem;

            fastcgi_cache kolab1-key-zone-name;

            # Start common Kolab config
            include /etc/nginx/kolab_common.conf
            # End common Kolab config
        }


.. rubric:: Footnotes

.. [#fpm_pools] Values for fpm servers are taken from a
           moderately loaded virtual server with 4x3.5GHz CPU
           and 4GB RAM, feel free to adjust them according to
           your setup.
