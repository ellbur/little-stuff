
#define _GNU_SOURCE
#include <sched.h>
#include <stdio.h>

#define size 2
#define K 10000000

static inline int itothe(int n) {
    return n%2 ? -1 : 1;
}

int main(int argc, char **argv) {
    double buf[size] = { 0 };
    
    for (int i=0; i<size; i++) {
        printf("Doing part for %d on cpu %d\n",
            i,
            sched_getcpu()
        );
            
        for (int j=0; j<K; j++) {
            int n = i*K + j;
            buf[i] += (double)itothe(n) / (n + 1);
        }
    }
    
    double sum = 0;
    for (int i=0; i<size; i++) {
        sum += buf[i];
    }
    
    printf("Sum = %.6f\n", sum);
}



