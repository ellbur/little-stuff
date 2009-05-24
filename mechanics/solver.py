
import numpy
import numpy.linalg

from truss import *

class Solver:
	"""Solve simple trusses
	"""

def solver_init(solver):
	
	None

def solver_solve(solver, truss, dims):
	
	num_vars = len(truss.reactions) + len(truss.beams)
	num_rows = len(truss.joints) * dims
	
	
	if num_vars != num_rows:
		return
	
	left  = numpy.zeros([num_rows, num_vars])
	right = numpy.zeros([num_rows, 1])
	
	index = 0
	
	for beam in truss.beams:
		
		joint = beam.joint1
		row = joint.index * dims
		
		direction = beam.joint2.position - beam.joint1.position
		direction = direction / numpy.sqrt(numpy.vdot(direction, direction))
		
		for i in range(dims):
			left[row+i, index] = direction[i]
		
		joint = beam.joint2
		row = joint.index * dims
		
		for i in range(dims):
			left[row+i, index] = -direction[i]
		
		index += 1
	
	for react in truss.reactions:
		
		joint = react.joint
		row = joint.index * dims
		
		direction = react.direction
		direction = direction / numpy.vdot(direction, direction)
		
		for i in range(dims):
			left[row+i, index] = direction[i]
		
		index += 1
	
	for load in truss.loads:
		
		joint = load.joint
		row = joint.index * dims
		
		for i in range(dims):
			right[row+i] -= load.force[i]
	
	solution = numpy.linalg.solve(left, right)
	
	index = 0
	
	for beam in truss.beams:
		beam.force = solution.item(index)
		index += 1
	
	for react in truss.reactions:
		react.force = solution.item(index)
		index += 1


Solver.__init__ = solver_init
Solver.solve    = solver_solve
