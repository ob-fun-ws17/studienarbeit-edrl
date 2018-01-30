module DataDefinitions where

import Data.Set (Set)
import qualified Data.Set as Set
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map
import YMLReader

data Named_Value a =
  Named_Value String a
  deriving(Eq,Show)
data Event =
  Add_Relation Relation
  | Start_Execution Application
  | Recompute
  | Read_Output
  | Trigger_Event (Named_Value String)
  deriving(Eq,Show)
data State =
  State {missing ::Set String, available :: Set String, values :: [Named_Value String], order :: Map String [String], functions :: Map (String,String) [String]}  --finally my own State !!
  deriving(Eq,Show)
