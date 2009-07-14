
#include "mutex.h"

void mutex_spinlock(mutex_t *mutex)
{
	for (;;) {
		lock_atomic();
		
		if (! *mutex) {
			*mutex = 1;
			
			unlock_atomic_keep();
			return;
		}
		
		unlock_atomic();
	}
}

void mutex_unlock(mutex_t *mutex)
{
	lock_atomic();
	*mutex = 0;
	
	// Good time to context switch
	unlock_atomic();
}
