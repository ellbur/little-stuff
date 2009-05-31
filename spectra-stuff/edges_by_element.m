
function [ Edges ZList NList ] = edges_by_element(Elements)
%
% Elements is a vector of atomic numbers.
%
% Returns a vector of energies.
%

global EdgeData;

NumEdges = columns(EdgeData);
Elements = Elements(:);

Edges = EdgeData(Elements, 1:NumEdges)';
ZList = repmat(Elements, 1, NumEdges)';
NList = repmat(1:NumEdges, rows(Elements), 1)';

Edges = Edges(:);
ZList = ZList(:);
NList = NList(:);

ZList = ZList(Edges ~= 0);
NList = NList(Edges ~= 0);
Edges = Edges(Edges ~= 0);
