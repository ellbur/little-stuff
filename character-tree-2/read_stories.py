# -*- coding: utf-8 -*-

import os

def read_stories(path):
    filenames = os.listdir(path)
    
    return [
        read_story(path + '/' + filename)
        for
            filename in filenames
    ]

def read_story(path):
    f = open(path, 'r')
    text = f.read()
    f.close()
    
    return text

