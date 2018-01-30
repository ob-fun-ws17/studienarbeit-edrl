{-# LANGUAGE DeriveGeneric #-}
module YMLReader
where
import qualified Data.Yaml as Y
import Data.Yaml (FromJSON(..), (.:))
import GHC.Generics

data Relation = Relation { input :: [String], output :: String, rule :: [String]  } deriving (Generic,Eq,Show)
data Application_Input = Application_Input { inputname ::String, origin::String } deriving (Generic,Eq,Show)
data Application_Output = Application_Output { outputname ::String, target::String } deriving (Generic,Eq,Show)
data Application = Application { appinput :: [Application_Input], appoutput :: [Application_Output] } deriving (Generic,Eq,Show)

instance FromJSON Relation
instance FromJSON Application_Input
instance FromJSON Application_Output
instance FromJSON Application
