# -*- coding: utf-8 -*-

def sorti(L, comp):
	
	Ind = range(len(L))
	
	def icomp(i1, i2):
		l1 = L[i1]
		l2 = L[i2]
		
		return comp(l1, l2)
	
	Ind.sort(icomp)
	
	Rev_Ind = [ None ] * len(L)
	for i in range(len(L)):
		Rev_Ind[Ind[i]] = i
	
	return (Ind, Rev_Ind)
