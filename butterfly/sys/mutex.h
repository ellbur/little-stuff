
#ifndef _mutex_h
#define _mutex_h 1

#include "tasks.h"

typedef char mutex_t;

void mutex_spinlock(mutex_t *mutex);
void mutex_unlock(mutex_t *mutex);

#endif /* defined _mutex_h */
