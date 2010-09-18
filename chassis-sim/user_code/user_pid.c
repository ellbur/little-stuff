
#include "user_pid.h"

void Init_PID(PID *pid)
{
	pid->p_error = 0.0f;
	pid->i_error = 0.0f;
	pid->d_error = 0.0f;
}

void Step_PID(PID *pid, float error, float time_step)
{
	pid->d_error  = (error - pid->p_error) / time_step;
	pid->i_error += error * time_step;
	pid->p_error  = error;
	
	pid->output = pid->K_P*pid->p_error
	            + pid->K_I*pid->i_error
	            + pid->K_D*pid->d_error ;
	
	if (pid->output < pid->MIN_OUTPUT && error > 0) {
		pid->i_error -= error * time_step;
	}
	else if (pid->output > pid->MAX_OUTPUT && error < 0) {
		pid->i_error -= error * time_step;
	}
}
