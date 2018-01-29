{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
-- / Reads YML-Files
module YMLReader
where
import qualified Data.Yaml as Y
import Data.Yaml (FromJSON(..), (.:))
import GHC.Generics

data Relation = Relation { input :: [String], out :: String, rule :: [String]  } deriving (Generic,Eq,Show)
data Application_Input = Application_Input { name ::String, origin::String } deriving (Generic,Eq,Show)
data Application_Output = Application_Output { name ::String, target::String } deriving (Generic,Eq,Show)
data Application = Application { input :: [Application_Input], out :: [Application_Output] } deriving (Generic,Eq,Show)


instance FromJSON Relation
instance FromJSON Application_Input
instance FromJSON Application_Output
instance FromJSON Application
