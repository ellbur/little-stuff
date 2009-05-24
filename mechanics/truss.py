
import numpy

class Truss:
	"""Simple 2D truss.
	
	Instance variables:
		joints    - [ Joint ]
		beams     - [ Beam ]
		loads     - [ Load ]
		reactions - [ Reaction ]
	"""

def truss_init(truss):
	
	truss.joints    = [ ]
	truss.beams     = [ ]
	truss.loads     = [ ]
	truss.reactions = [ ]

def truss_joint(truss, position, name=None):
	
	if name == None:
		name = "Joint %d" % len(truss.joints)
	
	position = numpy.array(position, dtype=numpy.double)
	
	joint = Joint()
	joint.position = position
	joint.name = name
	joint.index = len(truss.joints)
	truss.joints.append(joint)
	
	return joint

def truss_beam(truss, joint1, joint2):
	
	beam = Beam()
	beam.joint1 = joint1
	beam.joint2 = joint2
	
	joint1.beams.append(beam)
	joint2.beams.append(beam)
	
	truss.beams.append(beam)
	
	return beam

def truss_react(truss, joint, direction):
	
	direction = numpy.array(direction, dtype=numpy.double)
	
	react = Reaction()
	react.direction = direction
	react.joint = joint
	
	joint.reactions.append(react)
	truss.reactions.append(react)
	
	return react

def truss_load(truss, joint, force, magnitude=1.0):
	
	force = numpy.array(force, dtype=numpy.double)
	force = force * magnitude
	
	load = Load()
	load.force = force
	load.joint = joint
	
	joint.loads.append(load)
	truss.loads.append(load)
	
	return Load


Truss.__init__ = truss_init
Truss.joint    = truss_joint
Truss.beam     = truss_beam
Truss.react    = truss_react
Truss.load     = truss_load

# ------------------------------------------------

class Joint:
	"""Joint in simple plane truss.
	
	This class is mostly managed by class Truss
	
	Instance Variables:
		name      - str
		index     - int
		position  - numpy.array(dtype=numpy.double)
		beams     - [ Beam ]
		loads     - [ Load ]
		reactions - [ Reaction ]
	"""

def joint_init(joint):
	
	joint.position = numpy.array([0.0, 0.0])
	joint.beams = [ ]
	joint.loads = [ ]
	joint.reactions = [ ]
	joint.index = 0
	joint.name = ' '

def joint_to_string(joint):
	return joint.name


Joint.__init__  = joint_init
Joint.to_string = joint_to_string

# ------------------------------------------------

class Load:
	"""Load applied to joint in a plane truss.
	
	Instance Variables:
		joint - Joint
		force - numpy.array(dtype=numpy.double)
	"""

def load_init(load):
	load.joint = None
	load.force = numpy.array([0.0, 0.0])

def load_to_string(load):
	return "(Load %s)" % load.joint.to_string()


Load.__init__  = load_init
Load.to_string = load_to_string

# ------------------------------------------------

class Reaction:
	"""Reaction from support in a simple truss.
	
	Instance Variables:
		joint     - Joint
		direction - numpy.array(dtype=numpy.double)
	"""

def reaction_init(reaction):
	reaction.joint = None
	reaction.direction = numpy.array([0.0, 0.0])

def reaction_to_string(reaction):
	return "(Reaction %s)" % reaction.joint.to_string()


Reaction.__init__  = reaction_init
Reaction.to_string = reaction_to_string

# ------------------------------------------------

class Beam:
	"""Beam in a simple truss.
	
	Instance Variables:
		joint1 - Joint
		joint2 - Joint
	"""

def beam_init(beam):
	beam.joint1 = None
	beam.joint2 = None

def beam_to_string(beam):
	return "(%s,%s)" % (beam.joint1.to_string(), beam.joint2.to_string())


Beam.__init__  = beam_init
Beam.to_string = beam_to_string
