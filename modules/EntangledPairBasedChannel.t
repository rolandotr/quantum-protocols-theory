//------------- Channel Based on Entangled Pairs -------------------------//


/****************************************************************/
/*    1- QS facts should not be used directly. They denote a    */
/*      quantum physical particle with an identifier and an     */
/*      amplitude. By a particle we don't mean necessarily a    */ 
/*       single qubit. It could be a quantum system.            */ 
/*    2- Own (Ownerve) facts should not be used directly. They  */ 
/*     denote physical access to a quantum particle. When the   */
/*     particle is transmitted, it can be Ownerved by the       */
/*     adversary. Unlike classical bits which can be            */ 
/*     copied, quantum particles cannot.                        */  
/****************************************************************/


//------------------------ Setup ----------------------------------------//
rule RegisterEntangledQSPairs:
[
    Fr(~qsid1), 
    Fr(~qsid2),   
]--[
]->
[
    EntangledQSPair($A, $B, ~qsid1, ~qsid2), //register entangled pair. 
]

//------------------------ Teleportation ----------------------------------------//

/*This rule allows an agent to teleport to another agent. */
rule TeleportOut:
[ 
    TeleportOut($A, $B, ~qsid, r), //If $A has instructed the teleporting of ~qsid to $B with randomness ~r.  
    QS(~qsid, v), //and ~qsid has value v. 
    Own($A, ~qsid), //and $A can Ownerve/measure ~qsid. 
    EntangledQSPair($A, $B, ~qsid1, ~qsid2), //And given the existence of an entangled pair.  
]
--[
    QuantumStateCreated(~qsid2, \senc{v, r}), //signal that the creation of a quantum state 
    AgentRecvQS($B, ~qsid2), //and that $B owns it. 
]->
[ 
    QS(~qsid2, \senc{v, r}), //Establish that ~qsid2 has value \senc{v, r}  
    Own($B, ~qsid2), //and that $B can Ownerve it.  
    TeleportIn($B, $A, ~qsid2, \senc{v, r}), //Establish that ~qsid2 is ready to be measured. 
]

//------------------------ SuperDenseCoding ----------------------------------------//

/*This rule allows an agent to send a term to another agent via superdense coding. */
rule TeleportOut:
[ 
    SuperdenseOut($A, $B, v), //If $A has instructed sending v to to $B.  
    EntangledQSPair($A, $B, ~qsid1, ~qsid2), //then we need a pair of entangled QSs.   
]
--[
]->
[ 
    SuperdenseIn($B, $A, v), //Establish that ~qsid2 is ready to be measured. 
]

