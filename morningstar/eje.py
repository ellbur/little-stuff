#!/usr/bin/python
# -*- coding: utf-8 -*-

from sys import *
import re

##
#

header = stdin.readline()
header = header.split('\t')

R = int(header[0])
C = int(header[1])

cost = [ [ None ] * C for i in range(R) ]

for i in range(R):
	row_str = stdin.readline()
	strs = row_str.split('\t')
	
	for j in range(C):
		cost[i][j] = int(strs[j])

# Get initial guess

path = [ None  ] * (R-1)

pair_costs = [ None ] * (R-1)
for i in range(R-1):
	pair_costs[i] = [ cost[i][j] + cost[i+1][j] for j in range(C) ]

def move_cost(i, j):
	return cost[i][j] + cost[i+1][j]

def sort_agenda(agenda, i):
	agenda.sort(lambda j1, j2:
		move_cost(i, j1) - move_cost(i, j2)
	)

for i in range(0, R-1):
	if i==0:
		cur = 0
	else:
		cur = path[i-1];
	
	agenda = [ j for j in range(C) if j != cur ]
	sort_agenda(agenda, i)
	
	best_j = agenda[0]
	
	path[i] = best_j

# Now we need to improve it

def assess(path):
	total = cost[0][0]
	
	for i in range(R-1):
		j = path[i]
		total += cost[i][j] + cost[i+1][j]
	
	if path[len(path)-1] != C-1:
		total += cost[R-1][C-1]
	
	return total

# Identify candidates for improvement

def messup(path, i):
	# Only switch if there is a fast gain
	
	anyok = 0
	okj = -1
	j1 = path[i]
	
	for j2 in range(C):
		if move_cost(i, j2) < move_cost(i, j1):
			okj = j2
			anyok = True
			break
	
	if not anyok:
		return path
	
	# Now some recursive troubleness
	
	messed = work_around(path, i, okj)
	if messed == None:
		return path
	
	return messed

def work_around(path, i, okj):
	
	if i == 0 and okj == 0:
		return None
	
	up_fix = work_around_up(path, i, okj)
	dn_fix = work_around_dn(path, i, okj)
	
	if (up_fix == None) or (dn_fix == None):
		return None
	
	return up_fix[0:i] + dn_fix[i:]

def work_around_up(path, i, okj):
	
	work = [ j for j in path ]
	work[i] = okj
	
	if i == 0 and okj != 0:
		return work
	
	if i == 0:
		return None
	
	agenda = [ j for j in range(C) if j!=okj ]
	sort_agenda(agenda, i-1)
	
	for k in range(len(agenda)):
		
		work_better = work_around_up(work, i-1, agenda[k])
		if work_better != None:
			return work_better
		else:
			pass
	
	return None

def work_around_dn(path, i, okj):
	
	work = [ j for j in path ]
	work[i] = okj
	
	if i == R-2:
		return work
	
	agenda = [ j for j in range(C) if j!=okj ]
	sort_agenda(agenda, i+1)
	
	for k in range(len(agenda)):
		
		work_better = work_around_dn(work, i+1, agenda[k])
		if work_better != None:
			return work_better
	
	return None

def improve_by_tweaking(path):
	
	for i in range(1, R-1):
		
		messed = messup(path, i)
		
		if assess(messed) < assess(path):
			return messed
	
	return None

while 1:
	improve = improve_by_tweaking(path)
	
	if improve != None:
		path = improve
	else:
		break

print('0 0 {0}'.format(cost[0][0]))
for i in range(len(path)):
	print('{0} {1} {2}'.format(
		i, path[i], cost[i][path[i]]
	))
	print('{0} {1} {2}'.format(
		i+1, path[i], cost[i+1][path[i]]
	))

if path[len(path)-1] != (C-1):
	print('{0} {1} {2}'.format(R-1, C-1, cost[R-1][C-1]))
