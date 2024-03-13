given((1, 1), 6).
given((1, 3), 9).
given((1, 4), 8).
given((1, 6), 7).
given((2, 4), 6).
given((2, 9), 1).
given((3, 2), 3).
given((3, 3), 5).
given((3, 6), 2).
given((3, 8), 7).
given((4, 2), 6).
given((4, 3), 8).
given((4, 7), 1).
given((4, 9), 2).
given((5, 1), 3).
given((5, 6), 5).
given((6, 4), 2).
given((6, 7), 3).
given((6, 8), 6).
given((7, 1), 8).
given((7, 2), 5).
given((7, 3), 4).
given((7, 4), 7).
given((7, 5), 2).
given((7, 7), 6).
given((7, 8), 9).
given((8, 4), 5).
given((8, 5), 9).
given((8, 9), 8).
given((9, 1), 2).
given((9, 3), 6).
given((9, 4), 4).
given((9, 5), 3).
given((9, 7), 7).
given((9, 8), 1).
given((9, 9), 5).

assign((Row, Col), Value) :- Row = 1..9; Col = 1..9; Value = 1..9; not assign'((Row, Col), Value).
assign'((Row, Col), Value) :- Row = 1..9; Col = 1..9; Value = 1..9; not assign((Row, Col), Value).
:- assign(Cell, Value), assign(Cell, Value'), Value < Value'.
:- Row = 1..9; Col = 1..9; Cell = (Row, Col); assign'(Cell, 1); assign'(Cell, 2); assign'(Cell, 3); assign'(Cell, 4); assign'(Cell, 5); assign'(Cell, 6); assign'(Cell, 7); assign'(Cell, 8); assign'(Cell, 9).
:- given(Cell, Value), assign'(Cell, Value).

:- block(Block, Cell); block(Block, Cell'), Cell != Cell'; assign(Cell, Value), assign(Cell', Value).
at_least_one(Block, Value) :- block(Block, Cell); assign(Cell, Value).
at_least_one'(Block, Value) :- block(Block, Cell); Value = 1..9; not at_least_one(Block, Value).
:- block(Block, Cell); Value = 1..9; at_least_one'(Block, Value).

block((row, Row), (Row, Col)) :- Row = 1..9, Col = 1..9.
block((col, Col), (Row, Col)) :- Row = 1..9, Col = 1..9.
block((sub, Row', Col'), (Row, Col)) :- Row = 1..9; Col = 1..9; Row' = (Row-1) / 3; Col' = (Col-1) / 3.