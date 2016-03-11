.. _dev-writing-documentation:

=====================
Writing Documentation
=====================

The Kolab community has a reference implementation of its releases,
which can best be described as a **next-next-finish** installation [#]_
of a **single node** [#]_ running **Enterprise Linux 7** [#]_.

For writing documentation, this means that all documented commands and
file paths mentioned need to match that specific implementation [#]_ of
Kolab installed on Enterprise Linux 7, and that every HOWTO needs to
start at the aforementioned *null* situation.

This sounds harsh, and it probably is, but here's how you can work with
it:

*   When you create a HOWTO for something on Debian, your HOWTO should
    probably be titled: *HOWTO: Achieve Greatness (on Debian Wheezy)*.

*   When you do write a generic HOWTO, you can re-iterate the commands
    issued for different distributions::

        After changing the configuration, restart the service:

        .. parsed-literal::

            # :command:`systemctl restart postfix`

        On Debian Wheezy, execute the following instead:

        .. parsed-literal::

            # :command:`/etc/init.d/postfix restart`

.. rubric:: Footnotes

.. [#]

    This means to confirm the default settings (other than perhaps the
    passwords) during :ref:`installation-guide-setup-kolab`, including but not
    limited to the characters used in the passwords chosen -- while we
    have learned of issues when using passwords with special characters,
    which relate to third party application defaults.

.. [#]

    A single node is a single operating system instance; physical,
    virtual, docked or contained.

.. [#]

    In the family of Enterprise Linux 7 distributions that we provide
    packages for are Red Hat Enterprise Linux and CentOS.

.. [#]

    The specific implementation is a single-node deployment topology.
