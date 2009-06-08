
function [ Time Summary ] = read_summary(File)

Table = csvread(File);
Size  = size(Table);

Rows = Size(1);
Cols = Size(2);

Time = Table(2:Rows, 1);
Summary = Table(2:Rows, 2:(Cols-1));
