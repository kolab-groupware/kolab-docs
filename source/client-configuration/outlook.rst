.. index:: Outlook
.. _settings-clientconfig-outlook:

Microsoft Outlook
-----------------

There are many different ways to connect your Microsoft Outlook client to |service_name|.
Not every way is the right way for you.
Please read each of the following sections carefully and then decide which connection option you prefer.

.. _settings-clientconfig-outlook-imap:

E-Mail Setup
^^^^^^^^^^^^

To set up an email-only account in Outlook follow these steps:

#.  Go to the menu and select *File* and click the *Add Account* button.

#.  Select the "Manually configure server settings or additional server types" option. Click *Next >*.

#.  Select "Internet E-mail" as service. Click *Next >*.

#.  Fill out the form fields with the foollowing data as depicted in the image below:

    *Account Type:*
        **IMAP**

    *Incoming mail server:*
        |**imap_host**|

    *Outgoing mail server (SMTP):*
        |**smtp_host**|

    *User Name:*
        |**useremail**|

    *Password:*
        **<your-password>**

#.  Click *More Settings...* and switch to the "Outgoing Server" tab.

#.  Check the "My outgoing server (SMTP) requires authentication" box. Click *OK*.

#.  Click *Next >* to check the settings and to finish the account setup.

.. container:: screenshots

    .. fancyfigure:: _static/outlook2010-email-setup-1.png
        :group: outlookemail
        :height: 100
        :alt: Outlook 2010 Settings

    .. fancyfigure:: _static/outlook2010-email-setup-2.png
        :group: outlookemail
        :height: 100
        :alt: Outlook 2010 Settings Dialog

    .. fancyfigure:: _static/outlook2010-email-setup-3.png
        :group: outlookemail
        :height: 100
        :alt: Outlook 2010 Settings Dialog

    .. fancyfigure:: _static/outlook2010-email-setup-4.png
        :group: outlookemail
        :height: 100
        :width: 160
        :alt: Outlook 2010 E-mail Account Settings

        .. fancyrender::
            :font: verdana
            :size: 11

            |useremail| @172,152
            |imap_host| @172,225
            |smtp_host| @172,250
            |useremail| @172,299

    .. fancyfigure:: _static/outlook2010-email-setup-5.png
        :group: outlookemail
        :height: 100
        :alt: Outlook 2010 More Settings Dialog

    .. fancyfigure:: _static/outlook2010-email-setup-6.png
        :group: outlookemail
        :height: 100
        :alt: Outlook 2010 Settings Dialog
 
.. only:: activesync

    Outlook 2013 with ActiveSync
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    In order to set up Outlook 2013 with your |service_name| account using the 
    ActiveSync protocol, please go to the menu and select *File*. Then you will 
    see a screen like the first one on the left below.

    Click *Add Account* there and choose manual setup. In the next screen, 
    please choose "Outlook.com or Exchange ActiveSync compatible service". 
    Afterwards, please supply your |service_name| login name using your 
    full email address like you@\ |domain| as *User name* and enter  
    |**activesync_host**| as the *Mail server*.

    .. container:: screenshots

        .. fancyfigure:: _static/outlook2013-activesync-setup-1.png
            :group: outlook2013
            :width: 180
            :height: 110
            :alt: Outlook 2013 ActiveSync Setup Step 1

        .. fancyfigure:: _static/outlook2013-activesync-setup-2.png
            :group: outlook2013
            :height: 110
            :alt: Outlook 2013 ActiveSync Setup Step 2

        .. fancyfigure:: _static/outlook2013-activesync-setup-3.png
            :group: outlook2013
            :height: 110
            :alt: Outlook 2013 ActiveSync Setup Step 4

        .. fancyfigure:: _static/outlook2013-activesync-setup-4.png
            :group: outlook2013
            :height: 110
            :alt: Outlook 2013 ActiveSync Setup Step 4

            .. fancyrender::
                :font: verdana
                :size: 11

                |useremail| @110,152
                |activesync_host| @110,201
                |useremail| @110,252

        .. fancyfigure:: _static/outlook2013-activesync-setup-6.png
            :group: outlook2013
            :height: 110
            :alt: ActiveSync Settings in Web Client

    Please do not forget to review the ActiveSync settings in the webclient and 
    to select the folders you want to make available to Outlook.

    .. note::

        ActiveSync also syncronizes email folders to Outlook. You therefore 
        don't need to set up the IMAP email account as described in the 
        :ref:`settings-clientconfig-outlook-imap` above.


