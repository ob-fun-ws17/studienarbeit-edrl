-- | Das Modul DataDefinitions stellt Typen zur Verfügung, welche für die Steuerung des Interpreters relevant sind.
module DataDefinitions where

import Data.Set (Set)
import qualified Data.Set as Set
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map
import YMLReader
-- | Ein mit Namen versehener Wert, wird für EDRL-Variablen verwendet
data Named_Value =
  Named_Value {name :: String , value:: Double}
  deriving(Eq,Show,Ord)
-- | Stellt die verschiedenen von der Applikation verwendeten Events zur Verfügung.
-- Achtung: nicht an jeder Stelle ist jedes Event möglich
data Event =
  Add_Relation Relation
  | Start_Execution Application
  | Read_Output Application
  | Error
  | Trigger_Event (Named_Value)
  deriving(Eq,Show)
-- | Der Zustand der Application. nicht zu verwechseln mit der Monade State
data State =
  State {missing ::Set String
    , available :: Set String
    , values :: [Named_Value]
    , order :: Map String [String]
    , functions :: Map String [String]
    , errors :: [String]}
  deriving(Eq,Show)
