Kolab Groupware Documentation
=============================

This repository contains the sources for Kolab Groupware documentation.

For more information about the Kolab Groupware Solution, please see https://kolab.org.

The built documentation is available for reading at https://docs.kolab.org.

Contributing Documentation
--------------------------

Contributions to the Kolab Groupware Documentation are both appreciated and encouraged.

The documentation is based on the [Sphinx Documentation Generator][sphinx] and
source files are written in [reStructuredText (reST)][reST] which is very easy to learn.

Volunteers who want to help with documenting aspects of Kolab are encouraged to [fork][github-fork] this repository
and add their content or correct existing content.
Once finished, please send us a [pull request][github-pull] via GitHub.

If you want to increase the chances of your pull request being accepted,
you can write a short email to [Kolab's development list][kolab-devel] stating what you plan on doing.
The members of the Kolab.org community will then either propose improvements,
encourage you to go ahead or even help you with your contributions.

It is recommened to test your changes before making a pull request, by building the HTML files yourself.
Please read further down for how to do this.

Translating
-----------

We would like to make Kolab available and accessible to everybody regardless of language spoken.
Therefore, we encourage people to translate this documention into as many languages as possible.
If you want to help with this, please read on.

The Kolab Groupware Documentation is translated via Transifex.
If you do not have a Transifex account already, please [register one][transifex-register] for yourself.
Then navigate to the **[Kolab Documentation at Transifex][transifex-kolab]**.
  
You will find that the documentation is translated into many languages already.
If your language is in the list, please click it and apply for membership in this language team.
If the documentation is not yet translated into your language, you can apply for a new team to be started.
These requests should take the maintainers not more than a few days to accept.
Usually, you are approved a lot quicker than that. Please be patient.

Using Transifex is really easy.
Should you still have problems to understand one thing or the other,
the [Transifex Translator Guide][transifex-guide] might help you to get up to speed more quickly.

[![Translation Statistics][transifex-stats]][transifex-kolab]

Generating HTML Files
---------------------

First of all you need Python and [Sphinx][sphinx] installed. Grab the latest version of Sphinx with

	sudo easy_install -U Sphinx

This repo already contains the Sphinx project configuration and can be generated
right away with the following command:

	make html

The above example generates HTML online documentation with English localization
for the Kolab Documentation.
The HTML files can now be found in the `build/html/` output directory.
Please make sure that your changes do not introduce new warnings or errors during the build process.


[sphinx]: http://sphinx-doc.org
[github-fork]: https://help.github.com/articles/fork-a-repo
[github-pull]: https://help.github.com/articles/using-pull-requests
[transifex-register]: https://www.transifex.com/signup
[reST]: http://sphinx-doc.org/rest.html
[kolab-devel]: https://lists.kolab.org/mailman/listinfo/devel
[transifex-guide]: http://docs.transifex.com/guides/translators
[transifex-kolab]: https://www.transifex.com/projects/p/kolab-documentation
[transifex-stats]: https://www.transifex.com/projects/p/kolab-documentation/chart/image_png
