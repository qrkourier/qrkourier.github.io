#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals
import sys
sys.path.append('.')

AUTHOR = 'Ken'
SITENAME = 'hella labs'
TAGLINE = 'yet another thought garden'
QUOTE = 'Reality is that which, when you stop believing in it, doesn\'t go away.'
QUOTED = 'Philip K. Dick'
SITEURL = ''
# CONTACT_URL = '/pages/about.html'

PATH = 'content'

TIMEZONE = 'America/New_York'

DEFAULT_LANG = 'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = (('Pelican', 'http://getpelican.com/'),
         ('Python.org', 'http://python.org/'),
         ('Jinja2', 'http://jinja.pocoo.org/'),
         ('You can modify those links in your config file', '#'),)

# Social widget
SOCIAL = (
    ('github', 'https://github.com/qrkourier'),
    ('mastodon', 'https://mastodon.online/@qrkourier'),
    ('twitter', 'https://twitter.com/qrkourier'),
    ('reddit', 'https://www.reddit.com/user/bingnet'),
    ('keybase', 'https://keybase.io/kourier'),
)

MENUITEMS = ()

DEFAULT_PAGINATION = False

# Uncomment following line if you want document-relative URLs when developing
RELATIVE_URLS = True

PAGE_PATHS = [
  'pages'
]
STATIC_PATHS = [
    'blob'
]
STATIC_EXCLUDE_SOURCES = False

DEFAULT_DATE = 'fs'

DIRECT_TEMPLATES = ['index', 'categories', 'archives']

THEME = './pelican-themes-frankv-twenty-pelican-html5up'
THEME_STATIC_DIR = '.'
THEME_STATIC_PATHS = ['static']


PLUGIN_PATHS = ["plugins", "../pelican-plugins"]
PLUGINS = [
    'neighbors',
    'minification',
    'assets'
]
#'extract_toc'

import jinja_filter_sidebar
JINJA_FILTERS = { 'sidebar': jinja_filter_sidebar.sidebar }

DISPLAY_PAGES_ON_MENU = True

MARKDOWN = {
  'extension_configs': {
    'markdown.extensions.toc': {
      'title': 'Table of contents:'
    },
    'markdown.extensions.codehilite': {'css_class': 'highlight'},
    'markdown.extensions.extra': {},
    'markdown.extensions.meta': {},
  },
  'output_format': 'html5',
}
