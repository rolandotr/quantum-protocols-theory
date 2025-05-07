//------------- Rules for the manipulation of quantum states --------------------//


//---------------------- Amplitude Encoding -------------------------------------//

/* This rule can be used to encode a nonce into a quantum state via amplitude encoding. 
*/
rule AmplitudeEncoding: 
[
    CreateAmplitudeEncoding($A, ~qsid, ~n), //given an agent A that would like to 
                                        //encode a nonce into a QS via amplitude enconding
]--[
    QuantumStateCreated(~qsid, ~n), //signal that the creation of a quantum state 
    AgentRecvQS($A, ~qsid), //and that $A owns it. 
    Encoding('Amplitude', ~qsid, ~n), //signal the encoding type for this quantum state 
]->[
    QS(~qsid, ~n), //establish that there exists a QS fully identified by ~qsid, ~n.  
    Own($A, ~qsid),   //establish that A owns this QS.  
]

/* This rule can be used by the adversary to encode a nonce into a quantum state. 
*/
rule AmplitudeEncodingAdv: 
[
    In(<~qsid, ~n>), 
]--[
    QuantumStateCreated(~qsid, ~n), //signal that $A created a QS
    AdvOwnsQS(~qsid), //and that the adv owns it. 
    Encoding('Amplitude', ~qsid, ~n), //signal the encoding type for this quantum state 
]->[
    QS(~qsid, ~n), //establish that there exists a QS fully identified by ~qsid, ~n.  
    AdvOwn(~qsid),   //establish that the adv owns this QS.  
]


/*Provides to an agent the value encoded within a quantum state that has been encoded 
via amplitude encoding. In practice, for tomography to work, it needs a number of copies 
that is quadratic on the length of the string. For simplicity, we shall require just one. */
rule Tomography:
[
    Tomography($A, ~qsid), //If $A wishes to decode qs 
    QS(~qsid, v), //And such qs exists. 
    Own($A, ~qsid), //and A does own the QS   
]--[
    Decoding('Amplitude', ~qsid, v), //signal the decoding for this quantum state 
    QuantumStateMeasured(~qsid, v), //signal that this QS has been measured
]->[
	TomographyOutcome($A, ~qsid, v),
]

/*Provides the adversary the ability to measure a quantum state. */
rule TomographyAdv:
[
    In(~qsid), //If $A wishes to decode qs 
    QS(~qsid, v), //And such qs exists. 
    AdvOwn(~qsid), //and the adv does own the QS   
]--[
    Decoding('Amplitude', ~qsid, v), //signal the decoding for this quantum state 
    QuantumStateMeasured(~qsid, v), //signal that this QS has been measured
]->[
	Out(v),
]

//Ensures no cloning of quantum particles 
restriction NoCloning: 
"
    All qsid x y #i #j . 
        QuantumStateCreated(qsid, x)@i & QuantumStateCreated(qsid, y)@j ==> 
            #i = #j  
"

//Ensures that encoding and decoding are of the same type.  
restriction ConsistentEncDec: 
"
    All qsid t1 t2 x y #i #j . 
        Encoding(t1, qsid, x)@i & Decoding(t2, qsid, y)@j ==> 
            t1 = t2  
"

//---------------------- Rotation-based Encoding -------------------------------------//

/* This rule can be used to encode a nonce into a quantum state via rotation encoding. 
*/
rule RotationEncoding: 
[
    CreateRotationEncoding($A, ~qsid, v), //given an agent A that would like to 
                                        //encode v into a QS via rotation enconding
]--[
    QuantumStateCreated(~qsid, v), //signal that the creation of a quantum state 
    AgentRecvQS($A, ~qsid), //and that $A owns it. 
    Encoding('Rotation', ~qsid, v), //signal the encoding type for this quantum state 
]->[
    QS(~qsid, v), //establish that there exists a QS fully identified by ~qsid and v  
    Own($A, ~qsid),   //establish that A owns this QS.  
]

/* This rule can be used by the adversary to encode a nonce into a quantum state. 
*/
rule RotationEncodingAdv: 
[
    In(<~qsid, v>), 
]--[
    QuantumStateCreated(~qsid, v), //signal that $A created a QS
    AdvOwnsQS(~qsid), //and that the adv owns it. 
    Encoding('Rotation', ~qsid, v), //signal the encoding type for this quantum state 
]->[
    QS(~qsid, v), //establish that there exists a QS fully identified by ~qsid and v  
    AdvOwn(~qsid),   //establish that the adv owns this QS.  
]



