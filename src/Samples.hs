module Samples where
import Election
import EndToEndElect
import EvalElection
--sampleRoster :: Roster
--sampleRoster = ["cat","dog","chicken"]
sampleBallot1 :: Ballot
sampleBallot1 = ["chicken","dog"]
sampleBallot2 :: Ballot
sampleBallot2 = ["dog","cat"]
sampleBallot3 :: Ballot
sampleBallot3 = ["cat","chicken"]
sampleBallot4 :: Ballot
sampleBallot4 =  ["chicken","dog","cat"]
sampleBallot5 :: Ballot
sampleBallot5 = ["budgies","chicken"]
sampleElection :: Election
sampleElection = [sampleBallot1,sampleBallot2,sampleBallot3,sampleBallot4,sampleBallot5]



sampleBallotA :: Ballot
sampleBallotA = ["chicken","dog"]
sampleBallotB :: Ballot
sampleBallotB = ["chicken","dog"]
sampleBallotC :: Ballot
sampleBallotC = ["dog","chicken"]
sampleBallotD :: Ballot
sampleBallotD =  ["dog","chicken"]
sampleBallotE :: Ballot
sampleBallotE = ["dog","chicken"] -- only this one should get through, the others should bounce
sampleElection2 :: Election
sampleElection2 = [sampleBallotA,sampleBallotB,sampleBallotC,sampleBallotD,sampleBallotE]


sampleElectionWC= [["/","\"","\\"]]

sampleElectionZ= [["Its","Got","Electrolytes","Plants","What"],["Electrolytes","Fiber","Brawndos","Plants","Got"]]

result :: String
result = giveRankedList sampleElection
result2 :: String
result2 =giveNetworkString sampleElection2
result3 :: String
result3 =giveRankedList sampleElectionWC

loopElec :: Election
loopElec = [["A","B"],["B","A"]]

sampleBallot' :: Ballot
sampleBallot' = ["chicken","dog","chicken"] -- should ignore final chicken
result' = giveRankedList [sampleBallot']