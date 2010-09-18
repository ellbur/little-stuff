
#include "user_code.h"
#include "user_pid.h"

#include <stdio.h>
#include <math.h>

#define PI 3.14159265358979

#define WHEEL_RAD       (2.0*2.54/100.)
#define WHEEL_CIRC      (2.0*PI*WHEEL_RAD)
#define TICKS_PER_REV   (90 * 4)
#define TICKS_PER_METER (TICKS_PER_REV/WHEEL_CIRC)
#define LOOP_DURATION   0.0186

int enc_count;
int last_enc_count;

int loop_count = 0;

PID pid;

void User_Code_Init(sim_info *sim)
{
	double kp;
	last_enc_count = 0;
	
	kp = -25.0;
	
	pid.K_P = kp;
	pid.K_I = -(sim->B - kp) * (sim->B - kp) / (4 * sim->A * sim->mass);
	pid.K_D = -0.0;
	
	pid.MAX_OUTPUT = +127;
	pid.MIN_OUTPUT = -127;
	
	Init_PID(&pid);
}

// --------------------------------------------------------------
// Time tracking stuff

#define TIME_BUFFER_SIZE 4
long time_buffer[TIME_BUFFER_SIZE];
long abs_tick_count;
char last_dir = 1;

// time is since start of slow loop.
// 1000 is a full loop
void User_Encoder_Tick(char dir, unsigned long time_fraction)
{
	long time;
	
	if (dir == last_dir) {
		time = time_fraction + loop_count*1000;
		time_buffer[abs_tick_count%TIME_BUFFER_SIZE] = time;
		
		abs_tick_count++;
	}
	else {
		abs_tick_count = 0;
		last_dir = dir;
	}
	
	enc_count += dir;
}

float Estimate_Speed(void)
{
	char i;
	long total_diff;
	long now, last;
	
	if (abs_tick_count < TIME_BUFFER_SIZE)
		return 0.0;
	
	last = time_buffer[(abs_tick_count-1)%TIME_BUFFER_SIZE];
	now = 1000*loop_count;
	
	if (now - last > 1500) return 0.0;
	
	total_diff = last - time_buffer[(abs_tick_count)%TIME_BUFFER_SIZE];
	
	return (float) 1.0 / (total_diff / (TIME_BUFFER_SIZE-1)
			* TICKS_PER_METER * LOOP_DURATION / 1000.) * last_dir;
}

user_code_output User_Code_Slow_Loop(user_code_input input)
{
	user_code_output output;
	float vel, vel2;
	float target;
	int pwm;
	
	target    = input.target_vel;
	
	vel2 = (enc_count - last_enc_count) / TICKS_PER_METER / LOOP_DURATION;
	vel = Estimate_Speed();
	last_enc_count = enc_count;
	
	Step_PID(&pid, vel - target, LOOP_DURATION);
	pwm = (int) pid.output + 127;
	
	if (pwm < 0)   pwm = 0;
	if (pwm > 254) pwm = 254;
	
	loop_count++;
	
	output.pwm_output = pwm;
	output.user1 = vel;
	output.user2 = vel2;
	return output;
}
