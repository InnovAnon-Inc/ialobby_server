#! /usr/bin/env python
# -*- coding: utf-8 -*-

from setuptools import setup, Extension, find_packages
from Cython.Build import cythonize

extensions = [
    Extension(
        "ialobby.*",
        sources=["src/ialobby/*.pyx"],
        language="c++"
    )
]

setup(
    ext_modules=cythonize(extensions),
    packages=["ialobby"],
    package_dir = {
        'ialobby' : 'src/ialobby',
    },
    package_data={
        '': ['*.so'],
    },
    exclude_package_data={
        '': ['*.cpp', '*.pyx',]
    }
)

