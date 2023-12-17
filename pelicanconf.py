#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals
import sys

sys.path.append('.')

AUTHOR = 'Kenneth'
SITENAME = 'hella labs'
SITESUBTITLE = 'helpful findings and tech musings'
QUOTE = 'Reality is that which, when you stop believing in it, doesn\'t go away.'
QUOTED = 'Philip K. Dick'
SITEURL = ''
FOOTNOTE = ''
CONTACT_URL = '/pages/about.html'

MASTODON_SITE_VERIFICATION = 'https://mastodon.online/@qrkourier'

PATH = 'content'

#TIMEZONE = 'America/New_York'
TIMEZONE = 'GMT'

DEFAULT_LANG = 'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = ()

# Social widget
SOCIAL = ()
#    ('github', 'https://github.com/qrkourier'),
#    ('mastodon', 'https://mastodon.online/@qrkourier'),
#    ('linktree', 'https://linktr.ee/qrkourier'),
#    ('keybase', 'https://keybase.io/kourier'),
#)

MENUITEMS = (
  # ('Home', '/'),
)

DEFAULT_PAGINATION = False

# Uncomment following line if you want document-relative URLs when developing
# RELATIVE_URLS = True

PAGE_ORDER_BY = 'basename'

PAGE_PATHS = [
  'pages'
]

STATIC_PATHS = [
    'blob',
    'keybase.txt'
]

EXTRA_PATH_METADATA = {
#     'blob/robots.txt': {'path': 'robots.txt'},
    'blob/favicon.ico': {'path': 'favicon.ico'},
}

USE_FOLDER_AS_CATEGORY = False
DEFAULT_CATEGORY = 'Tech'

STATIC_EXCLUDE_SOURCES = False
ARTICLE_EXCLUDES = ['blob']
PAGE_EXCLUDES = ['blob']



DEFAULT_DATE = 'fs'

DIRECT_TEMPLATES = ['index', 'categories', 'archives']

# THEME = './theme-html5up'
# THEME = './theme-notmyidea-tld'
THEME = './theme-attila'
THEME_STATIC_DIR = '.'
THEME_STATIC_PATHS = ['static']

HOME_COVER = 'https://github.com/qrkourier/qrkourier.github.io/assets/1434400/e6b42272-75b0-4b3c-8ab8-2a23be94d45f'
HOME_COLOR = 'black'
CATEGORY_META = {
  'tech': {
    'cover': 'https://github.com/qrkourier/qrkourier.github.io/assets/1434400/2dc392fc-9fc5-4b12-a22d-2633a958c53c',
    'description': 'solutions and musings',
  }
}
TAG_META = {
  'food': {
    'cover': '/images/food.png',
    'description': 'Examples ipsum dolor sit amet. Topping'
  },
  'drinks': {
    'cover': '/images/orange-juice.png',
    'description': 'Examples ipsum dolor sit amet. Juice'
  }
}

AUTHOR_META = {
  "kenneth": {
    "name": "Kenneth Bingham",
    "image": "https://github.com/qrkourier/qrkourier.github.io/assets/1434400/a8155877-b78a-4ba0-895f-9396777f8b82",
    "website": "https://linktr.ee/qrkourier",
    "location": "United States",
    "bio": "An American computer engineer living in the United States. ",
  }
}

PLUGIN_PATHS = [
  'pelican-plugins'
]

PLUGINS = [
  'neighbors',
  'minification',
  'webassets',
  'sitemap',
]

SHOW_ARTICLE_MODIFIED_TIME = False
SHOW_AUTHOR_BIO_IN_ARTICLE = True
SHOW_CATEGORIES_ON_MENU = True
SHOW_PAGES_ON_MENU = True
SHOW_COMMENTS_COUNT_IN_ARTICLE_SUMMARY = False
SHOW_CREDITS = False
SHOW_FULL_ARTICLE_IN_SUMMARY = False
SHOW_SITESUBTITLE_IN_HTML_TITLE = True
SHOW_TAGS_IN_ARTICLE_SUMMARY = False

# 'extract_toc'

# import jinja_filter_sidebar
# JINJA_FILTERS = {'sidebar': jinja_filter_sidebar.sidebar}

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
