module EndToEndElect where
import Election
import EvalElection

giveRankedList :: [[String]] -> String
giveRankedList = prettyElecResult . giveElecResult .processElection

giveNetworkString :: [[String]] -> String
giveNetworkString = prettyNetwork . giveElecResult .processElection

givePrefOrder :: [[String]] ->String
givePrefOrder = show . processElection

giveEdgeStrength :: [[String]] -> String
giveEdgeStrength = show . givePrefMap