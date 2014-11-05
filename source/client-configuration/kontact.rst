.. _settings-clientconfig-kontact:

Kontact
-------

.. image:: _static/kontact-logo.png
    :align: right

`Kontact <http://kontact.org>`__ is the original client for
`Kolab <http://kolab.org>`__, the software which is used by |service_name|.
It is fully `Free
Software <https://fsfe.org/freesoftware>`__ and
supports end-to-end encryption with `GnuPG <http://gnupg.org>`__ out of
the box. It is available for GNU/Linux and Windows.
Kolab Systems sponsors the `Windows
installer <http://mirror.kolabsys.com/pub/upload/windows/K3-Kontact-Beta-latest.exe>`__
and maintains the Windows version.

If you want to set up Kontact with your |service_name| account,
please follow the instructions below.

There is extensive documentation available for
`Kontact <http://docs.kde.org/stable/en/kdepim/kontact/index.html>`__,
its
`Calendar <http://docs.kde.org/stable/en/kdepim/korganizer/index.html>`__
and its
`Email <http://docs.kde.org/stable/en/kdepim/kmail/index.html>`__
program.

Set up a Kolab Account
^^^^^^^^^^^^^^^^^^^^^^

In order to add a new account to your Kontact, please open the Account
Assistant and select *Kolab Groupware Server* as the account type. Fill
out the Personal Settings while making sure that the Server Address is
set to |**imap_host**| and the Kolab Version to *v3*.

.. container:: screenshots

    .. fancyfigure:: _static/kontact-account-wizard-1.png
        :group: kontactwizard
        :height: 200
        :alt: Select Account Type: Kolab Groupware

    .. fancyfigure:: _static/kontact-account-wizard-2.png
        :group: kontactwizard
        :height: 200
        :alt: Personal Settings

        .. fancyrender::
            :font: verdana
            :size: 12

            |useremail| @128,105
            |imap_host| @128,159
 
    .. fancyfigure:: _static/kontact-account-wizard-3.png
        :group: kontactwizard
        :height: 200
        :alt: Setting up Account

IMAP Configuration                                                                                                                                                      
^^^^^^^^^^^^^^^^^^                                                                                                                                                      
                                                                                                                                                                        
If you followed the above instructions using the Account Assistant, your
IMAP account should already have been set up properly. However, you can
verify your settings based on the screenshots below. In order to do so,
please go to *Settings* in the menu bar and choose *Configure Kontact*.
Then go to *Mail* and *Accounts*.

Please make sure that the IMAP Server is |**imap_host**| and that it
uses port |**imap_port**| with |**imap_ssl**| encryption. Please also use your full and
primary |service_name| address such as |**useremail**| as a user name.

.. container:: screenshots

    .. fancyfigure:: _static/kontact-imap-1.png
        :group: kontactimap
        :height: 200
        :alt: Account Information

        .. fancyrender::
            :font: verdana
            :size: 12

            |service_name| @140,78
            |imap_host|    @140,105
            |username|     @140,132

    .. fancyfigure:: _static/kontact-imap-2.png
        :group: kontactimap
        :height: 200
        :alt: IMAP Settings

        .. fancyrender::
            :font: verdana
            :size: 12

            |imap_port| @137,364
 

SMTP Configuration
^^^^^^^^^^^^^^^^^^

Unfortunately, the SMTP settings need to be corrected after account
setup. In order to do so, please go to *Settings* in the menu bar and
choose *Configure Kontact*. Then go to *Mail*, *Accounts* and then
click on the *Sending* tab. The server should be |**smtp_host**| with
port |**smtp_port**| and TLS encryption. Please use your full and primary
|service_name| address such as |**useremail**| as a user name and also see
the screenshots below.

.. container:: screenshots

    .. fancyfigure:: _static/kontact-smtp-1.png
        :group: kontactsmtp
        :height: 200
        :alt: Account Information

        .. fancyrender::
            :font: verdana
            :size: 12

            |smtp_host|    @174,75
            |username|     @174,127

    .. fancyfigure:: _static/kontact-smtp-2.png
        :group: kontactsmtp
        :height: 200
        :alt: SMTP Settings

        .. fancyrender::
            :font: verdana
            :size: 12

            |smtp_port| @133,136
