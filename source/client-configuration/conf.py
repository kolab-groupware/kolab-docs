extensions = [
    'kolab.fancyfigure'
]

# replace the values for these placeholders to match your environment
variables = {
    'service_name': 'Kolab Groupware',
    'service_uri':  'https://<kolab-host>/roundcubemail',
    'domain':       '<your-domain>',
    'username':     '<your-username>',
    'useremail':    '<your-email>',
    'imap_host':    '<kolab-host>',
    'imap_port':    '143',
    'imap_ssl':     'STARTTLS',
    'smtp_host':    '<kolab-host>',
    'smtp_port':    '587',
    'smtp_ssl':     'STARTTLS',
    'caldav_host':  '<kolab-host>/iRony/',
    'caldav_uri':   'https://<kolab-host>/iRony/',
    'caldav_uri_long':   'https://<kolab-host>/iRony/calendars/<your-username>%40<your-domain>/',
    'carddav_host':      '<kolab-host>/iRony/',
    'carddav_uri':       'https://<kolab-host>/iRony/',
    'carddav_uri_long':  'https://<kolab-host>/iRony/addressbooks/<your-username>%40<your-domain>/',
    'webdav_host':       '<kolab-host>',
    'webdav_uri':        'https://<kolab-host>',
    'activesync_host':   '<kolab-host>',
}

# remove tags in case your setup doesn't support all Kolab services/features
tags = ['dav', 'webdav', 'tls', 'autoconf', 'activesync']
