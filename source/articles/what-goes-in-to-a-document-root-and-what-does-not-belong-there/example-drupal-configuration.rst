.. _article-what-goes-in-to-a-document-root-and-what-does-not-belong-there-example-drupal-configuration:

Example Drupal Configuration
============================

.. parsed-literal::

    # Do not disclose in the HTTP headers, the fact we run Drupal
    # nor the fact we hit or missed a cache (or in fact use server-side
    # caching at all).
    <IfModule mod_headers.c>
        Header unset X-Drupal-Cache
        Header unset X-Generator
    </IfModule>

    <Directory "/var/www/html/drupal-$x.$y/">
        # Do not allow anything Drupal to override what we specify here.
        #
        # This includes locations the apache user account (and therefore
        # Drupal itself) can write to, such as sites/default/files/.
        #
        # We do not want Drupal to be able to put a .htaccess in such
        # locations.
        AllowOverride None

        # Grant access, but use the RewriteEngine to block everything we
        # don't approve of.
        #
        Require all granted

        # Don't show directory listings for URLs which map to a
        # directory.
        Options -Indexes

        # Follow symbolic links in this directory.
        Options +FollowSymLinks

        # Make Drupal handle any 403 and 404 errors.
        ErrorDocument 403 /index.php
        ErrorDocument 404 /index.php

        # Set the default handler.
        DirectoryIndex index.php index.html index.htm

        # Override PHP settings that cannot be changed at runtime. See
        # sites/default/default.settings.php and
        # drupal_environment_initialize() in includes/bootstrap.inc for
        # settings that can be changed at runtime.

        # PHP 5, Apache 1 and 2.
        <IfModule mod_php5.c>
            php_flag magic_quotes_gpc                 off
            php_flag magic_quotes_sybase              off
            php_flag register_globals                 off
            php_flag session.auto_start               off
            php_value mbstring.http_input             pass
            php_value mbstring.http_output            pass
            php_flag mbstring.encoding_translation    off
        </IfModule>

        # Requires mod_expires to be enabled.
        #
        <IfModule mod_expires.c>
            # Enable expirations.
            #
            ExpiresActive On

            # Cache all files for 2 weeks after access (A).
            ExpiresDefault A1209600

            <FilesMatch \.php$>
                ExpiresActive Off
            </FilesMatch>

        </IfModule>

        <IfModule mod_rewrite.c>
            RewriteEngine on

            # Reject everything that is not pre-approved.
            #
            RewriteCond %{ENV:REDIRECT_STATUS} ^$
            RewriteCond %{REQUEST_FILENAME} -f
            RewriteCond %{REQUEST_URI} !^(((/?).*)*)\.(css|eot|gif|css\.gz|js\.gz|ico|jpeg|jpg|js|map|pdf|png|svg|ttf|woff)$
            RewriteCond %{REQUEST_URI} !^/(index|xmlrpc).php
            RewriteCond %{REQUEST_URI} !^/$
            RewriteRule ^ - [F,L]

            # Pass all requests not referring directly to files in the filesystem to
            # index.php. Clean URLs are handled in drupal_environment_initialize().
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteCond %{REQUEST_FILENAME} !-d
            RewriteCond %{REQUEST_URI} !=/favicon.ico
            RewriteRule ^ /index.php [L]

            # Rules to correctly serve gzip compressed CSS and JS files.
            # Requires both mod_rewrite and mod_headers to be enabled.
            <IfModule mod_headers.c>
                # Serve gzip compressed CSS files if they exist and the client accepts gzip.
                RewriteCond %{HTTP:Accept-encoding} gzip
                RewriteCond %{REQUEST_FILENAME}\.gz -s
                RewriteRule ^(.*)\.css $1\.css\.gz [QSA]

                # Serve gzip compressed JS files if they exist and the client accepts gzip.
                RewriteCond %{HTTP:Accept-encoding} gzip
                RewriteCond %{REQUEST_FILENAME}\.gz -s
                RewriteRule ^(.*)\.js $1\.js\.gz [QSA]

                # Serve correct content types, and prevent mod_deflate double gzip.
                RewriteRule \.css\.gz$ - [T=text/css,E=no-gzip:1]
                RewriteRule \.js\.gz$ - [T=text/javascript,E=no-gzip:1]

                <FilesMatch "(\.js\.gz|\.css\.gz)$">
                    # Serve correct encoding type.
                    Header set Content-Encoding gzip
                    # Force proxies to cache gzipped & non-gzipped css/js files separately.
                    Header append Vary Accept-Encoding
                </FilesMatch>
            </IfModule>
        </IfModule>
    </Directory>

