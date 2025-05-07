//------------- Authentic Classical Channel rules  -------------------------//
rule ChanOut_A:
[ Out_A($A,$B,x) ]
--[ ChanOut_A($A,$B,x) ]->
[ !Auth($A,x), Out(x) ]

rule ChanIn_A:
[ !Auth($A,x), In($B) ]
--[ ChanIn_A($A,$B,x) ]->
[ In_A($A,$B,x) ]

