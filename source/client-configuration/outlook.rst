.. index:: Outlook
.. _settings-clientconfig-outlook:

Microsoft Outlook
-----------------

.. _settings-clientconfig-outlook-imap:

E-Mail Setup
^^^^^^^^^^^^

To set up an IMAP email account in Outlook follow these steps:

#.  Go to the menu and select *File* and click the *Add Account* button.

#.  Select the "Manually configure server settings or additional server types" option. Click *Next >*.

#.  Select "Intermet E-mail" as service. Click *Next >*.

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

.. fancyfigure:: _static/outlook2010-email-setup-4.png
    :group: outlookemail
    :height: 110
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
    :height: 110
    :width: 160
    :alt: Outlook 2010 More Settings Dialog


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
    "Use SSL". Type your full |service_name| email address and password. Click 
    "Remember Me" if you want OutlookDAV to remember your credentials, so you 
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

