
people([b, w, r, h]).

person(X) :- people(P), member(X, P).

time(b,  5).
time(w, 10).
time(r, 20).
time(h, 25).

backish([]).
backish([back(X)|_]).

forwish([forw(X)|_]).

trip(trip( paths([]), time(0), here(P), there([]) )) :- people(P).

trip(trip(
		paths([forw([A,B]) | Past]),
		time(Total_Time),
		here(Here),
		there(There))) :-
	
	backish(Past),
	
	trip(trip(
		paths(Past),
		time(Old_Time),
		here(Old_Here),
		there(Old_There) )),
	
	member(A, Old_Here),
	member(B, Old_Here),
	A \= B,
	
	append([A,B], Old_There, There),
	takeout(A, Old_Here, Here1),
	takeout(B, Here1, Here),
	
	time(A, T1),
	time(B, T2),
	max_list([T1, T2], Part_Time),
	
	Total_Time is Part_Time + Old_Time,
	Total_Time =< 60.

trip(trip(
		paths([back(A) | Past]),
		time(Total_Time),
		here(Here),
		there(There))) :-
	
	forwish(Past),
	
	trip(trip(
		paths(Past),
		time(Old_Time),
		here(Old_Here),
		there(Old_There) )),
	
	member(A, Old_There),
	
	append([A], Old_Here, Here),
	takeout(A, Old_There, There),
	
	time(A, Part_Time),
	
	Total_Time is Part_Time + Old_Time,
	Total_Time =< 60.

takeout(X, [], []).
takeout(X, [X|Y], Z) :- takeout(X, Y, Z).
takeout(X, [W|Y], [W|Z]) :- X \= W, takeout(X, Y, Z).
