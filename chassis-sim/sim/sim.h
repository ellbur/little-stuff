
#ifndef _sim_h
#define _sim_h 1

typedef struct {
	double target_vel;
} user_code_input;

typedef struct {
	unsigned char pwm_output;
	
	double user1;
	double user2;
} user_code_output;

typedef struct {
	int npoints;
	
	double duration;
	double loop_duration;
	int sim_steps_per_loop;
	
	double mass;
	
	double stall_torque;
	double free_spin;
	double num_motors;
	double wheel_rad;
	
	double ticks_per_rev;
	
	double target_vel;
	
	double time_step;
	
	double A;
	double B;
	double Ff;
	
	double t;
	double x;
	double v;
	double a;
	double F;
	
	double L;
	
	int last_enc_count;
	
	user_code_output user_output;
	
} sim_info;

#endif
