========
Building
========

Build Requirements
==================

The following requirements need to be fulfilled to build Guam:

.. include:: rpm-buildrequires.txt

Build Instructions
==================

.. parsed-literal::

    $ :command:`rebar compile -v`
    $ :command:`rebar eunit -v`
    $ :command:`cd rel/`
    $ :command:`rebar generate -v`
