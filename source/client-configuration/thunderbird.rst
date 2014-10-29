.. index:: Thunderbird
.. _settings-clientconfig-thunderbird:

Mozilla Thunderbird
-------------------

E-Mail Setup
^^^^^^^^^^^^

When you start Thunderbird the first time, it will ask you to create an account. Please say that you want to use an existing email address.

The following dialog should appear where you can enter you account 
credentials. Click *Continue* and Thunderbird will attempt to find the 
correct settings automatically.

.. fancyfigure:: _static/thunderbird-autoconfig.png
    :group: thunderbird
    :width: 240
    :height: 160
    :alt: Thunderbird Account Setup Dialog

    .. fancyrender::
        :font: verdana
        :size: 11

        |useremail| @125,82

        |imap_host| @148,225

        |smtp_host| @148,249

        |useremail| @112,272

If the automatic configuration detection fails, enter the credentials for 
incoming and outgoing servers as depicted below:

.. fancyfigure:: _static/thunderbird-manual.png
    :group: thunderbird
    :width: 400
    :height: 160
    :alt: Thunderbird Manual Account Setup

    .. fancyrender::
        :font: verdana
        :size: 11

        |useremail| @125,82

        |imap_host| @186,241

        |imap_port| @374,241

        |imap_ssl|  @442,242

        |smtp_host| @186,269

        |smtp_port| @374,269

        |smtp_ssl|  @442,270

        |useremail| @186,298

        |useremail| @569,298

Click *Done* to re-test the configuration and finish the setup.


.. only:: dav

    .. index:: Lightning
    .. _settings-clientconfig-thunderbird-lightning:

    Calendar Setup
    ^^^^^^^^^^^^^^

    In order to use calendars with Thunderbird, you need to first install the 
    `Lightning Add-on <https://www.mozilla.org/projects/calendar/lightning/>`_ 
    if you do not have it already. Then switch to the Calendar 
    tab and in the bottom left corner right click below your local 'Home' 
    calendar. A context menu will pop up where you can select *New 
    Calendar...*. In the following dialog you say that your calendar is *On the 
    Network*, then click Next. On the next screen, please select the CalDAV 
    format and enter the following address:

        |**caldav_uri_long**|\ **Calendar**

    .. fancyfigure:: _static/thunderbird-lightning-newcal.png
        :group: thunderbirdcaldav
        :width: 240
        :height: 180
        :alt: Thunderbird Calendar Setup Dialog

        .. fancyrender::
            :font: verdana
            :size: 11

            |caldav_uri_long|Calendar @344,262 #64

    The above URL will usually only work for the standard Calendar that is set 
    up initially. In order to add your other calendars, please repeat this 
    procedure and use the CalDAV URL that the option *Show Calendar URL* from 
    the Webinterface will get you. To get this URL, please login to 
    |service_uri| and then follow the following steps:

    #.  Select *Calendar* in the top right corner drop-down menu

    #.  Select the calendar you wish to add to Thunderbird/Lightning with a 
        single left click in the lower left corner. The selected calendar 
        should visibly highlight.

    #.  Next click on the small gear symbol below

    #.  From the menu you'll see, please select *Show Calendar URL*

    #.  In the window that will appear please copy the second URL
        (where it says CalDAV)

    This is the CalDAV URL you have to use in the above procedure in order to 
    add any calendar to Thunderbird/Lightning.

    If you want to synchronize your tasks as well, you can add a second 
    "calendar" with the following address:

        |**caldav_uri_long**|\ **Tasks**

    Now your tasks should show up in Thunderbird as well.


    Address Book Setup
    ^^^^^^^^^^^^^^^^^^

    In order to use your |service_name| address books with Thunderbird, you 
    need to first install the `SOGo Connector Thunderbird extension <http://www.sogo.nu/fr/downloads/frontends.html>`_ 
    if you do not have it already. Then click the *Address Book* button and 
    in the *Address Book* window, go to the menu, choose *File > New > Remote 
    Address Book*. On the next screen, please enter the following address:

        |**carddav_uri_long**|\ **Contacts**

    In order to add other address books, please repeat this procedure for each 
    address book. You can get the URL for the address books the same way as 
    described above in the :ref:`settings-clientconfig-thunderbird-lightning`.

    .. fancyfigure:: _static/thunderbird-new-addressbook.png
        :group: thunderbirdcarddav
        :width: 240
        :height: 180
        :alt: Thunderbird CardDAV Addressbook Dialog

        .. fancyrender::
            :font: verdana
            :size: 11

            |carddav_uri_long|Contacts @93,355 #72