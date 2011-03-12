def sload(name):
	os.system('sage -preparse "{0}".sage'.format(name))
	_ip.magic('run -i {0}'.format(name))

