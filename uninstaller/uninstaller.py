
from __future__ import print_function

import sys
import os
import re
from pytools import flatten

def uninstall_from_make_output(text):
    lines = re.split(r'(\n|\&\&)', text)
    lines = [
        re.sub(r'(^\s+|\s+$)', '', line)
        for line in lines
        if re.search(r'\/usr\/bin\/install',  line) != None
    ]
    lines = [
        line for line in lines
        if re.search(r'\-d', line) == None
    ]
    paths = flatten(map(install_paths, lines))
    
    for path in paths:
        print(path)
        print(os.path.exists(path))
        print(os.path.isfile(path))
        if os.path.isfile(path):
            os.unlink(path)

def install_paths(str):
    tokens = re.split(r'\s+', str)
    prefix = tokens[-1]
    rests = tokens[3:-1]
    return [prefix + '/' + os.path.basename(rest)
        for rest in rests]


