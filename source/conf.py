# -*- coding: utf-8 -*-
#
# Kolab Groupware documentation build configuration file, created by
# sphinx-quickstart on Tue Jul 16 12:32:13 2013.
#
# This file is execfile()d with the current directory set to its containing dir.
#
# Note that not all possible configuration values are present in this
# autogenerated file.
#
# All configuration values have a default; values that are commented out
# serve to show the default.

import sys, os, glob, imp

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
thisdir = os.path.dirname(os.path.abspath(__file__))
extdir = os.path.abspath(os.path.join(thisdir, '..', 'ext'))

sys.path = [
        extdir
    ] + sys.path

# -- General configuration -----------------------------------------------------

# If your documentation needs a minimal Sphinx version, state it here.
#needs_sphinx = '1.0'

# Add any Sphinx extension module names here, as strings. They can be extensions
# coming with Sphinx (named 'sphinx.ext.*') or your custom ones.
extensions = [
        'sphinx.ext.autodoc',
        'sphinx.ext.extlinks',
        #'sphinx.ext.mathjax',
        'sphinx.ext.todo',
        'sphinx.ext.graphviz',
        'sphinx.ext.ifconfig',
        'kolab.fancyfigure',
        #'kolab.phabricator',
    ]

# fancybox extension config
fancybox_config = {
    'helpers': {
        'title': { 'type': 'inside' }
    }
}

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# The suffix of source filenames.
source_suffix = '.rst'

# The encoding of source files.
#source_encoding = 'utf-8-sig'

# The master toctree document.
master_doc = 'index'

# General information about the project.
project = u'Kolab'

import datetime
copyright = u'2010-%s, Kolab Systems AG' % (datetime.datetime.strftime(datetime.datetime.utcnow(), '%Y'))

# The version info for the project you're documenting, acts as replacement for
# |version| and |release|, also used in various other places throughout the
# built documents.
#
# The short X.Y version.
version = '16'
# The full version, including alpha/beta/rc tags.

#import subprocess
#p1 = subprocess.Popen(['git', 'log', '--oneline'], stdout=subprocess.PIPE)
#p2 = subprocess.Popen(['wc', '-l'], stdin=p1.stdout, stdout=subprocess.PIPE)
#p1.stdout.close()
#(count, errors) = p2.communicate(p1.stdout)
#release = '%s (%s)' % (version, count)
release = ''

# The language for content autogenerated by Sphinx. Refer to documentation
# for a list of supported languages.
language = None

# If true, a document’s text domain is its docname if it is a top-level project file
# and its very base directory otherwise.
# By default, the document markup/code.rst ends up in the markup text domain.
# With this option set to False, it is markup/code.
gettext_compact=False

locale_dirs = ['../locale/']

# There are two options for replacing |today|: either, you set today to some
# non-false value, then it is used:
#today = ''
# Else, today_fmt is used as the format for a strftime call.
#today_fmt = '%B %d, %Y'

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
exclude_patterns = [
        'about/.template/*',
        'webmail-user-guide/roundcubemail-plugins-kolab/*'
    ]

# The reST default role (used for this markup: `text`) to use for all documents.
#default_role = None

# If true, '()' will be appended to :func: etc. cross-reference text.
#add_function_parentheses = True

# If true, the current module name will be prepended to all description
# unit titles (such as .. function::).
#add_module_names = True

# If true, sectionauthor and moduleauthor directives will be shown in the
# output. They are ignored by default.
show_authors = True

# The name of the Pygments (syntax highlighting) style to use.
pygments_style = 'sphinx'

# A list of ignored prefixes for module index sorting.
#modindex_common_prefix = []


# -- Options for HTML output ---------------------------------------------------
#import sphinx_rtd_theme
#html_theme = "sphinx_rtd_theme"
#html_theme_path = [sphinx_rtd_theme.get_html_theme_path()]

html_theme = 'sphinxdoc'
html_theme_path = ['themes']

# The name for this set of Sphinx documents.  If None, it defaults to
# "<project> v<release> documentation".
html_title = 'Kolab Groupware documentation'

# A shorter title for the navigation bar.  Default is the same as html_title.
html_short_title = 'Kolab documentation'

# The name of an image file (relative to this directory) to place at the top
# of the sidebar.
#html_logo = None

# The name of an image file (within the static path) to use as favicon of the
# docs.  This file should be a Windows icon file (.ico) being 16x16 or 32x32
# pixels large.
#html_favicon = None

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

# If not '', a 'Last updated on:' timestamp is inserted at every page bottom,
# using the given strftime format.
html_last_updated_fmt = '%b %d, %Y @ %H:%M'

