.. _settings-clientconfig-osx:

Mac OS X Native Applications
----------------------------

.. image:: _static/osx-logo.png
    :align: right

Apple Mail
^^^^^^^^^^

When you start Apple Mail the first time, it will ask you to
provide your name, your email address and your password. Please provide
your |service_name| credentials there. In the following screens, please give this
information:

* User Name: Your full |service_name| email address like |**useremail**|
* Incoming Mail Server: |**imap_host**|
* Outgoing Mail Server: |**smtp_host**|

Please see the screenshots below for details.

.. container:: screenshots

    .. fancyfigure:: _static/osx-applemail-1.png
        :group: applemail
        :height: 200
        :alt: Welcome to Mail 

        .. fancyrender::
            :font: verdana
            :size: 12

            |useremail| @292,204

    .. fancyfigure:: _static/osx-applemail-2.png
        :group: applemail
        :height: 200
        :alt: Incoming Mail Server

        .. fancyrender::
            :font: verdana
            :size: 12

            |service_name| @339,112
            |imap_host|    @339,154
            |username|     @339,186

    .. fancyfigure:: _static/osx-applemail-3.png
        :group: applemail
        :height: 200
        :alt: Outgoing Mail Server

        .. fancyrender::
            :font: verdana
            :size: 12

            |service_name| @340,77
            |smtp_host|    @340,105
            |username|     @340,197

    .. fancyfigure:: _static/osx-applemail-4.png
        :group: applemail
        :height: 200
        :alt: Account Summary

        .. fancyrender::
            :font: verdana
            :size: 12

            |service_name| @356,82
            |useremail|    @363,120
            |username|     @363,139
            |imap_host|    @356,177
            |smtp_host|    @356,234

Some versions of OS X fail at auto-detecting the correct settings and
require the following manual steps:

#. Go to *Accounts* -> *Account Information*
#. Select *Outgoing Mail Server (SMTP)* -> *Edit SMTP Server list...*
#. In the *Advanced* tab, select *Use custom port* and set the port to
   |**smtp_port**|.
#. Please check the option **Use Secure Sockets Layer (SSL)** and use
   **Password** as authentication method.

.. only:: dav

    .. _settings-clientconfig-osx-ical:

    iCal
    ^^^^

    In order to set up iCal, please open the preferences from the menu bar.
    Then choose  *Accounts* and add a new account by clicking the *+* Icon
    in the left bottom corner as indicated in the second screenshot below.
    Please enter the following information in the dialog.

    * Account Type: **CalDAV**
    * User Name: Your full |service_name| email address like
      |**useremail**|
    * Server Address: |**caldav_host**|

    .. container:: screenshots

        .. fancyfigure:: _static/osx-ical-1.png
            :group: ical
            :height: 200
            :alt: iCal Accounts 

        .. fancyfigure:: _static/osx-ical-2.png
            :group: ical
            :height: 200
            :alt: iCal Add Account

        .. fancyfigure:: _static/osx-ical-3.png
            :group: ical
            :height: 200
            :alt: iCal Add a CalDAV Account

            .. fancyrender::
                :font: verdana
                :size: 12

                |username|    @224,189
                |caldav_host| @224,243

        .. fancyfigure:: _static/osx-ical-4.png
            :group: ical
            :height: 200
            :alt: iCal Accounts Overview

            .. fancyrender::
                :font: verdana-bold
                :size: 12
                :color: white

                |service_name| @58,189

            .. fancyrender::
                :font: verdana
                :size: 11

                |service_name| @306,164
                |useremail|    @306,191
                |username|     @306,244


    Reminders
    ^^^^^^^^^

    OS X 10.8 has a dedicated Reminders program which can show your tasks
    from |service_name|. You do not need to set it up separately. As soon as
    your :ref:`settings-clientconfig-osx-ical` is set up, Reminders will also be.


    Contacts
    ^^^^^^^^

    In order to set up Contacts, please open the preferences from the menu
    bar. Then choose  *Accounts* and add a new account by clicking the *+*
    Icon in the left bottom corner as indicated in the second screenshot
    below. Please enter the following information in the dialog.

    * Account Type: **CardDAV**
    * User Name: Your full |service_name| email address like
      |**useremail**|
    * Server Address: |**carddav_host**|

    .. container:: screenshots

        .. fancyfigure:: _static/osx-contacts-1.png
            :group: contacts
            :height: 200
            :alt: Contacts Add Accounts

        .. fancyfigure:: _static/osx-contacts-2.png
            :group: contacts
            :height: 200
            :alt: Contacts Add a CardDAV Account

            .. fancyrender::
                :font: verdana
                :size: 12

                |username|     @292,249
                |carddav_host| @292,309

        .. fancyfigure:: _static/osx-contacts-3.png
            :group: contacts
            :height: 200
            :alt: Contacts Accounts Overview

            .. fancyrender::
                :font: verdana-bold
                :size: 12
                :color: white

                |service_name| @54,151

            .. fancyrender::
                :font: verdana
                :size: 11

                |service_name| @296,165
                |useremail|    @296,191

