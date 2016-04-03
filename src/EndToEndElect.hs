module EndToEndElect where
import Election
import EvalElection

giveRankedList :: [[String]] -> String
giveRankedList = prettyElecResult . giveElecResult .processElection

giveNetworkString :: [[String]] -> String
giveNetworkString = prettyNetwork . giveElecResult .processElection