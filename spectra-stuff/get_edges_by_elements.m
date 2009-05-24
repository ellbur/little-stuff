
function Edges = get_edges_by_elements(Elements)
%
% Elements is a vector of atomic numbers.
%
% Returns a vector of energies.
%

global EdgeData;

NumEdges = columns(EdgeData);
Edges = EdgeData(Elements, 1:NumEdges);

Edges = Edges(:);
Edges = Edges(Edges ~= 0);
