
cpu-mystery-omp: cpu-mystery.c cpu-mystery.mk
    gcc $< -o $@ -Wall -Werror --std=c99 -fopenmp -O3

cpu-mystery: cpu-mystery.c cpu-mystery.mk
    gcc $< -o $@ -Wall -Werror --std=c99 -O3

# vim: noexpandtab

