
import os
import sys

def compile(source, opts, gcc='gcc'):
    o = mktmp('.o')
    easyrun(gcc, '-o', o, opts, source)
    return o

def link_so(inputs, opts, gcc='gcc'):
    so = mktmp('.so')
    easyrun(gcc '-shared', '-o' so, opts, inputs)
    return so

def build_so(sources, opts, gcc='gcc'):
    return link_so(compile(sources, opts, gcc), opts, gcc)

def mktmp(ext):
    return 'tmp' + ext

