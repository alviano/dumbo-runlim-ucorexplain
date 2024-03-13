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

{assign((Row, Col), Value) : Value = 1..9} = 1 :- Row = 1..9; Col = 1..9.
:- given(Cell, Value), not assign(Cell, Value).

:- block(Block, Cell); block(Block, Cell'), Cell != Cell'; assign(Cell, Value), assign(Cell', Value).
:- block(Block, _); Value = 1..9; not assign(Cell, Value) : block(Block, Cell).

block((row, Row), (Row, Col)) :- Row = 1..9, Col = 1..9.
block((col, Col), (Row, Col)) :- Row = 1..9, Col = 1..9.
block((sub, Row', Col'), (Row, Col)) :- Row = 1..9; Col = 1..9; Row' = (Row-1) / 3; Col' = (Col-1) / 3.