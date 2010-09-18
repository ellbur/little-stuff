#define a searchstr(h+1, n)

char* searchstr(char *h, char *n) {

return !*n

? h

: !*h

? 0

: *h^*n

? a

: ++n && a-h-1

? (--n,a)

: h ;

} 
