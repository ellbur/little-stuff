
function [ Channels Offset EvPerBin ] = spec1()

Channels = csvread('./spec1.csv');
Offset   = -100;
EvPerBin = 10;

