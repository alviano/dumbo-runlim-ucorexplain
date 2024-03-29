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

{assign((Row, Col), Value) : Value = 1..4} = 1 :- Row = 1..4; Col = 1..4.
:- given(Cell, Value), not assign(Cell, Value).

:- block(Block, Cell); block(Block, Cell'), Cell != Cell'; assign(Cell, Value), assign(Cell', Value).
:- block(Block, _); Value = 1..4; not assign(Cell, Value) : block(Block, Cell).

block((row, Row), (Row, Col)) :- Row = 1..4, Col = 1..4.
block((col, Col), (Row, Col)) :- Row = 1..4, Col = 1..4.
block((sub, Row', Col'), (Row, Col)) :- Row = 1..4; Col = 1..4; Row' = (Row-1) / 2; Col' = (Col-1) / 2.