
#include <omp.h>
#include <stdio.h>

int main(int argc, char **argv) {
    int thread;
    
    printf("Begin\n");
    
    #pragma omp parallel private(thread)
    {
        thread = omp_get_thread_num();
        
        printf("Thread %d\n", thread);
    }
    
    printf("End\n");
}

