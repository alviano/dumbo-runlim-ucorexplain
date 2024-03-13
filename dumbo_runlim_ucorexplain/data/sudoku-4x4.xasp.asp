%*
3 . . .
. . . 2
1 . . .
. . . 1
*%
given((1,1), 3).
given((2,4), 2).
given((3,1), 1).
given((4,4), 1).

assign((Row, Col), Value) :- Row = 1..4; Col = 1..4; Value = 1..4; not assign'((Row, Col), Value).
assign'((Row, Col), Value) :- Row = 1..4; Col = 1..4; Value = 1..4; not assign((Row, Col), Value).
:- assign(Cell, Value), assign(Cell, Value'), Value < Value'.
:- Row = 1..4; Col = 1..4; Cell = (Row, Col); assign'(Cell, 1); assign'(Cell, 2); assign'(Cell, 3); assign'(Cell, 4).
:- given(Cell, Value), assign'(Cell, Value).

:- block(Block, Cell); block(Block, Cell'), Cell != Cell'; assign(Cell, Value), assign(Cell', Value).
at_least_one(Block, Value) :- block(Block, Cell); assign(Cell, Value).
at_least_one'(Block, Value) :- block(Block, Cell); Value = 1..4; not at_least_one(Block, Value).
:- block(Block, Cell); Value = 1..4; at_least_one'(Block, Value).

block((row, Row), (Row, Col)) :- Row = 1..4, Col = 1..4.
block((col, Col), (Row, Col)) :- Row = 1..4, Col = 1..4.
block((sub, Row', Col'), (Row, Col)) :- Row = 1..4; Col = 1..4; Row' = (Row-1) / 2; Col' = (Col-1) / 2.