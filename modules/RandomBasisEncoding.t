//------------- Rules modelling Random Basis Encoding --------------------//

rule RandomBasisEncoding: 
[
    REnc($A, ~id, x, y), //given an agent A that would like to encode x 
                        //with random basis y and id id. 
]--[
    QSEnc($A, ~id, x XOR y), //signal that this quantum state is using random basis encoding
    QSUsed($A, ~id),    //and it has been therefore used
]->[
    QS(~id, x XOR y), //establish that there exists a QS fully identified by x and y. 
                        //this fact should only be consumed when measuring. 
    Own($A, ~id), //and that that A owns this QS.  
                  //this fact should only be consumed when measured. 
]

/*Allows dishonest agents to perform random basis encoding. 
We are restricting the value to be encoded to be random, 
to help Tamarin in its reasoning. */
rule AdvEncoding: 
[
    !Dishonest($A), 
    Fr(~s), 
    Fr(~id), 
]--[
    QSEnc($A, ~id, ~s), //signal that this quantum state is using random basis encoding
    QSUsed($A, ~id),    //and it has been therefore used
    AdvEncoded(~id), //signal that an adversarial agent is encoding id. 
]->[
    // !Dec($A, ~id, ~s), 
    QS(~id, ~s), //establish that there exists a QS fully identified by x and y. 
                        //this fact should only be consumed when measuring. 
    Own($A, ~id), //and that that A owns this QS.  
                  //this fact should only be consumed when measured. 
    Out(<~id, ~s>), //and reveal 
]


rule RandomBasisDecoding:
[
    QS(~id, s), //given a quantum state.
    Own($A, ~id), //Ownervable by A  
    RDec($A, ~id, ~c), //and given the instruction of decoding id by A with random basis c. 
]--[
    QSDec($A, ~id, s XOR ~c), //signal that this QS has been decoded
    QSUsed($A, ~id),
]->[
    !Dec($A, ~id, s XOR ~c), //establish that $A has decoded id  
]

/*To simplify the theory, here we are assuming the adv decode with a zero as a basis.*/
rule AdvRandomBasisDecoding:
[
    !Dishonest($A), 
    QS(~id, s), //given a quantum state.
    Own($A, ~id), //Observable by A
]--[
    QSDec($A, ~id, s), //signal that this QS has been decoded
    QSUsed($A, ~id),
    AdvDecoded(~id),
]->[
    !Dec($A, ~id, s), //establish that $A has decoded id  
    Out(s), //and reveal.
]


/*To avoid Tamarin looping over knowledge creation, we restrict the adversary
from decoding states she has decoded, which is unnecessary because the 
encoded bitstring is already known by the adversary*/
restriction AdvEncodeDecode:
"
    not (Ex #i #j id. AdvDecoded(id)@#i & AdvEncoded(id)@#j)
"

