module CIConverters where
import EvalElection
import Data.Graph.Inductive.Graph
import qualified Data.CaseInsensitive as C
--CI  = Case Insensitive - should eventually be able to fmap this with appropriate types but yolo


cnvList :: [[String]]-> [[C.CI String]]
cnvList = map (map C.mk)

unCnvList :: [[(C.CI String,C.CI String)]] -> [[(String,String)]]
unCnvList = map (map (\(x,y) -> (C.original x,C.original y)))

cnvResult :: (ELabelGr (C.CI String),[(Int,[C.CI String])]) -> (ELabelGr String,[(Int,[String])])
cnvResult (gr,xs) =(nmap C.original gr,map (\ (a,b)-> (a,map C.original b)) xs)