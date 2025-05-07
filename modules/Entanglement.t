//------------------------ Entanglement -----------------------------------//

//We are restricting entanglement to nonces in order to avoid partial deconstructions. 
rule Entanglement:
[ 
    !Dishonest($A), 
    QS(~id1, ~s), 
    Own($A, ~id1), 
    Fr(~id2), 
]
--[ 
    EntangledPair($A, ~id1, ~id2, ~s),
    QSEnc($A, ~id2, ~s), 
    QSUsed($A, ~id2),
    AdvEntangled(~id2), 
    AdvEntangled(~id1), 
    AdvEncoded(~id2), 
]->
[ 
    QS(~id1, ~s), 
    QS(~id2, ~s), 
    Own($A, ~id1), 
    Own($A, ~id2),
    !Entangled($A, ~id1, ~id2),
]

rule EntanglementDec:
[
    !Dishonest($A),
    !Entangled($A, ~id1, ~id2),
    !Dec($B, ~id1, ~s),
    Own($A, ~id2),
]
--[ 
    QSDec($A, ~id2, ~s), 
    EntanglementBasedDec($B, ~id1, $A, ~id2, ~s), 
]->
[ 
    !Dec($A, ~id2, ~s),
    Out(~s), 
]

/*Ensure that same particle is not entangle twice*/
restriction CannotEntangledTwice:
"
    All #i #j id . AdvEntangled(id)@#i & AdvEntangled(id)@#j ==> #i = #j
"

/*Ensure that only adversaries entangle qubits and the adversary only entangle states he has created*/
// restriction AdvEncodeEntangle:
// "
//     All #i id . AdvEntangled(id)@#i ==>
//         (Ex #j. AdvEncoded(id)@#j)
// "

/*Ensure the adversary does not decode states he has created*/
restriction AdvDoesNotDecodeOwnEntangleStates:
"
    All #i id1 id2 A s. EntangledPair(A, id1, id2, s)@#i ==>
        not(Ex #j. AdvDecoded(id1)@#j)
"

/*Prevent the adversary from entangling the same QS twice*/
restriction AdvDoesNotEntangleTwice:
"
    All #i #j id . AdvEntangled(id)@#i & AdvEntangled(id)@#j ==>
        #i = #j
"

