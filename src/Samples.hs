module Samples where
import Election
import EndToEndElect
import EvalElection
--sampleRoster :: Roster
--sampleRoster = ["cat","dog","chicken"]
sampleBallot1 :: Ballot String
sampleBallot1 = ["chicken","dog"]
sampleBallot2 :: Ballot String
sampleBallot2 = ["dog","cat"]
sampleBallot3 :: Ballot String
sampleBallot3 = ["cat","chicken"]
sampleBallot4 :: Ballot String
sampleBallot4 =  ["chicken","dog","cat"]
sampleBallot5 :: Ballot String
sampleBallot5 = ["budgies","chicken"]
sampleElection :: Election String
sampleElection = [sampleBallot1,sampleBallot2,sampleBallot3,sampleBallot4,sampleBallot5]



sampleBallotA :: Ballot String
sampleBallotA = ["chicken","dog"]
sampleBallotB :: Ballot String
sampleBallotB = ["chicken","dog"]
sampleBallotC :: Ballot String
sampleBallotC = ["dog","chicken"]
sampleBallotD :: Ballot String
sampleBallotD =  ["dog","chicken"]
sampleBallotE :: Ballot String
sampleBallotE = ["dog","chicken"] -- only this one should get through, the others should bounce
sampleElection2 :: Election String
sampleElection2 = [sampleBallotA,sampleBallotB,sampleBallotC,sampleBallotD,sampleBallotE]


sampleElectionWC= [["/","\"","\\"]]

sampleElectionZ= [["Its","Got","Electrolytes","Plants","What"],["Electrolytes","Fiber","Brawndos","Plants","Got"]]

result :: String
result = giveRankedList sampleElection
result2 :: String
result2 =giveNetworkString sampleElection2
result3 :: String
result3 =giveRankedList sampleElectionWC

loopElec :: Election String
loopElec = [["A","B"],["B","A"]]

sampleBallot' :: Ballot String
sampleBallot' = ["chicken","dog","chicken"] -- should ignore final chicken
result' = giveRankedList [sampleBallot']