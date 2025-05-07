//------------- Rules for the creation of quantum states by the  adversary --------------------//

rule AdvCreateQuantumStates: 
[
    Fr(~s), 
    Fr(~id), 
]--[
    QSEnc(~id, ADV()),    
    QSUsed(~id),
    AdvCreateQuantumState(~id, ~s),
]->[
    QS(~id, ~s),  
    AdvOwn(~id),  
    Out(~id),
    Out(~s),
]
