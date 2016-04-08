{-# LANGUAGE OverloadedStrings #-}
module Main (main) where
import qualified Data.Text.Lazy as T
import qualified Data.ByteString.Lazy.Char8 as B
import Web.Scotty
import qualified Data.Aeson as A
import Prelude
import Data.Maybe
import qualified EndToEndElect as E

decodedList :: B.ByteString -> [[String]]
decodedList x = (fromJust .A.decode $ x :: [[String]])



-- if gchi, run this :set -XOverloadedStrings
-- Todo: Clean this up
main :: IO ()
main = scotty 3000 $ do
    post "/result/:any" $ do
        str <- param "payload" :: ActionM String
        html $ T.pack . E.giveRankedList . decodedList $ B.pack str
    post "/jsonResult/:echo" $ do
        str <- param "payload" :: ActionM String
        json $ E.giveJSONResult . decodedList $ B.pack str
    post "/network/:echo" $ do
        str <- param "payload" :: ActionM String
        html $ T.pack . E.giveNetworkString . decodedList $ B.pack str
    post "/resOrder/:echo" $ do
        str <- param "payload" :: ActionM String
        html $ T.pack . E.givePrefOrder . decodedList $ B.pack str
    post "/edgeStr/:echo"  $ do
        str <- param "payload" :: ActionM String
        html $ T.pack . E.giveEdgeStrength . decodedList $ B.pack str
