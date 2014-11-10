.. index:: Android
.. _settings-clientconfig-android:

Android
=======

.. image:: _static/android-logo.png
    :align: right

This page describes how you can access your data from your |service_name|
account with your
`Android <https://en.wikipedia.org/wiki/Android_%28operating_system%29>`__
mobile phone or tablet. Everything will be synchronized and keep the same
state across all your devices.

Please follow the instructions below
closely and keep in mind that we have no influence over the specific app or
Android version that you might be using.

.. _settings-clientconfig-android-k9:

K-9 Mail
--------

We recommend to use the IMAP protocol for email. The standard email app                                                                                                 
on Android supports it, so do most other apps. However, we found that                                                                                                   
`K-9 Mail <https://play.google.com/store/apps/details?id=com.fsck.k9>`__                                                                                                
works best and therefore provide the instructions below for that.
You can still use any other IMAP capable app like the default email application.

In order to set up your K-9 Mail,
just add a new account and provide your |service_name| email address as well as your password.
It will disover all necessary settings automatically as shown in the screenshots below.

.. container:: screenshots

    .. fancyfigure:: _static/android-k9-1.png
        :group: k9
        :height: 200
        :alt: K-9 Mail - Set up a new account

        .. fancyrender::
            :font: roboto
            :size: 39

            |useremail| @38,220

    .. fancyfigure:: _static/android-k9-2.png
        :group: k9
        :height: 200
        :alt: K-9 Mail - Checking Incoming/Outgoing Server Settings

    .. fancyfigure:: _static/android-k9-3.png
        :group: k9
        :height: 200
        :alt: K-9 Mail - You're almost done

        .. fancyrender::
            :font: roboto
            :size: 39

            |service_name| @665,338

Your account is now set up!

If the settings could **not** be discovered automatically for some reason,
please choose *Manual Setup* and follow the instructions below.

#. Choose *IMAP* as account type.
#. Username: Provide your primary and full email address here, e.g. |**useremail**|
#. IMAP server: |**imap_host**|
#. Security: |**imap_ssl**|
#. Authentication: **Normal pasword**
#. Port: |**imap_port**|

Then press next and enter the following information for the outgoing server settings:

#. SMTP server: |**smtp_host**|
#. Security: |**smtp_ssl**|
#. Port: |**smtp_port**|
#. Username: Provide your primary and full email address here, e.g. |**useremail**|

.. container:: screenshots

    .. fancyfigure:: _static/android-k9-manual-1.png
        :group: k9manual
        :height: 200
        :alt: K-9 Mail - Account type

    .. fancyfigure:: _static/android-k9-manual-2.png
        :group: k9manual
        :height: 200
        :alt: K-9 Mail - Incoming server settings

        .. fancyrender::
            :font: roboto
            :size: 26

            |useremail| @27,165
            |imap_host| @27,340
            |imap_ssl|  @27,425
            Normal password @27,510
            |imap_port| @27,596

    .. fancyfigure:: _static/android-k9-manual-3.png
        :group: k9manual
        :height: 200
        :alt: K-9 Mail - Outgoing server settings

        .. fancyrender::
            :font: roboto
            :size: 26

            |smtp_host| @27,165
            |smtp_ssl|  @27,250
            |smtp_port| @27,335
            |username|  @27,557

    .. fancyfigure:: _static/android-k9-manual-4.png
        :group: k9manual
        :height: 200
        :alt: K-9 Mail - Account Options
 
