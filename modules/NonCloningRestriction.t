//------------- Non-cloning theorem -------------------------//

lemma NonCloning: 
	"All #i #j a b qs . QSUsed(a, qs)@#i & QSUsed(b, qs)@#j & #i < #j ==>  //Whenever a and b used qs then 
        a = b 
        |
        (Ex #k . 
            (#k < #j & #i < #k & QSTransfer(a, b, qs)@#k)
        ) 
	"

