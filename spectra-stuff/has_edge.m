
function True = has_edge(Z, E)

global EdgeData;

True = EdgeData(Z, E) ~= 0;
