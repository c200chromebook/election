module Election where
import qualified Data.List as List
import qualified Data.Map as Map
type Candidate = String
type Prefd = Candidate
type Lesser = Candidate
type Ballot = [Candidate]
type Election = [Ballot]
type Preference = (Prefd,Lesser)
type TotPref = Integer
type PreferenceMap = Map.Map Preference TotPref
type BallotResult = [[Preference]]

blankPrefMap :: PreferenceMap
blankPrefMap = Map.empty

incrementVote :: TotPref -> (TotPref)
incrementVote x = x+1

decrementVote :: TotPref -> (TotPref)
decrementVote x = x-1

--Flip those pairs where negative preferences emerge, and preserve null preferences by (x,x) and (y,y)
absReferences :: [(Preference,Integer)] -> [(Preference,Integer)]
absReferences [] = []
absReferences (((over,under),str):rst)
   | str < 0  = ((under,over),-str):absReferences(rst)
   | str == 0 = ((under,under),0):((over,over),0):absReferences(rst)
   | otherwise= ((over,under),str):absReferences(rst)


rollRest :: (Eq b) => [a] -> b -> [(a,b)] -> [[a]]
rollRest prevVals _ [] = [prevVals]
rollRest prevVals prevKey ((curVal,curKey):rst)
   |  curKey == prevKey = rollRest (curVal:prevVals) curKey rst
   |  otherwise         = prevVals:(rollRest [curVal] curKey rst)

rollGroup :: (Eq b) =>  [(a,b)] -> [[a]]
rollGroup []          = []
rollGroup ((a,b):rst) = rollRest [a] b rst

insertPrefMap :: PreferenceMap -> Preference -> PreferenceMap
insertPrefMap prefMap (over,under)
   | Map.member (over,under) prefMap = Map.adjust incrementVote (over,under) prefMap
   | Map.member (under,over) prefMap = Map.adjust decrementVote (under,over) prefMap
   | otherwise                       = Map.insert (over,under) 1 prefMap

givePrefMap :: Election -> PreferenceMap
givePrefMap elec = foldl insertPrefMap blankPrefMap $ concat (map (givePrefs . List.nub) elec)

processElection :: Election -> BallotResult
processElection = orderPrefStrength . givePrefMap


orderPrefStrength :: PreferenceMap -> BallotResult
orderPrefStrength prefMap = rollGroup . reverse. List.sortOn (\ (_,a) -> a) . absReferences . Map.assocs $ prefMap

givePrefs :: Ballot -> [Preference]
givePrefs [] = []
givePrefs (x:xs) = (map (\item-> (x,item)) xs)++givePrefs xs