# If true, SmartyPants will be used to convert quotes and dashes to
# typographically correct entities.
#html_use_smartypants = True

# Custom sidebar templates, maps document names to template names.
#html_sidebars = {}

# Additional templates that should be rendered to pages, maps page names to
# template names.
#html_additional_pages = {}

# If false, no module index is generated.
#html_domain_indices = True

# If false, no index is generated.
#html_use_index = True

# If true, the index is split into individual pages for each letter.
#html_split_index = False

# If true, links to the reST sources are added to the pages.
#html_show_sourcelink = True

# If true, "Created using Sphinx" is shown in the HTML footer. Default is True.
#html_show_sphinx = True

# If true, "(C) Copyright ..." is shown in the HTML footer. Default is True.
#html_show_copyright = True

# If true, an OpenSearch description file will be output, and all pages will
# contain a <link> tag referring to it.  The value of this option must be the
# base URL from which the finished HTML is served.
#html_use_opensearch = ''

# This is the file name suffix for HTML files (e.g. ".xhtml").
#html_file_suffix = None

# Output file base name for HTML help builder.
htmlhelp_basename = 'KolabGroupwaredoc'


# -- Options for LaTeX output --------------------------------------------------

latex_elements = {
# The paper size ('letterpaper' or 'a4paper').
#'papersize': 'letterpaper',

# The font size ('10pt', '11pt' or '12pt').
#'pointsize': '10pt',

# Additional stuff for the LaTeX preamble.
#'preamble': '',
}

# Grouping the document tree into LaTeX files. List of tuples
# (source start file, target name, title, author, documentclass [howto/manual]).
latex_documents = [
  ('index', 'KolabGroupware.tex', u'Kolab Groupware Documentation',
   u'Jeroen van Meeuwen', 'manual'),
]

# The name of an image file (relative to this directory) to place at the top of
# the title page.
#latex_logo = None

# For "manual" documents, if this is true, then toplevel headings are parts,
# not chapters.
#latex_use_parts = False

# If true, show page references after internal links.
#latex_show_pagerefs = False

# If true, show URL addresses after external links.
#latex_show_urls = False

# Documents to append as an appendix to all manuals.
#latex_appendices = []

# If false, no module index is generated.
#latex_domain_indices = True


# -- Options for manual page output --------------------------------------------

# One entry per manual page. List of tuples
# (source start file, name, description, authors, manual section).
man_pages = [
    ('index', 'kolabgroupware', u'Kolab Groupware Documentation',
     [u'Jeroen van Meeuwen'], 1)
]

# If true, show URL addresses after external links.
#man_show_urls = False


# -- Options for Texinfo output ------------------------------------------------

# Grouping the document tree into Texinfo files. List of tuples
# (source start file, target name, title, author,
#  dir menu entry, description, category)
texinfo_documents = [
  ('index', 'KolabGroupware', u'Kolab Groupware Documentation',
   u'Jeroen van Meeuwen', 'KolabGroupware', 'One line description of project.',
   'Miscellaneous'),
]

# Documents to append as an appendix to all manuals.
#texinfo_appendices = []

# If false, no module index is generated.
#texinfo_domain_indices = True

# How to display URL addresses: 'footnote', 'no', or 'inline'.
#texinfo_show_urls = 'footnote'


# -- Options for Epub output ---------------------------------------------------

# Bibliographic Dublin Core info.
epub_title = u'Kolab Groupware'
epub_author = u'Jeroen van Meeuwen'
epub_publisher = u'Jeroen van Meeuwen'
epub_copyright = u'2013-2016, Jeroen van Meeuwen'

# The language of the text. It defaults to the language option
# or en if the language is not set.
#epub_language = ''

# The scheme of the identifier. Typical schemes are ISBN or URL.
#epub_scheme = ''

# The unique identifier of the text. This can be a ISBN number
# or the project homepage.
#epub_identifier = ''

# A unique identification for the text.
#epub_uid = ''

# A tuple containing the cover image and cover page html template filenames.
#epub_cover = ()

# HTML files that should be inserted before the pages created by sphinx.
# The format is a list of tuples containing the path and title.
#epub_pre_files = []

# HTML files shat should be inserted after the pages created by sphinx.
# The format is a list of tuples containing the path and title.
#epub_post_files = []

# A list of files that should not be packed into the epub file.
#epub_exclude_files = []

# The depth of the table of contents in toc.ncx.
#epub_tocdepth = 3

# Allow duplicate toc entries.
#epub_tocdup = True

todo_include_todos = True

# -- Load variables for client configuration docs -----------------------------

variables = {}
default_tags = []
custom_tags = False

