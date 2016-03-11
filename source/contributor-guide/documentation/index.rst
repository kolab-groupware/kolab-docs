.. _contributor-guide-documentation:

=================================
Contributing to the Documentation
=================================

This documentation can easily be contributed to by cloning the following git
repository.

    https://git.kolab.org/diffusion/D/docs.git

.. IMPORTANT::

    The documentation is only as good as your willingness to contribute
    to it.

Other documentation included here:

.. toctree::
    :maxdepth: 1

    writing-documentation
    todolist

Building the Documentation
==========================

Most of our more regular contributors clone the repository to their
local workstation, and then build the documentation before pushing back
changes to their fork of kolab-docs. To build the documentation, you
need to have `Sphinx`_ installed. You can also find some hints, tips and
tricks on their website, with regards to the `reStructuredText`_ format
the documentation is written in.

#.  Naturally, first clone the git repository.

    .. parsed-literal::

        $ :command:`git clone https://git.kolab.org/diffusion/D/docs.git`

#.  Navigate in to the fresh clone:

    .. parsed-literal::

        $ :command:`cd docs`

#.  To build the documentation, issue the following command:

    .. parsed-literal::

        $ :command:`make html`

#.  Make some changes, and build and view the result:

    .. parsed-literal::

        $ :command:`make html`
        $ :command:`xdg-open build/html/index.html`

#.  When you are satisfied, commit the results and submit a `Differential`_:

    .. parsed-literal::

        $ :command:`git commit -a`
        $ :command:`arc diff`

#.  Push your changes back into our Phabricator instance.
    Timotheus wrote `a good tutorial on how to do that <http://www.pokorra.de/2015/07/submitting-patches-to-kolab-via-phabricator/>`_.

Enjoy and thanks for contributing to Kolab!

.. _Sphinx: http://sphinx-doc.org/
.. _reStructuredText: http://sphinx-doc.org/rest.html
.. _Working with Git Submodules: http://git-scm.com/book/en/Git-Tools-Submodules
.. _docs.kolab.org: https://docs.kolab.org

