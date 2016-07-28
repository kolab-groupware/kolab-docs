Troubleshooting
===============

.. _about-guam-troubleshooting-getting-debug-output:

Getting Debug Output
--------------------

The debug level of Guam can be adjusted by editing Guam's configuration file.
Specifically, there is a lager block that looks like this:

.. parsed-literal::

    { lager,
        [
            {
              handlers,
              [
                  { lager_console_backend, info },
                  { lager_file_backend, [ { file, "log/error.log"}, { level, error } ] },
                  { lager_file_backend, [ { file, "log/console.log"}, { level, info } ] }
              ] }
         ] }

This controls the logging behavior of Guam. The lager_*_backend entries define
where and what level of logging is output. The level tuples (e.g.
``{ level, error }``) define the logging level for a specific output (a file,
the console, syslog, etc.) When troubleshooting, it is best to set these to
debug, while the defaults are generally set to info and/or error only.

.. seealso::

    *   :ref:`about-guam-configuration`

You can adjust the logging level of a running system by attaching to Guam with
an erlang shell:

.. parsed-literal::

    $ :command:`erl -sname kolab_guam@<host> -setcookie kolab_guam`

The default value for sname is found in the vm.args file that comes with guam.

At this point you can see which handlers are active with:

.. parsed-literal::

    gen_event:which_handlers(lager_event).

You can add handlers (e.g. for debug output) with:

.. parsed-literal::

    gen_event:add_handler(lager_event, {lager_file_backend, "debug.log"},
                                       {"debug.log", debug, 0485760, "$D0", 5}).

which will create a :file:`debug.log` file in the local directory erl was
started from.

Handlers may be removed (such as when finished with debugging) with a call to
``gen_event:delete_handler``, such as:

.. parsed-literal::

    gen_event:delete_handler(lager_event,  {lager_file_backend, "debug.log"},
                                           {"debug.log", debug, 0485760, "$D0", 5}).

Alternatively, one can simply change the configuration in the config file and
restart Guam.

Once debug output is being produced, it becomes quite a bit easier to track
client connections, drops, etc.

Live Monitoring
---------------

After connecting to a runnign Guam session (e.g. using the ``erl`` command from
:ref:`about-guam-troubleshooting-getting-debug-output` above), a graphical
monitor of the Guam system can be invoked with:

.. parsed-literal::

    1> observer:start().

This tool can be run remotely by starting erl on a system with a window
manager, which many servers do not have running, and gives access to system
setup, resource usage, load charts, running Erlang processes, and trace access.

The process tree should show the **kolab_guam** application with its tree of
listeners rooted to the **kolab_guam_sup** process, and each listener with a
span of child processes which are the actual connection handler pool processes.

The observer is a quick an easy way to get an overview of the system in
operation the server) and 

Crashes
-------

Guam is written in Erlang, and in Erlang errors are handled by letting the task
that experienced the error to "crash". Most other langauges/runtimes do not
have this concept, instead relying on exceptions to handle fatal errors.
Crashes are, however, completely normal in Erlang applications and are as
important a mechanism to maintaining a properly functioning system are
exceptions are in other languages. Do not fear the crash!

So if you see "crashes", but Guam is continuing to operate correctly, then the
crash is almost certainly due to a valid error condition in which the correct
response is to stop the current object/task that is running.

This may occur, for instance, if the IMAP server connection is lost or can not
be established. In that case, the IMAP connection task will crash, and that
will in turn bubble up to the client connection being maintain by Guam which
will itself stop (and clean up after itself).

However, when unexpected problems occur, there may also be crashes. They will
be kept in the :file:`crash.log` and will show both the exact reason for the
crash along with a stack trace through the code that led up to the crash.

Including those crash reports in bug reports is extremely important, as they
contain vital troubleshooting data. You may also read through the stack traces
yourself during troubleshooting sessions to see where problems are occuring,
as the code has been written with easy to understand naming conventions for
functions and variables.

IMAP Services
-------------

As its most basic functonality, Guam acts as a proxy service between the IMAP
client and the IMAP server. If connections are not being made (turning on debug
output as outlined above can help identify these sorts of issues), check the
application configuration.

Common sources of errors:

*   the Guam listener is listening on the wrong port/host/interface
*   the Guam listener is connecting to the wrong ``imap_server`` configuration
*   the imap_server configuration is incorrect
*   the TLS settings on the listener are incorrect

To test each, use a tool such as imtest (a command line tool that "speaks"
IMAP) to connect to the imap_server from the machine Guam is running on, using
the ports, hostname and TLS settings in the imap_server configuration.

If the IMAP server picks up as expected, including TLS settings, then this is
not the source of the issue. Next, use **imtest** to connect to the Guam
listener's port, hostname and TLS setting(s) from a different machine that can
reach the system Guam is running on, such as a laptop on the same network.

Simple connect testing with **imtest** will quickly show the problematic
configuration. If Guam is not connecting and the configuration is indeed
correct, please file a bug report noting the configuration options in both the
``imap_server`` and ``listener`` configuration, along with other relevant
information (e.g. does it accept connections for a while then stop doing so,
and start accepting again on restart?).

Rules
-----

Individual rules operate separately from each other, though they may be
chained. If a rule set is not behaving as expected, first try to run a Guam
listener with each individual rule in the chain on its own and validate that
each rule on its own is performing as expected.

If this resolves the issue to a specific rule, then next check the confguration
for the rule in the Guam config file to ensure the rule is properly configured.
If it is, then it is appropriate to file a bug report describing the issue
along with sample configuration.

If each rule works on its own, start combining the rules in a chain, adding one
rule at a time until the problem manifests. A bug should then be filed noting
the specific rule chain, configuration and problem behavior.

Specific rules are covered individually below.

Rule: ``filter_groupware``
``````````````````````````

The ``filter_groupware`` rule attempts to remove all folders containing
groupware data (calendars, contacts, notes, todos, etc.) from folder list
commands. It does not prevent access to those folders, it simply prevents
advertising them to IMAP clients.

If this is not working, first check Guam's configuration, ensuring that exactly
one "rules" block exists in the listener block defining the port being
connected to. Pay specific attention to the host/port settings (to ensure this
is indeed the listener that is misbehaving), and check for a rules block
similar to:

.. parsed-literal::

    { rules, [ { filter_groupware, [] } ] }

To see the groupware folders (which Kolab-aware clients generally need to), the
client must advertise itself as a Kolab client with an IMAP ID command prior
to performing a LIST command that results in a folder list. This ID must
include a "user agent" string containing the substring "/Kolab". Example would
be: "Kontact/Kolab". So if folders are being filtered for a client when it
should not be, first check what the client in question advertises itself as.

If folders are not being filtered, check that the
``/shared/vendor/kolab/folder-type`` metadata key is set on the folders in
question. If it is not, then Guam will not filter them out.

If no issues are found with configuration or client, please file a bug report
noting the issue.
