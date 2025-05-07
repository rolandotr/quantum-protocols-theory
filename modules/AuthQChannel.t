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

//------------- Authentic Quantum Channel -------------------------//

//------------- Authentic Quantum Channel -------------------------//

/*This rule allows an agent to send a QS to another agent. */
rule QChanOut_A:
[ 
    QOut_A($A, $B, ~qs), //If $A has instructed the sending of ~qs to $B via an authentic channel.  
    Own($A, ~qs), //and $A can Ownerve/measure ~qs. 
]
--[
    QSTransfer($A, $B, ~qs), //signal that $A does not longer owns ~qs
]->
[ 
    QIn_A($A, $B, ~qs),    //establish that $B can receive ~qs 
    Own($B, ~qs), //and the B owns qs.  
]

/*This rule allows the adversary to intersect a QS a re-direct it to 
a dishonest agent. */
rule QChanAdvIntersect_A:
[ 
    !Dishonest($C), 
    QOut_A($A, $B, ~qs), //If $A has instructed the sending of ~qs to $B.  
    Own($A, ~qs), //and $A can Ownerve/measure ~qs. 
]
--[
    QSTransfer($A, $C, ~qs), //signal that $A does not longer owns ~qs
]->
[ 
    QIn_A($A, $C, ~qs),    //establish that $B can receive ~qs 
    Own($C, ~qs), //and the B owns qs.  
]
