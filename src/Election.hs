module Election where
import qualified Data.List as List
import qualified Data.Map as Map
import qualified Data.CaseInsensitive as C

type Candidate a = a
type Ballot a = [Candidate a]
type Prefd a = Candidate a
type Lesser a = Candidate a
type Election a = [Ballot a]
type Preference a = (Prefd a,Lesser a)
type TotPref = Integer
type PreferenceMap a = Map.Map (Preference a) TotPref
type BallotResult a = [[Preference a]]

blankPrefMap :: PreferenceMap a
blankPrefMap = Map.empty

incrementVote :: TotPref -> (TotPref)
incrementVote x = x+1

decrementVote :: TotPref -> (TotPref)
decrementVote x = x-1

--Flip those pairs where negative preferences emerge, and preserve null preferences by (x,x) and (y,y)
absReferences :: [(Preference a,Integer)] -> [(Preference a,Integer)]
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

insertPrefMap :: (Ord a) => PreferenceMap a -> Preference a-> PreferenceMap a
insertPrefMap prefMap (over,under)
   | Map.member (over,under) prefMap = Map.adjust incrementVote (over,under) prefMap
   | Map.member (under,over) prefMap = Map.adjust decrementVote (under,over) prefMap
   | otherwise                       = Map.insert (over,under) 1 prefMap

givePrefMap :: (Ord a) => Election a-> PreferenceMap a
givePrefMap elec = foldl insertPrefMap blankPrefMap $ concat (map (givePrefs . List.nub) elec)

processElection :: (Ord a) => Election a-> BallotResult a
processElection = orderPrefStrength . givePrefMap


orderPrefStrength :: PreferenceMap a-> BallotResult a
orderPrefStrength prefMap = rollGroup . reverse. List.sortOn (\ (_,a) -> a) . absReferences . Map.assocs $ prefMap

givePrefs :: Ballot a -> [Preference a]
givePrefs [] = []
givePrefs (x:xs) = (map (\item-> (x, item)) xs)++givePrefs xs