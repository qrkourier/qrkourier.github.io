#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals
import sys
sys.path.append('.')

AUTHOR = 'Ken'
SITENAME = 'hella labs'
TAGLINE = 'yet another thought garden'
QUOTE = 'Until you make the unconscious conscious, it will direct your life and you will call it fate.'
QUOTED = 'Carl Gustav Jung'
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
SOCIAL = (('You can add links in your config file', '#'),
          ('Another social link', '#'),)

DEFAULT_PAGINATION = False

# Uncomment following line if you want document-relative URLs when developing
RELATIVE_URLS = True

STATIC_PATHS = [
    'blob'
]

DEFAULT_DATE = 'fs'

DIRECT_TEMPLATES = ['index', 'categories', 'archives']

THEME = '../pelican-themes-frankv-twenty-pelican-html5up'
THEME_STATIC_DIR = '.'
THEME_STATIC_PATHS = ['static']


PLUGIN_PATHS = ["plugins", "../pelican-plugins"]
PLUGINS = [
    'neighbors',
]
#'minification',

import jinja_filter_sidebar
JINJA_FILTERS = { 'sidebar': jinja_filter_sidebar.sidebar }

DISPLAY_PAGES_ON_MENU = True
