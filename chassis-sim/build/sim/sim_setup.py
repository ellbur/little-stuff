

from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

import glob

name    = 'sim'
sources = ['sim.pyx']
root    = '/home/owen/src/little-stuff/chassis-sim'
objects = glob.glob(root + '/build/user_code/*.o')
include = [root + '/user_code', root + '/sim']

setup(
	name        = 'simulation layer',
	cmdclass    = {'build_ext': build_ext },
	ext_modules = [Extension(
		name,
		sources,
		extra_objects = objects,
		include_dirs  = include )]
)

