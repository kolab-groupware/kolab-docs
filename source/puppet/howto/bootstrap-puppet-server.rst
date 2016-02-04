=========================================
HOWTO: Bootstrap the Puppet Master Server
=========================================

This HOWTO installs Puppet version 3.7.1 (at the time of this writing)
on to a single vanilla Enterprise Linux 6 system.

.. NOTE::

    The packages referred to in this document are available in the
    Puppet add-on channel to Kolab Enterprise 14.

If you do not have any Kolab Enterprise 14 configuration on the system
yet, please see the guide for
:ref:`installation-guide-rhel-6-enterprise-14` for the steps involved.

.. IMPORTANT::

    Bootstrapping the Puppet master server is the hardest thing to do in
    relation to running Puppet for your environments.

    This HOWTO lists a large number of steps that need to be executed
    manually, but only need to be executed once.

Configure the System FQDN and Service DNS Entry
===============================================

Make sure that the system's FQDN is a sustainable value. We recommend
using ``puppet$x.$domain``, for example ``puppet01.example.org``.

The digits are in there, so that node manifests can match the system's
common name against a node manifest for ``puppet\d+\.example\.org``.

The FQDN of the system has to resolve back to the actual system's
primary external interface's IP address.

To double-check whether this is the case, execute the following
commands:

.. parsed-literal::

    # :command:`python -c 'import socket; print socket.getfqdn();'`
    puppet01.example.org
    # :command:`dig +short puppet01.example.org`
    13.14.15.16
    # :command:`host 13.14.15.16`
    16.15.14.13.in-addr.arpa domain name pointer puppet01.example.org.

The service DNS entry is a default ``puppet.example.org``. Tinkering
with this is obviously allowed, but not recommended.

If you may end up with multiple Puppet master servers, make sure that
the ``puppet.example.org`` DNS entry is a (collection of) IN A resource
record(s), possibly pointing to service IP addresses rather than system
IP addresses.

Configure the Puppet Add-on YUM Repository
==========================================

At the time of this writing, there is not a so-called ``-release``
package for the add-on repository for Puppet.

Put the following YUM repository configuration in
:file:`/etc/yum.repos.d/kolab-14-extras-puppet.repo`:

.. include:: extras-puppet-repo.txt

Install and Configure the Puppet Master Server Software
=======================================================

Execute the following command to install the necessary software:

