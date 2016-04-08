module EndToEndElect where
import Election
import EvalElection
import CIConverters


giveRankedList :: [[String]] -> String
giveRankedList = prettyElecResult .cnvResult  . giveElecResult . processElection . cnvList

giveNetworkString :: [[String]] -> String
giveNetworkString = prettyNetwork .cnvResult . giveElecResult . processElection . cnvList


giveJSONResult :: [[String]] -> [[String]]
giveJSONResult =jsonElecResult .cnvResult .giveElecResult .processElection . cnvList

givePrefOrder :: [[String]] ->String
givePrefOrder = show . unCnvList . processElection . cnvList

giveEdgeStrength :: [[String]] -> String
giveEdgeStrength = show . givePrefMap . cnvList