Outlook with Bynari Outlook Connector
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The `Bynari Outlook
Connector <http://www.bynari.net/download/#Connector>`__ by
`Bynari <http://www.bynari.net>`__ makes it possible for Outlook
(2007-2013) to connect to |service_name| just like it does natively with
Microsoft Exchange. It gives you a full Kolab groupware experience while
you continue to use the client you might be used to.

To get started, first `install Bynari Outlook
Connector <http://www.bynari.net/download/#Connector>`__. It will
provide you the steps to create a new profile for your Outlook Connector
account. To modify the account settings, run Windows
Control Panel and double click on *Mail*. You will see *Mail Setup*
window, select *Show Profiles...* and will open a new windows of the
Outlook profiles. Select your *Outlook Connector* profile and click on
*Properties*. This will open *Outlook Connector* account settings. To
modify your IMAP or SMTP settings, click on *More Settings...* button
and you will see the *Connections* configuration for *IMAP* and *SMTP*.

Please make sure that you check the box for Kolab 3 server.
The screenshots below provide all the values you need to fill in.

.. container:: screenshots

    .. fancyfigure:: _static/outlook-bynari-OC-1.png
        :group: OC
        :height: 100
        :alt: Bynari Outlook Connector Step 1

    .. fancyfigure:: _static/outlook-bynari-OC-2.png
        :group: OC
        :height: 100
        :alt: Bynari Outlook Connector Step 2

    .. fancyfigure:: _static/outlook-bynari-OC-3.png
        :group: OC
        :height: 100
        :alt: Bynari Outlook Connector Step 3

    .. fancyfigure:: _static/outlook-bynari-OC-4.png
        :group: OC
        :height: 100
        :alt: Bynari Outlook Connector Step 4

            .. fancyrender::
                :font: verdana
                :size: 11

                Test User @256,140
                |useremail| @256,164
                |imap_host| @256,218
                |smtp_host| @256,244
                |useremail| @256,300

    .. fancyfigure:: _static/outlook-bynari-OC-5.png
        :group: OC
        :height: 100
        :alt: Bynari Outlook Connector Step 5

            .. fancyrender::
                :font: verdana
                :size: 11

                |imap_host| @260,120
                |imap_port| @260,147
                |useremail| @260,174

    .. fancyfigure:: _static/outlook-bynari-OC-6.png
        :group: OC
        :height: 100
        :alt: Bynari Outlook Connector Step 6

            .. fancyrender::
                :font: verdana
                :size: 11

                |smtp_host| @260,12
                |smtp_port| @260,147