.. only:: dav

    .. _settings-clientconfig-android-davdroid:

    DAVdroid for Calendars and Contacts
    -----------------------------------

    This section describes how you can get your calendars and contacts from
    |service_name| on your Android device using the Free Software `DAVdroid
    app <http://davdroid.bitfire.at/what-is-davdroid>`__.
    You can also use other apps that can do CalDAV/CardDAV like
    the non-free `CaldDAV-sync and CardDAV-Sync apps <http://dmfs.org/>`__.
    But we generally recommend to use software that respects your
    freedom. Another possibility is using the built-in Active Sync support.
    Please see :ref:`settings-clientconfig-android-activesync` for more information.

    #. You can get DAVdroid from `Google Play <https://play.google.com/store/apps/details?id=at.bitfire.davdroid>`__
       or the `F-Droid app repository <https://f-droid.org/repository/browse/?fdid=at.bitfire.davdroid>`__.
    #. After installing, it will appear in your list of apps.
       Please open the app.
    #. On the welcome screen, please click the little key icon with the plus to set up your |service_name| account.
    #. Choose DAVdroid in the next screen and then click *Log in with email address*.
    #. Provide your full and primary |service_name| address as well as your password.
    #. The next screen shows all your calendars and address books. Select those that you want
       to synchronize to your Android device.
       Please note that as of now, Android only allows one address book per account.
       You can add more by just adding the same account again later.
    #. On the next screen, please provide the email address you use for calendar invitations with this account.
    #. After clicking *Add Account* in the top right corner,
       your account is created and will now synchronize your contacts and events.

    .. container:: screenshots

        .. fancyfigure:: _static/android-davdroid-1.png
            :group: davdroid
            :width: 150
            :alt: Welcome to DAVdroid

        .. fancyfigure:: _static/android-davdroid-2.png
            :group: davdroid
            :width: 150
            :alt: Add an account: DAVdroid

        .. fancyfigure:: _static/android-davdroid-3.png
            :group: davdroid
            :width: 150
            :alt: Login

        .. fancyfigure:: _static/android-davdroid-4.png
            :group: davdroid
            :width: 150
            :alt: Enter email address

        .. fancyfigure:: _static/android-davdroid-5.png
            :group: davdroid
            :width: 150
            :alt: DAVdroid - Collections

            .. fancyrender::
                :font: roboto
                :size: 39

                |carddav_uri_long| @95,500 #53
                /195204f8ea8c-ab28e6ba5fa-11bc82bc/ @95,545 #53
                |carddav_uri_long| @95,655 #53
                /395204a8eb31-af28467a53a-1248821a/ @95,700 #53

        .. fancyfigure:: _static/android-davdroid-6.png
            :group: davdroid
            :width: 150
            :alt: DAVdroid - Account details

            .. fancyrender::
                :font: roboto
                :size: 39

                |useremail| @330,305

    If the auto-discovery at step 4 did not work,
    then choose *Login with URL and user name* instead.
    In the next screen enter |**caldav_host**| in the server URL and make sure to use **https**.
    Afterwards, you can continue with step 6 above.

    .. container:: screenshots

        .. fancyfigure:: _static/android-davdroid-noauto-1.png
            :group: davdroidnoauto
            :width: 150
            :alt: DAVdroid - Login

        .. fancyfigure:: _static/android-davdroid-noauto-2.png
            :group: davdroidnoauto
            :width: 150
            :alt: DAVdroid - Settings

            .. fancyrender::
                :font: roboto
                :size: 39

                |caldav_host| @266,260
                |username|    @266,360


.. only:: activesync

    .. _settings-clientconfig-android-activesync:

    ActiveSync for Calendars and Contacts
    -------------------------------------

    This section describes how you can get your calendars and contacts from
    |service_name| on your Android device. It assumes that you will use Mobile
    Synchronization with *ActiveSync* which will integrate nicely into your
    default Android apps. Another possibility is using CalDAV/CardDAV.
    Please see :ref:`settings-clientconfig-android-davdroid` for more information.

    #. Please go to *Settings* -> *Account* -> *Add Account*
    #. Then choose either *Exchange* or *Corporate*.
    #. Afterwards, please provider your primary and full email address, e.g. |**useremail**| 
    #. When asked for incoming server settings, please also give your full email address as username.
       Older versions of Android might require you to provide the username in the form of **domain.tld\\user**
       where **user@domain.tld** is your primary email address.
    #. In the server field, please enter: |**activesync_host**|
    #. Set the account options as you like.
       We recommend to use IMAP for email (see :ref:`settings-clientconfig-android-k9`), but you can activate email here as well.
    #. After successful account creation,
       you should select which data shall be synchronized in the webmail settings (see last screenshot).

    .. container:: screenshots

        .. fancyfigure:: _static/android-activesync-1.png
            :group: activesync
            :width: 200
            :alt: Settings

        .. fancyfigure:: _static/android-activesync-2.png
            :group: activesync
            :width: 200
            :alt: Accounts

        .. fancyfigure:: _static/android-activesync-3.png
            :group: activesync
            :width: 200
            :alt: Add an Account: Corporate

        .. fancyfigure:: _static/android-activesync-4.png
            :group: activesync
            :width: 200
            :alt: Account Setup

            .. fancyrender::
                :font: roboto
                :size: 39

                |useremail| @80,460

        .. fancyfigure:: _static/android-activesync-5.png
            :group: activesync
            :width: 200
            :alt: Account Setup - Sign In

        .. fancyfigure:: _static/android-activesync-6.png
            :group: activesync
            :height: 112
            :alt: Incoming Server Settings

            .. fancyrender::
                :font: roboto
                :size: 22

                |useremail|       @35,267
                |activesync_host| @35,629

        .. fancyfigure:: _static/android-activesync-7.png
            :group: activesync
            :height: 112
            :alt: Account Options

        .. fancyfigure:: _static/android-activesync-8.png
            :group: activesync
            :width: 200
            :alt: Account Name

            .. fancyrender::
                :font: roboto
                :size: 39

                |useremail| @62,469

        .. fancyfigure:: _static/roundcube-activesync-setup.png
            :group: iosactivesync
            :width: 200
            :alt: Active Sync Setup

            .. fancyrender::
                :font: verdana
                :size: 12

                |useremail| @665,15


