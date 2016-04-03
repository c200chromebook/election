{-# LANGUAGE OverloadedStrings #-}
module Main (main) where
import qualified Data.Text.Lazy as T
import qualified Data.ByteString.Lazy.Char8 as B
import Web.Scotty
import Data.Aeson
import Prelude
import Data.Maybe
import qualified EndToEndElect as E

decodedList :: B.ByteString -> [[String]]
decodedList x = (fromJust .decode $ x :: [[String]])

-- if gchi, run this :set -XOverloadedStrings
main :: IO ()
main = scotty 3000 $ do
    get "/result/:echo" $ do
        str <- param "echo" :: ActionM String
        html $ T.pack . E.giveRankedList . decodedList $ B.pack str
    get "/network/:echo" $ do
        str <- param "echo" :: ActionM String
        html $ T.pack . E.giveNetworkString . decodedList $ B.pack str