.. only:: dav

    Calendars and Contacts with OutlookDAV
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    One possibility to connect your |service_name| account with older Outlook 
    versions is `OutlookDAV <http://www.outlookdav.com/>`_ by `SurGATE <http://www.surgatelabs.com/>`_.
    It will automatically discover all of your calendars, tasks and contacts 
    and sync with Outlook. It also allows you to backup Outlook or 
    |service_name| folders on your computer and restore from previous backups.

    To get started, first install OutlookDAV and open it. You should see 
    something similar to the first screenshot below. Click *Start* in the basic 
    configuration section. On the next page, type |**caldav_host**| and check 
    *Use SSL*. Type your full |service_name| email address and password. Click 
    *Remember Me* if you want OutlookDAV to remember your credentials, so you 
    do not need to provide them all the time. Click *Connect* to continue.

    In the next window, you will see all available folders. You don't need to 
    select the type, as auto discovery usually finds the type. Select existing 
    Outlook folder by clicking drop down menu or click *Create* to create a new 
    folder in Outlook. Select two way sync as the transfer type for each folder 
    you want to synchronize. Once you are done with all the settings, click 
    *Save*.

    Now you can click the Sync tab. In order to start a manual synchronization 
    of your events, contacts and tasks, click the sync button at the top. If 
    you encounter a problem you can see the errors in *Tools > Errors* window. 
    Please report all problems to `SurGATE <http://www.surgatelabs.com/support/>`_ 
    directly.

    .. container:: screenshots

        .. fancyfigure:: _static/outlookDAV-0.png
            :group: outlookDAV
            :height: 110
            :alt: SurGATE OutlookDAV Main screen

        .. fancyfigure:: _static/outlookDAV-1.png
            :group: outlookDAV
            :height: 110
            :alt: SurGATE OutlookDAV Wizard Step 1

            .. fancyrender::
                :font: verdana-bold
                :size: 14

                |caldav_host| @253,335
                |useremail| @253,402

        .. fancyfigure:: _static/outlookDAV-2.png
            :group: outlookDAV
            :height: 110
            :alt: SurGATE OutlookDAV Main screen

        .. fancyfigure:: _static/outlookDAV-3.png
            :group: outlookDAV
            :height: 110
            :alt: SurGATE OutlookDAV Main screen

        .. fancyfigure:: _static/outlookDAV-4.png
            :group: outlookDAV
            :height: 110
            :alt: SurGATE OutlookDAV Main screen

            .. fancyrender::
                :font: verdana
                :size: 11
                :color: #ffffff

                |caldav_uri_long| @275,278 #28


    Connect Outlook with Bynari WebDAV Collaborator
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    To connect your |service_name| account with Outlook (2007-2013) you can use
    the `WebDAV Collaborator <http://www.bynari.net/download/#WebDAV/>`__ by
    `Bynari <http://www.bynari.net>`__.

    To get started, first `install WebDAV
    Collaborator <http://www.bynari.net/download/#WebDAV/>`__. After you
    installed it, start Outlook. You should see something
    similar to the first screenshot below. Click *Configure* in the WebDAV
    Collaborator toolbar. Click on *Add* to add a folder mapping with your
    |service_name| account. Select a folder you wish to map to your online folder
    and click on *OK*. Provide your full primary email address as user
    name, then enter password and the same email address. Enter |**caldav_uri**|
    as the CalDAV/CardDAV URL
    and click *Detect Account Settings* to verify your URL to continue.
    Click on *OK* to save your configuration. To add another folder, click
    *Add*.

    Now you can click the Synchronize button in WebDAV Collaborator toolbar
    to manually synchronize your events, contacts and tasks. If you
    encounter a problem you can see the errors in error reporting.
    Please report all problems to Bynari directly and not to |service_name|.

    .. container:: screenshots

        .. fancyfigure:: _static/outlook-bynari-WDC-1.png
            :group: WDC
            :height: 150
            :alt: WebDAV Collaborator Step 1

        .. fancyfigure:: _static/outlook-bynari-WDC-2.png
            :group: WDC
            :height: 150
            :alt: WebDAV Collaborator Step 2

        .. fancyfigure:: _static/outlook-bynari-WDC-3.png
            :group: WDC
            :height: 150
            :alt: WebDAV Collaborator Step 3

            .. fancyrender::
                :font: verdana
                :size: 11

                |useremail| @58,116

        .. fancyfigure:: _static/outlook-bynari-WDC-4.png
            :group: WDC
            :height: 150
            :alt: WebDAV Collaborator Step 4

            .. fancyrender::
                :font: verdana
                :size: 11

                \\|useremail|\Calendar @265,158
                |useremail| @265,187
                |useremail| @265,242
                |caldav_uri_long| @265,268 #46


    Outlook with the ical4OL Connector
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    The `ical4OL Connector <http://ical.gutentag.ch/>`__ is a CalDAV/CardDAV
    sync solution for Outlook versions 2000-2013. It is not supported by us,
    but can be used to connect Outlook to your |service_name| account.

    After starting the connector in Outlook, please enter
    |**caldav_uri**| as the server, provide your full primary email
    address like |**useremail**| and your password. Then click on
    *Retrieve configuration from server and save it*. In the next dialog
    window, you can assign CalDAV calendars to your Outlook calendars and do
    some settings. There is also a button *New* to create new calendars.
    Once you are done, hit *Save* and enjoy your calendars.

    .. container:: screenshots

        .. fancyfigure:: _static/outlook-ical4ol-setup-1.png
            :group: ical4OL
            :height: 150
            :alt: ical4OL Connector Step 1

            .. fancyrender::
                :font: verdana
                :size: 11

                |caldav_uri| @96,52
                |useremail| @96,80

        .. fancyfigure:: _static/outlook-ical4ol-setup-2.png
            :group: ical4OL
            :height: 150
            :alt: ical4OL Connector Step 2

        .. fancyfigure:: _static/outlook-ical4ol-setup-3.png
            :group: ical4OL
            :height: 150
            :alt: ical4OL Connector Step 3

            .. fancyrender::
                :font: verdana
                :size: 11

                |service_name| Calendar @15,120

