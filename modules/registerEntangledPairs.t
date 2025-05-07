rule RegisterEntangledQSPairs:
[
    Fr(~qsid1), 
    Fr(~qsid2),   
]--[
]->
[
    EntangledQSPair($A, $B, ~qsid1, ~qsid2), //register entangled pair. 
]