.. only:: webdav

    Files
    ^^^^^

    There is different possibilities to access your |service_name| files with
    your Mac. We show two of them below.

    Using Cyberduck
    """""""""""""""

    `Cyberduck <http://cyberduck.ch/>`__ is a Swiss Free Software cloud
    storage browser for Mac. This is the recommended way to access your
    files. After you have installed it, add a new WebDAV connection as shown
    in the screenshots below. Please enter the following information:

    * Server Name: |**webdav_host**|
    * Port: **443**
    * Username: Your full |service_name| email address like |**useremail**|
    * Path: **/Files**

    .. container:: screenshots

        .. fancyfigure:: _static/osx-cyberduck-1.png
            :group: cyberduck
            :height: 200
            :alt: Cyberduck Add Storage

            .. fancyrender::
                :font: verdana
                :size: 11
                :color: blue

                https://|useremail|@|webdav_host|/Files @151,103

            .. fancyrender::
                :font: verdana
                :size: 11

                |service_name| @156,79
                |webdav_host|  @156,129
                |username|     @156,156
                /Files         @156,235

        .. fancyfigure:: _static/osx-cyberduck-2.png
            :group: cyberduck
            :height: 200
            :alt: Cyberduck Login

            .. fancyrender::
                :font: verdana
                :size: 11

                |username| @159,108


    Using Native OS X
    """""""""""""""""

    It is also possible to use no special program, but just your Mac OS X
    operating system to access your files. However, **we do not recommend** to do
    this, as this is implemented poorly by Apple and therefore very slow.

    If you still want to do this, please open the *Go* menu in your finder,
    and enter |**webdav_uri**|/**Files** as the *Server Address*. Then
    click *Connect* and enter your full email address and password.
    Afterwards, your |service_name| files will show up in your file browser as
    a shared resource.

    .. container:: screenshots

        .. fancyfigure:: _static/osx-webdav-1.png
            :group: osxfiles
            :height: 200
            :alt: Mac OS X Files

        .. fancyfigure:: _static/osx-webdav-2.png
            :group: osxfiles
            :height: 200
            :alt: Mac OS X Files

            .. fancyrender::
                :font: verdana
                :size: 11

                |webdav_uri|/Files @24,57

        .. fancyfigure:: _static/osx-webdav-3.png
            :group: osxfiles
            :height: 200
            :alt: Mac OS X Files

            .. fancyrender::
                :font: verdana
                :size: 11

                |username| @184,154

        .. fancyfigure:: _static/osx-webdav-4.png
            :group: osxfiles
            :height: 200
            :alt: Mac OS X Files

            .. fancyrender::
                :font: verdana-bold
                :size: 12
                :color: white

                |webdav_host| @40,198

            .. fancyrender::
                :font: verdana
                :size: 11

                Files @276,98

