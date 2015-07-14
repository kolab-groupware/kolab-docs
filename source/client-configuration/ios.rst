.. index:: iPhone, iPad, iOS
.. _settings-clientconfig-ios:

iOS (iPhone/iPad)
=================

.. image:: _static/ios-logo.png
    :align: right

Below, we provide information for how to set up the native iOS 7 apps,
so they can connect to |service_name|.
Instructions for other iOS versions might differ,
but should be very similar.

.. _settings-clientconfig-ios-start:

Start the Configuration
-----------------------

In order to configure your iOS device to use |service_name|, you have to
open the *Settings* app and click *Mail, Contacts, Calenders* as in the
screenshot below. In the next page, please click *Add Account...* and
continue following the instructions below.

.. container:: screenshots

    .. fancyfigure:: _static/ios-settings-1.png
        :group: iosconfig
        :height: 200
        :alt: Settings

    .. fancyfigure:: _static/ios-settings-2.png
        :group: iosconfig
        :height: 200
        :alt: Settings: Mail, Contacts, Calendars

    .. fancyfigure:: _static/ios-settings-3.png
        :group: iosconfig
        :height: 200
        :alt: Add Account

.. _settings-clientconfig-ios-mail:

Mail
----

After you have reached the *Add Account* screen
as described in :ref:`settings-clientconfig-ios-start`,
you can add an email account by clicking *Add Mail Account*.

#. In the next screen, please provide your name, your |service_name| email address
   and your password.
   If you want to add your alias addresses, come back to this screen later and tap the email address.
   You should see an *Add Another Email...* option.
   With older iOS versions, you can provide multiple email addresses separated by comma.
#. Please make sure that *IMAP* is selected.
#. Add |**imap_host**| as the *Host Name*
   and your full and primary email address as *User Name*
   in the *INCOMING MAIL SERVER* section.
#. Please provide |**smtp_host**| as *Host Name* in the *OUTGOING MAIL SERVER* section
   along with the same user name and password as above.

Your |service_name| account is now set up on your iPhone or iPad.

.. container:: screenshots

    .. fancyfigure:: _static/ios-mail-1.png
        :group: iosmail
        :height: 200
        :alt: Add Mail Account 

    .. fancyfigure:: _static/ios-mail-2.png
        :group: iosmail
        :height: 200
        :alt: New Account

        .. fancyrender::
            :font: verdana
            :size: 32

            |service_name| Customer @232,180
            |useremail|             @232,270
            |service_name|          @232,446

    .. fancyfigure:: _static/ios-mail-3.png
        :group: iosmail
        :height: 200
        :alt: Incoming Mail Server

        .. fancyrender::
            :font: verdana
            :size: 32

            |service_name| Customer @232,312
            |useremail|             @232,400
            |service_name|          @232,485
            |imap_host|             @232,685
            |username|              @232,773

    .. fancyfigure:: _static/ios-mail-4.png
        :group: iosmail
        :height: 200
        :alt: Outgoing Mail Server

        .. fancyrender::
            :font: verdana
            :size: 32

            |imap_host| @232,271
            |username|  @232,358
            |smtp_host| @232,645
            |username|  @232,733


.. only:: activesync

    ActiveSync for Access to all Data
    ---------------------------------

    Although, we recommend using IMAP for email as described above,
    it is also possible to sync all your |service_name| data via the ActiveSync protocol as described below.

    After you have reached the *Add Account* screen
    as described in :ref:`settings-clientconfig-ios-start`,
    you can add your data from |service_name| using
    ActiveSync by creating an *Exchange* account.
    Please note that |service_name| is not actually running a Microsoft Exchange server,
    but a Free Software implementation of the ActiveSync protocol used by Exchange.

    #. In the first screen, please provide your email address and password.
    #. Then, please enter |**activesync_host**| as the *Server* like indicated in the screenshot below.
    #. The *Domain* is optional, but might be required if you are not using one of the default domains provided by |service_name|.
    #. In the last screen, you can define what kind of data you want to synchronize.
       We recommend to disable mail and instead use the instructions above (see :ref:`settings-clientconfig-ios-mail`) for mail.
    #. After successful account creation,
       you should select which data shall be synchronized in the webmail settings (see last screenshot).

    Note: Depending on how much data you have in your |service_name| account,
    it might take a couple of minutes before everything has been downloaded to your device.

    .. container:: screenshots

        .. fancyfigure:: _static/ios-activesync-1.png
            :group: iosactivesync
            :height: 200
            :alt: Add Account: Exchange 

        .. fancyfigure:: _static/ios-activesync-2.png
            :group: iosactivesync
            :height: 200
            :alt: Exchange Credentials

            .. fancyrender::
                :font: verdana
                :size: 32

                |useremail|    @232,212
                |service_name| @232,390

        .. fancyfigure:: _static/ios-activesync-3.png
            :group: iosactivesync
            :height: 200
            :alt: Exchange Server

            .. fancyrender::
                :font: verdana
                :size: 32

                |useremail|       @232,170
                |activesync_host| @232,328
                |username|        @232,574
                |service_name|    @232,822

            .. fancyrender::
                :font: verdana
                :size: 32
                :color: #c0c0c0

                Optional @232,487

        .. fancyfigure:: _static/ios-activesync-4.png
            :group: iosactivesync
            :height: 200
            :alt: Exchange Data

        .. fancyfigure:: _static/roundcube-activesync-setup.png
            :group: iosactivesync
            :width: 200
            :alt: Active Sync Setup

            .. fancyrender::
                :font: verdana
                :size: 12

                |useremail| @665,15

.. only:: dav

    CardDAV/CalDAV for Contacts, Calendars and Tasks
    ------------------------------------------------

    Contacts, Calendars and Tasks can also be synced using the CardDAV and CalDAV protocols.
    Please note that setting this up is not necessary if you have already set up ActiveSync.

    After you have reached the *Add Account* screen
    as described in :ref:`settings-clientconfig-ios-start`,
    you can sync your data from |service_name|
    by clicking on *Add CardDAV Account* and *Add CalDAV Account*.

    For both account types, we provide the necessary configuration values below.

    * Username: Your full and primary |service_name| email address
    * Password: Your |service_name| password that belongs to your email address
    * Description: |**service_name**|
    * CardDAV Server: |**carddav_host**|
    * CalDAV Server: |**caldav_host**|

    .. container:: screenshots

        .. fancyfigure:: _static/ios-carddav-1.png
            :group: iosdav
            :height: 200
            :alt: Add CardDAV Account

        .. fancyfigure:: _static/ios-carddav-2.png
            :group: iosdav
            :height: 200
            :alt: CardDAV Settings

            .. fancyrender::
                :font: verdana
                :size: 32

                |carddav_host| @232,222
                |username|     @232,310
                |service_name| @232,486

        .. fancyfigure:: _static/ios-caldav-1.png
            :group: iosdav
            :height: 200
            :alt: Add CalDAV Account

        .. fancyfigure:: _static/ios-caldav-2.png
            :group: iosdav
            :height: 200
            :alt: CalDAV Settings

            .. fancyrender::
                :font: verdana
                :size: 32

                |caldav_host|  @232,222
                |username|     @232,310
                |service_name| @232,486