.. parsed-literal::

    # :command:`yum -y install git puppet-server redhat-lsb \\
        mod_passenger mod_ssl puppetdb puppet-dashboard mysql-server`

In case you have started from a base Enterprise Linux 6 installation,
which is not a bad idea at all, ensure the following packages are
up-to-date:

.. parsed-literal::

    # :command:`yum -y update apr apr-util mod_nss openssl`

Next, adjust :file:`/etc/puppet/puppet.conf` to include configuration
for the master, adding the following section:

.. include:: master-section-to-puppet-conf.txt

Run the following command once to generate the certificates necessary to
run the Puppet master server under the Apache HTTP server with Phusion
Passenger:

.. parsed-literal::

    # :command:`timeout 10s puppet master --verbose --no-daemonize`

At this point, executing :command:`httpd -t` should succeed without
errors or warnings.

The fileserver configuration needs adjusting, too:

.. parsed-literal::

    # :command:`cat > /etc/puppet/fileserver.conf << EOF`
    [private]
        path /var/lib/puppet/private/%d/
        allow \*

    [files]
        path /var/lib/puppet/files/%d/
        allow \*
    EOF

Next, create or adjust :file:`/etc/httpd/conf.d/puppet-server.conf` to
contain the following:

.. parsed-literal::

    # :command:`cat > /etc/httpd/conf.d/puppet-server.conf << EOF`
    Listen \*:8140

    <VirtualHost \*:8140>
        ServerAdmin sysadmin-main\@$(hostname -d)
        ServerName puppet.$(hostname -d)

        ErrorLog "\|/usr/sbin/rotatelogs -L /var/log/httpd/puppet.$(hostname -d)-error_log -f -l /var/log/httpd/puppet.$(hostname -d)-error_log.%Y-%m-%d 86400"
        CustomLog "\|/usr/sbin/rotatelogs -L /var/log/httpd/puppet.$(hostname -d)-access_log -f -l /var/log/httpd/puppet.$(hostname -d)-access_log.%Y-%m-%d 86400" combined
        CustomLog "\|/usr/sbin/rotatelogs -L /var/log/httpd/puppet.$(hostname -d)-ssl_log -f -l /var/log/httpd/puppet.$(hostname -d)-ssl_log.%Y-%m-%d 86400" "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \\"%r\\" %b"

        DocumentRoot /usr/share/puppet/rack/puppetmasterd/public/

        SSLEngine on
        SSLCipherSuite SSLv2:-LOW:-EXPORT:RC4+RSA
        SSLCertificateFile      /var/lib/puppet/ssl/certs/puppet.$(hostname -d).pem
        SSLCertificateKeyFile   /var/lib/puppet/ssl/private_keys/puppet.$(hostname -d).pem
        SSLCertificateChainFile /var/lib/puppet/ssl/ca/ca_crt.pem
        SSLCACertificateFile    /var/lib/puppet/ssl/ca/ca_crt.pem
        SSLCARevocationFile     /var/lib/puppet/ssl/ca/ca_crl.pem
        SSLCARevocationCheck    chain

        SSLVerifyClient optional
        SSLVerifyDepth  1
        SSLOptions +StdEnvVars

        # The following client headers allow the same configuration to work with Pound.
        RequestHeader set X-SSL-Subject %{SSL_CLIENT_S_DN}e
        RequestHeader set X-Client-DN %{SSL_CLIENT_S_DN}e
        RequestHeader set X-Client-Verify %{SSL_CLIENT_VERIFY}e

        <Directory /usr/share/puppet/rack/puppetmasterd/>
            Options None
            AllowOverride None
            <ifModule mod_authz_core.c>
                Require all granted
            </ifModule>
            <ifModule !mod_authz_core.c>
                Order Allow,Deny
                Allow from All
            </ifModule>
        </Directory>

    </VirtualHost>
    EOF

And restart the Apache HTTP server:

.. parsed-literal::

    # :command:`service httpd restart`

Create the aforementioned DocumentRoot:

.. parsed-literal::

    # :command:`mkdir -p /usr/share/puppet/rack/puppetmasterd/{public,tmp}`
    # :command:`cp /usr/share/puppet/ext/rack/config.ru \\
        /usr/share/puppet/rack/puppetmasterd/`
    # :command:`chown puppet:puppet /usr/share/puppet/rack/puppetmasterd/config.ru`

Initialize the Management Repositories
======================================

Initialize the central GIT repositories for the domain name space to
manage, on the Puppet master server:

.. parsed-literal::

    # :command:`mkdir -p /git/`
    # :command:`mkdir -p /git/$(hostname -d)`
    # :command:`cd /git/$(hostname -d)`
    # :command:`git --bare init --shared`
    # :command:`sed -i -e 's/master/development/g' HEAD`

    # :command:`mkdir -p /git/$(hostname -d)-sensitive`
    # :command:`cd /git/$(hostname -d)-sensitive`
    # :command:`git --bare init --shared`

To distinguish between permissions to each repository, optionally add
the necessary groups:

.. parsed-literal::

    # :command:`groupadd sysadmin-puppet`
    # :command:`groupadd sysadmin-main`
    # :command:`chown -R root:sysadmin-puppet /git/$(hostname -d)`
    # :command:`find /git/$(hostname -d) -type f -exec chmod g+w,o-r {} ;`
    # :command:`find /git/$(hostname -d) -type d -exec chmod g+ws,o-rx {} ;`

    # :command:`chown -R root:sysadmin-main /git/$(hostname -d)-sensitive`
    # :command:`find /git/$(hostname -d)-sensitive -type f -exec chmod g+w,o-r {} ;`
    # :command:`find /git/$(hostname -d)-sensitive -type d -exec chmod g+ws,o-rx {} ;`

And add users to said groups:

.. parsed-literal::

    # :command:`useradd john`
    # :command:`gpasswd -a john sysadmin-main`
    # :command:`gpasswd -a john sysadmin-puppet`

    # :command:`useradd jane`
    # :command:`gpasswd -a jane sysadmin-puppet`

.. seealso::

    *   :ref:`delegation-for-domain-manifests`
    *   :ref:`hook-the-puppet-master-server-up-to-ldap`

Provide Puppet with Something To Do
===================================

From a workstation (that is presumably in the same domain name space),
clone the (still empty) repositories:

.. parsed-literal::

    $ :command:`git clone ssh://puppet.$(hostname -d)/git/$(hostname -d)`
    $ :command:`git clone ssh://puppet.$(hostname -d)/git/$(hostname -d)-sensitive`

