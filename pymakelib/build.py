
from scooter import *
from scooter.llvm import *

here = main_file(__file__)

builddir = here / 'build'
srcdir = here / 'src'

sources = srcdir//'**'//'*.cpp' + srcdir//'**'//'*.c'
bin = builddir / 'main'

build = BuildHere(verbose=False).watching(srcdir)

link = '/usr/lib/llvm-3.0/bin/llvm-link'
opt = '/usr/lib/llvm-3.0/bin/opt'
llc = '/usr/lib/llvm-3.0/bin/llc'

def main():
    llvm_build_to_c(build, sources, builddir/'all.c',
        link=link, opt=opt, llc=llc)
    
do_build(main)

