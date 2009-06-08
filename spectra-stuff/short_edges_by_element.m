
function [ Edges ZList NList ] = short_edges_by_element(Elements)
%
% Elements is a vector of atomic numbers.
%

global ShortEdgeSelect;
global ShortEdgeData;

NumEdges = columns(ShortEdgeData);
Elements = Elements(:);

Edges = ShortEdgeData(Elements, :)';
ZList = repmat(Elements, 1, NumEdges)';
NList = repmat(ShortEdgeSelect, rows(Elements), 1)';

Edges = Edges(:);
ZList = ZList(:);
NList = NList(:);

ZList = ZList(Edges ~= 0);
NList = NList(Edges ~= 0);
Edges = Edges(Edges ~= 0);
