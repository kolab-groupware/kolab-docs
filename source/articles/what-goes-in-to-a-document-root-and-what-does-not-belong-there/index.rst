.. _article-what-goes-in-to-a-documentroot-and-what-does-not-belong-there:

===============================================================
What Goes in to a Document Root and What Does Not Belong There?
===============================================================

Security is a big issue and in this article, we explain how to prevent
accidental disclosure of program code and system settings for web
applications.

A document root is normally the directory hierarchy that is published on
the web. This is to say, that everything in the document root is
published, and is therefore considered to be public -- unless of course
it is locked down by other means, such as password protection.

Imagine for example a public website ``www.example.org``, running
Drupal.

Drupal is one of many web applications that comes in a tarball you
extract the contents of, and you typically dump those contents inside
the directory hierarchy of a document root. As such, Drupal is a good
**example** to get started with, examining what exactly is put in to the
document root (and would therefore be considered "published"), what
information is in these files, who has access to them, why this could be
considered bad, how to protect the deployment of such an application,
and how to develop web applications in such a way that the level of
protection on a server-side configuration level may not need to be as
complex.

Document Root Content Review (for a Drupal Site)
================================================

Imagine, if you will, the document root is :file:`/var/www/html/`, and
you have put Drupal in :file:`/var/www/html/drupal-$x.$y/`.

.. NOTE::

    We assume a default configuration of one's webserver, with Apache's
    *httpd* version series *2.4*, that comes with certain defaults such
    as ``AllowOverride None``, preventing any ``.htaccess`` file from
    modifying access levels and other settings.

What you intend to publish may be limited to:

    *   :file:`drupal-$x.$y/favicon.ico`
    *   :file:`drupal-$x.$y/index.php`
    *   :file:`drupal-$x.$y/misc/*.css`
    *   :file:`drupal-$x.$y/misc/*.gif`
    *   :file:`drupal-$x.$y/misc/*.ico`
    *   :file:`drupal-$x.$y/misc/*.js`
    *   :file:`drupal-$x.$y/misc/*.png`
    *   :file:`drupal-$x.$y/misc/farbtastic/`
    *   :file:`drupal-$x.$y/misc/ui/`
    *   :file:`drupal-$x.$y/modules/` (assets only)
    *   :file:`drupal-$x.$y/xmlrpc.php`
    *   :file:`drupal-$x.$y/themes/garland/*.css`
    *   :file:`drupal-$x.$y/themes/garland/color/*.css`
    *   :file:`drupal-$x.$y/themes/garland/color/*.png`
    *   :file:`drupal-$x.$y/sites/all/modules/` (assets only)
    *   :file:`drupal-$x.$y/sites/default/files/`
    *   :file:`drupal-$x.$y/sites/default/modules/` (assets only)

But what is actually considered "published" -- since it is in the
document root, includes (among others), the following files:

**drupal-$x.$y/modules/\*/\*.info**

    Part of the Drupal core modules, these files contain the exact
    version number of Drupal modules, usually the same version number as
    the Drupal core.

    Should an attack vector exist against a particular Drupal version,
    which is not an uncommon occurence, then disclosing the version
    number aids attackers in narrowing their attempts to include only
    the ones the attacker considers valid.

**drupal-$x.$y/modules/\*/\*.inc**,

**drupal-$x.$y/modules/\*/\*.module**

    Contain the program logic of a module, and would be served in plain-
    text unless access is specifically prevented.

    Example: www.example.org/modules/openid/openid.info

        .. parsed-literal::

            name = OpenID
            description = "Allows users to log into your site using OpenID."
            version = VERSION
            package = Core
            core = 7.x
            files[] = openid.test

            ; Information added by Drupal.org packaging script on 2014-11-19
            version = "7.34"
            project = "drupal"
            datestamp = "1416429488"

In addition to the aforementioned files that are usually part of stock
versions of Drupal core, modules and themes, most of which are likely
publicly available elsewhere (not on your site), you may also load
custom modules and themes, and/or patch certain aspects of the stock
versions to make something work for your deployment. You will have even
less desire to unintentionally publish this custom code.

Furthermore, at a lower risk of disclosure but with a greater risk of
compromising the site if not the server, Drupal by default retains the
site's settings inside the document root -- at
:file:`/var/www/html/drupal-$x.$y/sites/default/settings.php` in our
example.

This ``.php`` file is normally handled by the PHP module loaded in to
the webserver, but if it is not -- through genuine misconfiguration of
the web server software -- your database address, name and access
credentials would be out in the open. Even if the database is not
publicly accessible, the site administrator may have been configured
with the same passphrase, and the settings disclose the database
technology used -- such that the use of SQLite could be exploited in a
DoS attack.

How to Protect a Document Root?
===============================

Under the working assumption that everything in a document root is
published, and with Apache's httpd 2.4 defaults including
``AllowOverride None``, your means of protection are limited to
server-side configuration, most commonly limited to privileged system
accounts (such as the ``root`` user).

.. NOTE::

    Some web hosting technologies allow you to specify and tweak certain
    aspects of the web server configuration through an ``Include`` or an
    ``IncludeOptional`` statement that includes configuration from a
    location where you can write, and/or negate a default of
    ``AllowOverride None`` by specifying which aspects may be configured
    in a ``.htaccess`` file.

A common approach to preventing access to a set of files of which the
exact name, path or location is unknown, or under circumstances where
such list of files is dynamic, is to block everything by default and
create a whilelist for content that is to be published, rather than
block access to each known file individually.

An example whitelist configuration for a Drupal installation could look
as follows in the
:ref:`article-what-goes-in-to-a-document-root-and-what-does-not-belong-there-example-drupal-configuration`.

Kolab Groupware Software Components and DocumentRoots
=====================================================

