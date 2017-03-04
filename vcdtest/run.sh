#!/bin/bash

t=$(mktemp)
iverilog -Wall -o$t -smain main.v
vvp $t | grep -vF 'VCD info: dumpfile dump.vcd opened for output.'
/bin/rm $t

./vcd2json < dump.vcd > dump.json
echo -n 'var dump = ' > dump.js
cat dump.json >> dump.js

