
invert (x, y) = (y, x)

third (a, b, c) = c
third2 tuple = third2' tuple
	where
		third2' (a, b, c) = c

foo pair = a / b
	where
		(a, b) = (invert pair)

bar []    = []
bar [a]   = []
bar [a,b] = []
bar (a:b:c:cdr) = b : c : a : (bar (b : a : cdr))

row_match goal rule = row_match' goal rule
	where
		row_match' [] []  = (True, [])
		row_match' [_] [] = (False, [])
		row_match' [] [_] = (False, [])
		row_match' ( 0 : goal_cdr ) ( rule_car : rule_cdr ) =
			make_result rule_car goal_cdr rule_cdr
		row_match' ( goal_car : goal_cdr ) ( rule_car : rule_cdr ) =
			if goal_car == rule_car
			then make_result rule_car goal_cdr rule_cdr
			else (False, [])
		
		make_result rule_car goal_cdr rule_cdr =
			if match_rest
			then (True, rule_car : rest)
			else (False, [])
			where
				(match_rest, rest) = row_match' goal_cdr rule_cdr

main = do
	print (invert (3, 2))
	print (third (2, 1, 5))
	print (third2 (2, 1, 5))
	print (foo (2, 6))
	print (bar [1,2,3,4,5,6])
	print (row_match [0,0] [1,2])
	print (row_match [2,0] [1,2])
