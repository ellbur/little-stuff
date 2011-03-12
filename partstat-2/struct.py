# -*- coding: utf-8 -*-

def struct(*args):
	
	def dec(Class):
		
		class Dec: pass
		
		for m in Class.__dict__:
			Dec.__dict__[m] = Class.__dict__[m]
		
		def dec_init(self, *vals):
			
			if len(vals) != len(args):
				raise TypeError('takes {0} argument, {1} given'.format(
					len(args), len(vals)
				))
			
			for i in range(len(vals)):
				Dec.__dict__[args[i]] = vals[i]
		
		Dec.__init__ = dec_init
		
		return Dec
	
	return dec
