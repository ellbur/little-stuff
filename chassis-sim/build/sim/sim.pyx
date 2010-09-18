
class SimOutput:
	
	def __init__(self, n):
		self.t     = [ 0.0 ] * n
		self.x     = [ 0.0 ] * n
		self.v     = [ 0.0 ] * n
		self.a     = [ 0.0 ] * n
		self.L     = [ 0.0 ] * n
		self.vt    = [ 0.0 ] * n
		self.user1 = [ 0.0 ] * n
		self.user2 = [ 0.0 ] * n

# ------------------------------------------------------------
# External Definitions

cdef extern from "sim.h":
	ctypedef struct user_code_input:
		double target_vel

	ctypedef struct user_code_output:
		unsigned char pwm_output
		double user1
		double user2
	
	ctypedef struct sim_info:
		int npoints
		
		double duration,
		double loop_duration,
		int sim_steps_per_loop,
		
		double mass,
		
		double stall_torque,
		double free_spin,
		double num_motors,
		double wheel_rad,
		
		double ticks_per_rev
		
		double target_vel
		
		double time_step
		
		double A
		double B
		double Ff
		
		double t
		double x
		double v
		double a
		double F
		
		double L
		
		int last_enc_count
		
		user_code_output user_output

cdef extern from "user_code.h":
	void User_Encoder_Tick(char, int)
	void User_Code_Init(sim_info*)
	user_code_output User_Code_Slow_Loop(user_code_input input)

cdef extern from "math.h":
	double sin(double)
	double fabs(double)

# ------------------------------------------------------------

def run_sim(
	double duration,
	double loop_duration,
	int sim_steps_per_loop,
	
	double mass,
	
	double stall_torque,
	double free_spin,
	double num_motors,
	double wheel_rad,
	double friction,
	
	double ticks_per_rev,
) :
	cdef sim_info sim
	cdef int i
	cdef int j
	
	sim.npoints = <int>(duration / loop_duration);
	output  = SimOutput(sim.npoints)
	
	sim.duration           = duration
	sim.loop_duration      = loop_duration
	sim.sim_steps_per_loop = sim_steps_per_loop
	sim.mass               = mass
	sim.stall_torque       = stall_torque
	sim.free_spin          = free_spin
	sim.num_motors         = num_motors
	sim.wheel_rad          = wheel_rad
	sim.ticks_per_rev      = ticks_per_rev
	
	sim.time_step = sim.loop_duration / sim.sim_steps_per_loop
	
	sim.A = 1.0 / (sim.stall_torque / sim.wheel_rad * sim.num_motors)
	sim.B = 1.0 / (sim.free_spin * sim.wheel_rad)
	
	sim.Ff = friction
	
	sim.t = 0.0
	sim.x = 0.0
	sim.v = 0.0
	sim.a = 0.0
	sim.F = 0.0
	
	sim.last_enc_count = 0
	
	init(&sim)
	
	for i in range(sim.npoints):
		
		slow_loop(&sim)
		
		output.t[i]     = sim.t
		output.x[i]     = sim.x
		output.v[i]     = sim.v
		output.a[i]     = sim.a
		output.L[i]     = sim.L
		output.vt[i]    = sim.target_vel
		output.user1[i] = sim.user_output.user1
		output.user2[i] = sim.user_output.user2
		
		for j in range(sim_steps_per_loop):
			sim_loop(&sim, j)
		
	
	return output

cdef init(sim_info *sim):
	User_Code_Init(sim)

cdef slow_loop(sim_info *sim):
	
	cdef int n = <int> (sim.t)
	
	if (n/4) % 2 == 0:
		sim.target_vel = 0.4 * sin(sim.t)
	elif (n/2) % 2 == 0:
		sim.target_vel = 0.35
	else:
		sim.target_vel = -0.35
	
	cdef user_code_input input
	input.target_vel    = sim.target_vel
	
	cdef user_code_output output = User_Code_Slow_Loop(input)
	cdef int pwm = output.pwm_output
	cdef double level = (pwm - 127.0) / 127.0
	
	if level < -1.0: level = -1.0
	if level > +1.0: level = +1.0
	
	sim.L = level
	sim.user_output = output

cdef void sim_loop(sim_info *sim, int j):
	
	sim.t += sim.time_step
	sim.x += sim.v * sim.time_step
	sim.v += sim.a * sim.time_step
	
	sim.F = (sim.L - sim.B*sim.v) / sim.A
	if   sim.v > 0: sim.F -= sim.Ff
	elif sim.v < 0: sim.F += sim.Ff
	
	sim.a = sim.F / sim.mass
	
	cdef double theta = sim.x / sim.wheel_rad
	cdef double revs  = theta / (2*3.141592)
	cdef int enc_count = <int>(revs * sim.ticks_per_rev)
	
	cdef int time_part = <int>(<double>j/sim.sim_steps_per_loop*1000)
	
	while sim.last_enc_count < enc_count:
		User_Encoder_Tick(+1, time_part)
		sim.last_enc_count += 1
	
	while sim.last_enc_count > enc_count:
		User_Encoder_Tick(-1, time_part)
		sim.last_enc_count -= 1
