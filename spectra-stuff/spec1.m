
function [ Channels Offset EvPerBin ] = spec1()

Channels = csvread('./channels.csv');
Offset   = -100;
EvPerBin = 10;

