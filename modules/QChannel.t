//------------- Quantum Channel -------------------------//


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

//------------- Quantum Channel -------------------------//

/*This rule allows an agent to send a QS to another agent. */
rule QChanOut:
[ 
    QOut($A, ~qs), //If $A has instructed the sending of ~qs.  
    Own($A, ~qs), //and $A can Ownerve/measure ~qs. 
]
--[
    ReleasedQS($A, ~qs), //signal that $A does not longer owns ~qs
    AgentRecvQS($B, ~qs), //Signal that $B now owns ~qs. 
]->
[ 
    QIn($B, ~qs),    //establish that $B can receive ~qs 
    Own($B, ~qs), //and Ownerve it.  
]

/*This rule allows the adversary to intersect a QS. */
rule QChanAdvIntersect:
[ 
    QOut($A, ~qs), //If $A has instructed the sending of ~qs .  
    Own($A, ~qs), //and $A can Ownerve/measure ~qs. 
]
--[
    ReleasedQS($A, ~qs), //signal that $A does not longer owns ~qs
    AdvOwnsQS(~qs), //Signal that the adversary now owns ~qs. 
]->
[ 
    AdvOwn(~qs), //and Ownerve it.  
]


/*Allows the adversary to transmit a quantum particle. */
rule QChanOutAdv:
[ 
    AdvOwn(~qs), //If the adversary has access to ~qs. 
]
--[ 
    AdvReleasedQS(~qs),
    AgentRecvQS($B,~qs),
]->
[ 
    QIn($B,~qs),  //It can send it to any agent B
    Own($B,~qs), 
]


/*This is a sanity check. It checks whether a particle can be owned/Ownerved/measured 
by two agents at the same time. The lemma does so by ensuring that Owns and Release 
Action facts are interleaved. */
lemma OwnershipIsFollowedByRelease: 
	"All #i a qs . AgentRecvQS(a, qs)@i ==>  //Whenever a owns qs then 
        (Ex #j . ReleasedQS(a, qs)@j & #i < #j) //Either a releases qs in the future
        | (not(Ex b #j . AgentRecvQS(b, qs)@j & #i < #j)) //or qs remains in a's hands. 
        | (not(Ex #j . AdvOwnsQS(qs)@j & #i < #j)) //or qs remains in a's hands. 
	"

lemma AdvOwnershipIsFollowedByRelease: 
	"All #i qs . AdvOwnsQS(qs)@i ==>  //Whenever the adv owns qs then 
        (Ex #j . AdvReleasedQS(qs)@j & #i < #j) //Either adv released qs in the future
        | (not(Ex b #j . AgentRecvQS(b, qs)@j & #i < #j)) //or qs remains in the adv's hands. 
	"


