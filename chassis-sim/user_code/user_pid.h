
#ifndef _pid_h
#define _pid_h 1

typedef struct {
	float K_P;
	float K_I;
	float K_D;
	
	float MIN_OUTPUT;
	float MAX_OUTPUT;
	
	float p_error;
	float i_error;
	float d_error;
	
	float output;
} PID;

void Init_PID(PID *pid);
void Step_PID(PID *pid, float error, float time_step);

#endif
