
#include <stdio.h>

#define a s(h+1, n)
char* s(char *h, char *n) {
    return !*n ? h : !*h ? 0
        : *h^*n ? a : ++n && a-h-1 ? (--n,a) : h ;
} 

int count(char *h, char *n) {
    char *c = s(h, n);
    return c ? 1 + count(c+1, n) : 0;
}

int main(int argc, char **argv) {
    printf("%s\n", argv[1]);
    printf("%s\n", argv[2]);
    printf("%p\n", s(argv[1], argv[2]));
    printf("%d\n", count(argv[1], argv[2]));
}

