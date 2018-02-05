{-# LANGUAGE DeriveGeneric #-}
-- | Das Modul YMLReader stellt Typen zur Verfügung, die aus yml-files eingelesen werden können
module YMLReader
where
import qualified Data.Yaml as Y
import Data.Yaml (FromJSON(..), (.:))
import GHC.Generics
-- | repräsentiert eine einlesbare Relation
data Relation = Relation { input :: [String], output :: String, rule :: [String]  } deriving (Generic,Eq,Show)
instance FromJSON Relation
-- | input, bestehend aus name und Quelle
data Application_Input = Application_Input { inputname ::String, origin::String } deriving (Generic,Eq,Show)
instance FromJSON Application_Input
-- | output, bestehend aus name und Ziel (Ziel wird aktuell noch nicht verwendet)
data Application_Output = Application_Output { outputname ::String, target::String } deriving (Generic,Eq,Show)
instance FromJSON Application_Output
-- | repräsentiert eine einlesbare Applikation, bestehend aus mehreren in und outputs
data Application = Application { appinput :: [Application_Input], appoutput :: [Application_Output] } deriving (Generic,Eq,Show)
instance FromJSON Application
