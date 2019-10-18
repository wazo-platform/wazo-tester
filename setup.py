#!/usr/bin/env python3
# Copyright 2019 The Wazo Authors  (see the AUTHORS file)
# SPDX-License-Identifier: GPL-3.0-or-later

import setuptools
from setuptools import find_packages

with open('README.md') as f:
    readme = f.read()

with open('LICENSE') as f:
    license = f.read()

setuptools.setup(
    name='wazotester',
    version='1.0',
    author='Wazo Authors',
    author_email='dev@wazo.community',
    description='Wazo Router Server Daemon',
    long_description=readme,
    long_description_content_type="text/markdown",
    license=license,
    url='http://www.wazo-platform.org/',
    install_requires=[
        'Click>=7.0',
        'PyYAML>=3.13',
        'dotty-dict>=1.2.1',
        'requests>=2.22.0',
    ],
    packages=find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: GNU General Public License v3 or later (GPLv3+)",
        "Operating System :: OS Independent",
    ],
    entry_points={'console_scripts': ['wazotester=wazotester:wazotester']},
)
