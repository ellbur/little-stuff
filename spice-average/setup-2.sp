
.control
set filetype=ascii
.endc

Vs 1 0 SIN(1 1 1kHz)

* tau = 3ms
Rlp 1 2 1k
Clp 2 0 3uF

.tran 3ms 40ms
 