And provide the initial populus:

.. parsed-literal::

    $ :command:`cd $(hostname -d)`
    $ :command:`mkdir -p puppet/manifests/{classes,nodes,utils}`
    $ :command:`hostname=PUPPET_SERVER_HOSTNAME`
    $ :command:`cat > puppet/site.pp << EOF`
    # Get facts and give them a good, good name
    \\$os = \\$operatingsystem
    \\$server = "puppet.$(hostname -d)"

    case \\$os {
        "Fedora", "CentOS", "RedHat": {
            \\$osver = \\$lsbdistrelease
            \\$osmajorver = \\$lsbmajdistrelease
        }
        "Debian", "Ubuntu": {
            \\$osver = \\$lsbdistrelease
            \\$osmajorver = \\$lsbmajdistrelease
        }
        "SuSE": {
        }
        "openSuSE": {
        }
        "Darwin": {
            \\$osver = \\$operatingsystemrelease
        }
    }

    case \\$environment {
        nil: {
            \\$environment = "development"
        }
    }

    # Always include the puppet::client class
    include puppet::client

    node default {
    }
    EOF
    $ :command:`cat > puppet/puppetdb.conf << EOF`
    [main]
    server = $hostname
    port = 8081
    EOF
    $ :command:`cat > puppet/manifests/classes/$(echo $(hostname -d) | sed -e 's/\./_/g')_common.pp << EOF`
    class $(echo $(hostname -d) | sed -e 's/\./_/g')_common {
        include yum::standard

        yum::repository { [
                "kolab-14-release",
                "kolab-14-updates",
                "kolab-14-extras-puppet"
            ]:
            enable => true,
            gpgkey => true
        }

        yum::repository { [
                "kolab-14-updates-testing"
            ]:
            enable => \\$environment ? {
                    "production" => false,
                    default => true
                },
            gpgkey => true
        }

        yum::repository { [
                "kolab-14-development"
            ]:
            enable => \\$environment ? {
                    "development" => true,
                    default => false
                },
            gpgkey => true
        }
    }
    EOF
    $ :command:`cat > puppet/manifests/nodes/$(hostname -f).pp << EOF`
    node '$(hostname -f)' {
        include $(echo $(hostname -d) | sed -e 's/\./_/g')_common
        include puppet::server

        cron { "puppet-dashboard_reports:prune":
            command => "cd /usr/share/puppet-dashboard; rake RAILS_ENV=production reports:prune upto=28 unit=day >/dev/null 2>&1",
            hour => "\*/1",
            minute => "15"
        }

        # From git::server
        file { "/usr/local/bin/git_init_script":
            owner => "root",
            group => "root",
            mode => 750,
            source => [
                "puppet://\\\$server/private/\\\$environment/git/git_init_script",
                "puppet://\\\$server/modules/files/git/git_init_script",
                "puppet://\\\$server/modules/git/git_init_script"
            ]
        }

        git::clone { "$(hostname -d)-sensitive":
            localtree => "/var/lib/puppet/files/",
            source => "/git/$(hostname -d)-sensitive/",
            real_name => "$(hostname -d)"
        }

        git::repository { [
                "$(hostname -d)",
                "$(hostname -d)-sensitive"
            ]:
            localtree => "/git/",
            symbolic_link => false,
            shared => true,
            public => false,
            owner => "root",
            group => "root",
            description => "Kolab Systems Puppet"
        }

        puppet::server::domain::development { [
                "$(hostname -d)"
            ]:
            base_url => "/git/"
        }

        puppet::server::domain::testing { [
                "$(hostname -d)"
            ]:
            base_url => "/git/"
        }

        puppet::server::domain::production { [
                "$(hostname -d)"
            ]:
            base_url => "/git/"
        }

        puppet::server::module::development { [
                "git",
                "puppet",
                "webserver",
                "yum"
            ]:
            base_url => "git://git.kolab.org/~vanmeeuwen/puppet/"
        }

        puppet::server::module::testing { [
                "git",
                "puppet",
                "webserver",
                "yum"
            ]:
            base_url => "git://git.kolab.org/~vanmeeuwen/puppet/"
        }

        puppet::server::module::production { [
                "git",
                "puppet",
                "webserver",
                "yum"
            ]:
            base_url => "git://git.kolab.org/~vanmeeuwen/puppet/"
        }
    }
    EOF
    $ :command:`cat > puppet/manifests/utils/exec.pp << EOF`
    # Exec

    Exec {
        logoutput => on_failure,
        loglevel => info,
        path => [
            "/bin",
            "/usr/bin",
            "/usr/local/bin",
            "/sbin",
            "/usr/sbin",
            "/usr/local/sbin"
        ]
    }
    EOF
    $ :command:`cat > puppet/manifests/utils/file.pp << EOF`
    File {
        links => follow
    }
    EOF
    $ :command:`mkdir -p webserver/includes.d/`
    $ :command:`cat > webserver/includes.d/listen.conf.$(hostname -s) << EOF`
    Listen 80
    Listen 443
    Listen 3000
    Listen 8140
    EOF

