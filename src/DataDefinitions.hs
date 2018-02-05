module DataDefinitions where

import Data.Set (Set)
import qualified Data.Set as Set
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map
import YMLReader

data Named_Value =
  Named_Value {name :: String , value:: Double}
  deriving(Eq,Show,Ord)
data Event =
  Add_Relation Relation
  | Start_Execution Application
  | Read_Output
  | Trigger_Event (Named_Value)
  deriving(Eq,Show)
data State =
  State {missing ::Set String, available :: Set String, values :: [Named_Value], order :: Map String [String], functions :: Map String [String], errors :: [String]}  --finally my own State !!
  deriving(Eq,Show)
