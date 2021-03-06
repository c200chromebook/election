module EvalElection where
import Data.Graph.Inductive.PatriciaTree
import Data.Graph.Inductive.Graph
import Data.Graph.Inductive.Query.DFS
import Data.Graph.Inductive.Query.BFS
import qualified Data.List as List
import qualified Data.Map as Map
import qualified Data.Bimap as Bimap
import Data.Bimap ((!),(!>))

-- Named Edge
type NEdge a =(a,a)
type NList a= [[NEdge a]]
type NMap a=Bimap.Bimap Int a
--Element labeled graph (no labels on edges)
type ELabelGr a =Gr a ()


newtype  ResultPair a b =  ResultPair (a,b)
instance (Eq b) => Eq (ResultPair a b) where
 (==) (ResultPair (_,j)) (ResultPair (_,k)) = j==k
instance (Ord b) => Ord (ResultPair a b) where
 compare (ResultPair (_,j)) (ResultPair (_,k)) = compare j k

yieldPair :: ResultPair a b -> (a,b)
yieldPair (ResultPair (a,b)) = (a,b)
--gives unique names
uniqueFromNList :: (Eq a) => NList a -> [a]
uniqueFromNList = List.nub . concat . (map (\ (a,b) -> [a,b])) . concat

--gives bimap of element num to ord identifier
bimapFromNList :: (Ord a) => NList a -> NMap a
bimapFromNList nList= Bimap.fromList (zip [1..] (uniqueFromNList (nList)))


addNodes :: NMap a -> ELabelGr a
addNodes nList = mkGraph (Bimap.toList nList) []



giveUEdgeList :: (Ord a) => NMap a-> [[NEdge a]] -> [[UEdge]]
giveUEdgeList _ [] = []
giveUEdgeList nMap (fstList:rst) = (map (\ (a,b) -> (nMap !> a,nMap !> b,())) fstList):(giveUEdgeList nMap rst)


stripLabel :: LEdge a -> Edge
stripLabel (a,b,_) = (a,b)

addLabel :: Edge -> UEdge
addLabel (a,b) = (a,b,())

edgesInCycles :: Gr a b -> [Edge]
edgesInCycles gr = [anEdge |anEdge<-allEdges, any (edgeInList anEdge) connNodeList]
   where
         edgeInList (a,b) xs  = (a `elem` xs) && (b `elem` xs)
         allEdges = edges gr
         connNodeList = (scc gr)


joinExcludeCycles :: Gr a () -> [UEdge] -> Gr a ()
joinExcludeCycles gr eList = insEdges (map addLabel finalJoin) gr
   where
         finalJoin = filter  (`notElem` dontJoin) (map stripLabel eList)
         dontJoin = edgesInCycles initialJoin
         initialJoin = insEdges eList gr


processElecResult :: (Ord a) => NList a -> (ELabelGr a,NMap a)
processElecResult nList=(foldl joinExcludeCycles nodeOnlyMap nodeListsToJoin,uniques)
  where
         uniques = bimapFromNList nList
         nodeOnlyMap = addNodes uniques
         nodeListsToJoin = giveUEdgeList uniques nList




giveElecResult ::(Ord a) => NList a ->(ELabelGr a,[(Int,[a])])
giveElecResult elec = (resultGraph,finalResults )
  where
     (resultGraph,biMap) = processElecResult elec
     resultPair = map (\x -> ResultPair (head x,length $ x `dfs` resultGraph)) (map (\x->[x])(nodes resultGraph))  -- (node, descentent nodes)
     groupedResults =  List.group . List.sort $ resultPair
     finalResults = reverse [(snd .yieldPair . head $ aGrp, map ((!) biMap) $ map (fst.yieldPair) aGrp ) |aGrp <-groupedResults]


--Pretty Printing, in the event of strings
jsonElecResult :: (ELabelGr String,[(Int,[String])]) -> [[String]]
jsonElecResult result = [show (x-1) : y | (x,y) <-snd result]


prettyElecResult :: (ELabelGr String,[(Int,[String])]) -> String
prettyElecResult result = List.intercalate "\n" [show (x-1) ++":" ++ (List.intercalate "," y) | (x,y) <-snd result]

prettyNetwork :: (ELabelGr String,[(Int,[String])]) -> String
prettyNetwork = prettify . fst


