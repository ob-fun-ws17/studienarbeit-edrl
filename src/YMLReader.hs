{-# LANGUAGE DeriveGeneric #-}
-- / Reads YML-Files
module YMLReader
where
import qualified Data.Yaml as Y
import Data.Yaml (FromJSON(..), (.:))
import GHC.Generics

data Relation = Relation { input :: [String], out :: String, rule :: [String]  } deriving (Generic,Eq,Show)

instance FromJSON Relation