Add the files to track, commit the changes and push it back out:

.. parsed-literal::

    $ :command:`git add .`
    $ :command:`git commit . -m "Initial commit"`
    $ :command:`git checkout -b development`
    $ :command:`git branch -D master`
    $ :command:`git push origin development`
    $ :command:`git push origin development:testing`
    $ :command:`git push origin development:production`

Next, to setup PuppetDB, adjust :file:`/etc/puppet/puppetdb.conf`:

.. parsed-literal::

    # :command:`cat > /etc/puppet/puppetdb.conf << EOF`
    [main]
    server = puppet.$(hostname -d)
    port = 8081
    EOF

Provide it the proper SSL certificates and CA from the Puppet
installation:

.. parsed-literal::

    # :command:`puppetdb ssl-setup`

.. parsed-literal::

    # :command:`service puppetdb start`

Next, create the initial clones of the domain name space specific
management repositories:

.. parsed-literal::

    # :command:`mkdir -p /var/lib/puppet/private/$(hostname -d)/`
    # :command:`for environment in development testing production; do
        cd /var/lib/puppet/private/$(hostname -d)/
        git clone -b $environment /git/$(hostname -d)/ $environment
    done`

    # :command:`for environment in development testing production; do
        mkdir -p /var/lib/puppet/environments/$environment/manifests
        cd /var/lib/puppet/environments/$environment/
        echo "modulepath = /var/lib/puppet/environments/$environment/modules:\\$basemodulepath" > environment.conf
        cp -fa /var/lib/puppet/private/$(hostname -d)/$environment/puppet/site.pp .
        cp -fa /var/lib/puppet/private/$(hostname -d)/$environment/puppet/manifests .

        mkdir -p /var/lib/puppet/environments/$environment/modules/
        cd /var/lib/puppet/environments/$environment/modules/
        for module in git kolab munin nagios puppet webserver yum; do
            git clone -b $environment https://github.com/kolab-groupware/puppet-module-$module $module
        done
    done`

    # :command:`mkdir -p /var/lib/puppet/files/`
    # :command:`cd /var/lib/puppet/files/`
    # :command:`git clone /git/$(hostname -d)-sensitive $(hostname -d)`

Additionally, install the following two required modules from the Puppet
Forge:

.. parsed-literal::

    # :command:`puppet module install puppetlabs-stdlib`
    # :command:`puppet module install dalen-puppetdbquery`

.. parsed-literal::

    service mysqld start
    mysql_secure_installation
    cat > ~/.my.cnf << EOF
    [client]
    password=$PASSWORD
    EOF
    mysql -e "create database dashboard;"
    mysql -e "grant all privileges on dashboard.* to 'dashboard'@'localhost' identified by 'asdasd';"
    mysql -e "flush privileges;"
    cat > /usr/share/puppet-dashboard/config/database.yml << EOF
    production:
        database: dashboard
        username: dashboard
        password: asdasd
        encoding: utf8
        adapter: mysql

    development:
        database: dashboard
        username: dashboard
        password: asdasd
        encoding: utf8
        adapter: mysql

    test:
        database: dashboard
        username: dashboard
        password: asdasd
        encoding: utf8
        adapter: mysql
    EOF
    cd /usr/share/puppet-dashboard
    rake db:migrate
    rake gems:refresh_specs

.. IMPORTANT::

    The dashboard report prune job does not eliminate records in other
    tables, and it is therefore necessary to add to the database
    schema:

    .. parsed-literal::

        ALTER TABLE resource_events ADD FOREIGN KEY (resource_status_id) REFERENCES resource_statuses(id) ON UPDATE CASCADE ON DELETE CASCADE;
        ALTER TABLE resource_statuses ADD FOREIGN KEY (report_id) REFERENCES reports(id) ON UPDATE CASCADE ON DELETE CASCADE;
        ALTER TABLE report_logs ADD FOREIGN KEY (report_id) REFERENCES reports(id) ON UPDATE CASCADE ON DELETE CASCADE;
        ALTER TABLE metrics ADD FOREIGN KEY (report_id) REFERENCES reports(id) ON UPDATE CASCADE ON DELETE CASCADE;
        ALTER TABLE reports ADD FOREIGN KEY (node_id) REFERENCES nodes(id) ON UPDATE CASCADE ON DELETE CASCADE;

The server can now be made its own client, and start managing Puppet by
Puppet:

.. parsed-literal::

    # :command:`puppet agent --verbose --onetime --no-daemonize --server puppet.$(hostname -d) --environment development`
    # :command:`puppet ca sign $(hostname -f)`
    # :command:`puppet agent --verbose --onetime --no-daemonize --server puppet.$(hostname -d) --environment development`

For yet undetermined reasons, the Puppet master server may hold a certificate signing request, yet be unable to sign the request (with a message "Could not find certificate request for"). Please see :ref:`bootstrap-puppet-reinitialize-ca-and-certs` for more information.

Enabling the Inventory Service in the Puppet Dashboard
======================================================

.. parsed-literal::

    # :command:`cat >> /etc/puppet/auth.conf << EOF`
    path /facts
    auth yes
    method find, search
    allow dashboard
    EOF
    # :command:`sed -r -i \\
        -e "s/^ca_server:.*$/ca_server: 'puppet.$(hostname -d)'/g" \\
        -e "s/^enable_inventory_service:.*$/enable_inventory_service: true/g" \\
        -e "s/^inventory_server:.*$/inventory_server: 'puppet.$(hostname -d)'/g" \\
        -e "s/^use_file_bucket_diffs:.*$/use_file_bucket_diffs: true/g" \\
        -e "s/^file_bucket_server:.*$/file_bucket_server: 'puppet.$(hostname -d)'/g" \\
        /usr/share/puppet-dashboard/config/settings.yml`
    # :command:`cd /usr/share/puppet-dashboard/`
    # :command:`rake cert:create_key_pair`
    # :command:`rake cert:request`
    # :command:`puppet ca sign dashboard`
    # :command:`rake cert:retrieve`

.. _bootstrap-puppet-reinitialize-ca-and-certs:

Re-initializing the CA Certificate and Peer Certificates
========================================================

.. WARNING::

    This process resets the CA, Puppet master server certificate, and
    all Puppet agent certificates.

On the Puppet master server, execute the following:

.. parsed-literal::

    # :command:`service httpd stop`
    # :command:`rm -rf /var/lib/puppet/ssl/`
    # :command:`timeout 10s puppet master --verbose --no-daemonize`
    # :command:`puppetdb ssl-setup -f`
    # :command:`service puppetdb restart`
    # :command:`while [ -z "$(netstat -tlnp | grep :8081)" ]; do sleep 1; done`
    # :command:`service httpd start`
    # :command:`puppet agent --verbose --onetime --no-daemonize --server puppet.$(hostname -d) --environment development`
    # :command:`puppet ca sign $(hostname -f)`
    # :command:`puppet agent --verbose --onetime --no-daemonize --server puppet.$(hostname -d) --environment development`
