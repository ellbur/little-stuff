
#ifndef _user_code_h
#define _user_code_h 1

#include "sim.h"

// time is since start of slow loop.
// 1000 is a full loop
void User_Encoder_Tick(char dir, unsigned long time);

void User_Code_Init(sim_info *sim);
user_code_output User_Code_Slow_Loop(user_code_input input);

#endif