tags = set()

config_files = glob.glob('./*/conf.py')

if os.path.exists('./conf.local.py'):
    config_files.append(os.path.relpath('./conf.local.py'))

# collect variables from submodule configs
for pathname in config_files:
    try:
        conf = imp.load_source('conf', pathname)
        if hasattr(conf, 'variables'):
            variables.update(conf.variables)
        if hasattr(conf, 'tags'):
            custom_tags = True
            for tag in conf.tags:
                tags.add(tag)
        if hasattr(conf, 'module_tags'):
            default_tags += conf.module_tags
        if hasattr(conf, 'extensions'):
            extensions += conf.extensions
        # TODO: merge other config options like rst_prolog, rst_epilog, etc.
    except Exception, e:
        print "Failed to open config file", pathname
        print e

# add default tags if no custom ones defined
if not custom_tags:
    for tag in default_tags:
        tags.add(tag)

# add variables as substitutions to the head of each page
rst_prolog = ""
for var, repl in variables.items():
    rst_prolog += "    .. |%s| replace:: %s\n" % (var, repl)
    rst_prolog += "    .. |**%s**| replace:: **%s**\n" % (var, repl)


# forward variables for substitutions in fancyfigures
fancyfigure_variables = variables

extlinks = {
        'rfc': ('http://tools.ietf.org/html/rfc%s', 'RFC '),
        'mock': ('https://git.kolab.org/T%s', 'Mock #'),
        'task': ('https://git.kolab.org/T%s', 'Task #'),
    }

rst_prolog += """
.. _Architecture & Design: https://git.kolab.org/tag/architecture_design/
.. _bugzilla: https://issues.kolab.org/
.. _current sprint: https://git.kolab.org/tag/sprint_current/
.. _next sprint: https://git.kolab.org/tag/sprint_next/
.. _DAVDroid: http://davdroid.bitfire.at/what-is-davdroid
.. _DAVDroid from Google Play: https://play.google.com/store/apps/details?id=at.bitfire.davdroid
.. _Differential: https://git.kolab.org/differential/
.. _Diffusion: https://git.kolab.org/diffusion/
.. _Drydock: https://git.kolab.org/drydock/
.. _EPEL for Enterprise Linux 6: http://download.fedoraproject.org/pub/epel/6/x86_64/repoview/epel-release.html
.. _EPEL for Enterprise Linux 7: http://download.fedoraproject.org/pub/epel/7/x86_64/repoview/epel-release.html
.. _F-Droid app repository: https://f-droid.org/repository/browse/?fdid=at.bitfire.davdroid
.. _Harbormaster: https://git.kolab.org/harbormaster/
.. _Herald: https://git.kolab.org/herald/
.. _Kolab Systems AG: https://kolabsystems.com
.. _Maniphest: https://git.kolab.org/maniphest/
.. _Phabricator: https://git.kolab.org/
.. _Process Managers: https://git.kolab.org/tag/process_managers/
.. _Product Owners: https://git.kolab.org/tag/product_owners/
.. _Projects: https://git.kolab.org/projects/
.. _Quality Assurance: https://git.kolab.org/tag/quality_assurance/
.. _Report a bug: https://git.kolab.org/maniphest/task/edit/form/9/
.. _Scrum: http://en.wikipedia.org/wiki/Scrum_%28software_development%29
.. _Scrum Masters: https://git.kolab.org/tag/process_managers/
.. _Sprints: https://git.kolab.org/project/sprint/
.. _Why Your System Should Have a Proper FQDN: https://kanarip.wordpress.com/2016/02/04/why-your-system-requires-a-proper-fqdn/
"""

rst_prolog += """
.. role:: blue
.. role:: gray
.. role:: green
.. role:: orange
.. role:: red
"""

#
# Releases
#
rst_prolog += """
.. |Winterfell| replace:: :orange:`Winterfell`
.. |K16| replace:: :orange:`Kolab 16`
.. |KE14| replace:: :orange:`Kolab Enterprise 14`
.. |KE13| replace:: :orange:`Kolab Enterprise 13`
.. |ReleaseProduction| replace:: :orange:`Kolab 16.1`
.. |ReleaseCurrent| replace:: :orange:`Kolab 16.1`
"""

#
# Target platforms
#
rst_prolog += """
.. |maipo| replace:: :gray:`Maipo`
.. |santiago| replace:: :gray:`Santiago`
"""

#
# Packages
#
rst_prolog += """
.. |roundcubemail| replace:: :blue:`roundcubemail`
.. |roundcubemail-plugins-kolab| replace:: :blue:`roundcubemail-plugins-kolab`
"""
