#!/usr/bin/env python
# -*- coding: utf-8 -*-

# regenerate presentation files for browser access and exit,
# expects only a class-name argument

import os
import shutil
import SimpleHTTPServer
import SocketServer
import sys


BASE = '/opt/revealjs/'
PRES = BASE + 'src/presentations'
MODS = BASE + 'src/modules'
TEMPLATE = BASE + 'templates/index.html'
INDEX = BASE + 'index.html'
SECTION = '''
                <section data-markdown="src/modules/{0}/slides.md"
                     data-separator="^\\n---\\n"
                     data-separator-vertical="^\\n----\\n"
                     data-separator-notes="^Note:"
                     data-charset="iso-8859-15">
                </section>
'''


def check_custom():
    """Check and adjust for a custom repository"""
    if os.path.exists('/tmp/src'):
        shutil.rmtree(BASE + 'src')
        shutil.copytree('/tmp/src', BASE + 'src')


def create_html(answer):
    """Create index.html"""

    slides = ""
    with open(os.path.join(PRES, answer)) as mods:
        modules = mods.readlines()
    for module in modules:
        if not module.strip() or module.startswith("#"):
            continue
        module = module.strip()
        if os.path.exists(os.path.join(MODS, module, "slides.html")):
            with open (os.path.join(MODS, module, 'slides.html'), "r") as f:
                html=f.read()
                slides += html
        else:
            slides += SECTION.format(module)


    with open (TEMPLATE, "r") as t:
        template=t.read().replace('---modules---', slides)
    with open(INDEX, "w") as html:
        html.write(template)


def adjust_image_paths(answer):
    """Adjust image paths in slides.md
       When running the web server the paths are relative to index.html instead of the markdown file
    """

    with open(os.path.join(PRES, answer)) as mods:
        modules = mods.readlines()
    for module in modules:
        if not module.strip() or module.startswith("#"):
            continue
        module = module.strip()
        if os.path.exists(os.path.join(MODS, module, 'slides.html')):
            current = 'slides.html'
        else:
            current = 'slides.md'
        with open(os.path.join(MODS, module, current), 'r') as slides:
            file=slides.read().replace('images/', 'src/modules/' + module + '/images/')
        with open(os.path.join(MODS, module, current), 'w') as slides:
            slides.write(file)



if __name__ == '__main__':

    presentation = sys.argv[1]

    check_custom()
    adjust_image_paths(presentation)

    create_html(presentation)

    print "Updating presentation '{0}' ...".format(presentation)

