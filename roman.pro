oneHead('C', 100).
oneHead('L', 50).
oneHead('X', 10).
oneHead('V', 5).
oneHead('I', 1).

twoHead('I', 'X', 9).
twoHead('X', 'L', 40).
twoHead('X', 'C', 90).
twoHead('I', 'V', 4).

getSub(100, ['C']).
getSub(90, ['X', 'C']).
getSub(50, ['L']).
getSub(40, ['X', 'L']).
getSub(10, ['X']).
getSub(9, ['I', 'X']).
getSub(5, ['V']).
getSub(4, ['I', 'V']).
getSub(1, ['I']).

concat([], Lst2, Lst2).
concat([Lst1Head | Lst1Tail], Lst2, [Lst1Head | ResultTail]) :-
	concat(Lst1Tail, Lst2, ResultTail).

romanToInt([], 0).
romanToInt([RomanHead1, RomanHead2 | RomanTail], Result) :-
	twoHead(RomanHead1, RomanHead2, Add),
	romanToInt(RomanTail, PrevResult),
	Result is PrevResult + Add, !.
romanToInt([RomanHead | RomanTail], Result) :-
	oneHead(RomanHead, Add),
	romanToInt(RomanTail, PrevResult),
	Result is PrevResult + Add, !.

intToRoman(0, []).
intToRoman(Int, Result) :-
	getSub(Min, Add), Int >= Min,
	concat(Add, PrevResult, Result),
	NewInt is Int - Min,
	intToRoman(NewInt, PrevResult), !.

?- 0,romanToInt(['C', 'C', 'C', 'X', 'X', 'V', 'I'], Result),
	write(Result), nl.

?- intToRoman(304, Result),
	write(Result), nl.