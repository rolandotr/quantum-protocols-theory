//---------- Restrictions ensuring that measured states collapse --------------//


restriction ConsumedStatesCannotBeUsed:
"
    All #i a id s . QSDec(a, id, s)@#i ==>
        not(Ex #j b . #i < #j & QSUsed(b, id)@#j) 
"

restriction UnexistingStatesCannotBeUsed:
"
    All #i a s id . QSEnc(a, id, s)@#i ==>
        not(Ex #j b . QSUsed(b, id)@#j & #j < #i) 
"

