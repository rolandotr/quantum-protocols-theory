//--------------------- Rectilinear Encoding rules ----------------------//

rule RectilinearEncoding: 
[
    RecEnc($A, ~id, x), //given an agent A that would like to encode x in the rectilinear basis 
]--[
    QSEnc($A, ~id, x), //signal that the state has been encoded  
    QSUsed($A, ~id),   //and that it has therefore been used
]->[
    QS(~id, x),     //this fact should only be consumed when measuring. 
    Own($A, ~id),   //establish that A owns this QS.  
    EncTypeRectilinear(~id), //and that id is encoded within a rectilinear basis
]

rule DiagonalEncoding: 
[
    DiagEnc($A, ~id, x), //given an agent A that would like to encode x in the diagonal basis 
]--[
    QSEnc($A, ~id, x),  
    QSUsed($A, ~id),   
]->[
    QS(~id, x),  
    Own($A, ~id),  
    EncTypeDiagonal(~id),   //establish that id is encoded within a diagonal basis
]

rule AdvRectilinearEncoding: 
[
    !Dishonest($A), 
    Fr(~x), 
    Fr(~id), 
]--[
    QSEnc($A, ~id, ~x), 
    QSUsed($A, ~id),    
    AdvEncoded(~id),  
]->[
    QS(~id, ~x),  
    Own($A, ~id),  
    EncTypeRectilinear(~id),
    Out(<~id, ~x>), //reveal encoding parameters 
]

rule AdvDiagonalEncoding: 
[
    !Dishonest($A), 
    Fr(~x), 
    Fr(~id), 
]--[
    QSEnc($A, ~id, ~x),  
    QSUsed($A, ~id),    
    AdvEncoded(~id),  
]->[
    QS(~id, ~x),  
    Own($A, ~id),  
    EncTypeDiagonal(~id),
    Out(<~id, ~x>),  
]

/*This rule provide the string encoded in a quantum state provided that the 
QS was encoded in the rectilinear basis.  */
rule CorrectRectilinearBasisDecoding:
[
    QS(~id, s), //given a quantum state.
    EncTypeRectilinear(~id),    //whose string was encoded with the rectilinear basis 
    Own($A, ~id), //which can be observed by A  
    RecDec($A, ~id), //and given the instruction of decoding id by A in the rectilinear basis. 
]--[
    QSDec($A, ~id, s), //signal that this QS has been decoded
    QSUsed($A, ~id),
]->[
    !Dec($A, ~id, s), //establish that $A has decoded id  
]

/*This rule models an attempt of measuring a quantum state on a diagonal basis
when the state was encoded in the rectilinear basis. */
rule IncorrectRectilinearBasisDecoding:
[
    QS(~id, s), 
    Own($A, ~id),  
    EncTypeDiagonal(~id),
    RecDec($A, ~id),  
    Fr(~n), 
]--[
    QSDec($A, ~id, ~n), //signal that this QS has been decoded
    QSUsed($A, ~id),
]->[
    !Dec($A, ~id, ~n), //establish that $A has decoded id  
]



rule CorrectDiagonalBasisDecoding:
[
    QS(~id, s), 
    Own($A, ~id),   
    EncTypeDiagonal(~id),
    DiagDec($A, ~id),  
]--[
    QSDec($A, ~id, s), 
    QSUsed($A, ~id),
]->[
    !Dec($A, ~id, s),   
]

rule IncorrectDiagonalBasisDecoding:
[
    QS(~id, s), 
    Own($A, ~id),   
    EncTypeRectilinear(~id),
    DiagDec($A, ~id),  
    Fr(~n), 
]--[
    QSDec($A, ~id, ~n), 
    QSUsed($A, ~id),
]->[
    !Dec($A, ~id, ~n),   
]


rule AdvCorrectRectilinearDecoding:
[
    !Dishonest($A), 
    QS(~id, s), 
    Own($A, ~id), 
    EncTypeRectilinear(~id),
]--[
    QSDec($A, ~id, s), 
    QSUsed($A, ~id),
    AdvDecoded(~id),
]->[
    !Dec($A, ~id, s),   
    Out(s), 
]

rule AdvIncorrectRectilinearDecoding:
[
    !Dishonest($A), 
    QS(~id, s), 
    Own($A, ~id), 
    EncTypeDiagonal(~id),
    Fr(~n), 
]--[
    QSDec($A, ~id, ~n), 
    QSUsed($A, ~id),
    AdvDecoded(~id),
]->[
    !Dec($A, ~id, ~n),   
    Out(~n), 
]

rule AdvCorrectDiagonalDecoding:
[
    !Dishonest($A), 
    QS(~id, s), 
    Own($A, ~id), 
    EncTypeDiagonal(~id),
]--[
    QSDec($A, ~id, s), 
    QSUsed($A, ~id),
    AdvDecoded(~id),
]->[
    !Dec($A, ~id, s),   
    Out(s), 
]

rule AdvIncorrectDiagonalDecoding:
[
    !Dishonest($A), 
    QS(~id, s), //given a quantum state.
    Own($A, ~id), //Observable by A
    EncTypeRectilinear(~id),
    Fr(~n), 
]--[
    QSDec($A, ~id, ~n), //signal that this QS has been decoded
    QSUsed($A, ~id),
    AdvDecoded(~id),
]->[
    !Dec($A, ~id, ~n), //establish that $A has decoded id  
    Out(~n), //and reveal.
]


/*To avoid Tamarin looping over knowledge creation, we restrict the adversary
from decoding states she has decoded, which is unnecessary because the 
encoded bitstring is already known by the adversary*/
restriction AdvEncodeDecode:
"
    not (Ex #i #j id. AdvDecoded(id)@#i & AdvEncoded(id)@#j)
"
