// -------------------- Initialization -------------------- //

rule RegisterAgentHonest:
    [  ]
  --[ AgentRegistered($X), Once($X), THonest($X)]->
    [ !PublicHonestAgent($X), !PublicAgent($X), !Honest($X)]
    
rule RegisterProver:
    [  ]
  --[ AgentRegistered($X), Once($X), THonest($X)]->
    [ !PublicHonestAgent($X), !PublicAgent($X), !Honest($X), !Prover($X)]

rule RegisterAgentDishonest:
    [  ]
  --[ AgentRegistered($X), Once($X), TDishonest($X)]->
    [ !PublicAgent($X), !Dishonest($X) ]	



// -------------------- Special Network Rules ---------------- //

rule TimedSend:
	[ TimedSend($X, id, m) ]--[ StartFast($X, id, m)]->[ Send($X, m), ActiveId($X, id) ]

rule TimedRecv:
    [ ActiveId($X, id), Recv($X, m) ]--[  EndFast($X, id, m) ]->[ TimedRecv($X, id, m) ]
    

rule Send:
	[ Send($X, m) ]--[ TSend($X, m)]->[ !Net(m), Out(m)]

rule Recv:
    [ !Net(m)]--[ TRecv($Y, m) ]->[ Recv($Y, m) ]
 


// -------------------- Corrupted Agent Rules ---------------- //


rule SendCorrupt:
	[ In(m), !Dishonest($X)  ]-->[ Send($X, m) ]

// -------------------- Protocol Rules -------------------- //
