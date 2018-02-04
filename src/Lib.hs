module Lib
    (
    process,
    update,
    update'
    )
where
import DataDefinitions
import YMLReader
import Data.Set (Set)
import qualified Data.Set as Set
import qualified Data.Maybe as Maybe
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map

update :: State -> Event -> State
update s (Add_Relation rel) = update' Recompute $ s {
  missing = computeMissingAfterRelationAddon s rel
  ,available = computeAvailableAfterRelationAddon s rel
  ,functions = Map.insert (output rel) (rule rel) (functions s)
  ,order = Map.mapWithKey (\key value -> if elem key (input rel) then (output rel):value else value ) (order s)
  }
update s (Start_Execution app) = update' Recompute $ s {
  available = computeAvailableAfterApplicationAddon s app,
  functions = foldl insert' (functions s) (appinput app)
  }
update s (Trigger_Event namedVal) = foldr update' (changeValue s namedVal)
  $ map Trigger_Event
    $ map (reCalculateValue s)
      $ Maybe.fromJust $ Map.lookup (name namedVal) (order s)
update s (Recompute) = s { missing = Set.difference (missing s) (available s)}

insert' ma (Application_Input name val) = Map.insert name [val] ma

update' :: Event -> State -> State
update' e s = update s e

evaluateExpression :: State -> [String] -> Double
evaluateExpression s [a,"div",b] = (retrieveValue s a) / (retrieveValue s b)
evaluateExpression s [a,"add",b] = (retrieveValue s a) + (retrieveValue s b)
evaluateExpression s [a] = read a


retrieveValue :: State -> String -> Double
retrieveValue s valueName = value $ head $ filter (named valueName) (values s)

reCalculateValue :: State -> String -> Named_Value
reCalculateValue s recalculated = Named_Value recalculated $ evaluateExpression s $ Maybe.fromJust $ Map.lookup recalculated $ functions s

changeValue :: State -> Named_Value -> State
changeValue s namedVal =  s {values = namedVal:(filter (notNamed (name namedVal)) (values s)) }

notNamed key (Named_Value name _) = not (name == key)
named key (Named_Value name _) = (name == key)
computeAvailableAfterApplicationAddon s app = Set.union (available s) $ Set.fromList $ map inputname $ appinput app
computeMissingAfterRelationAddon s rel = Set.union (missing s) $ Set.fromList $ input rel
computeAvailableAfterRelationAddon s rel = Set.insert (output rel) (available s)

process :: State -> [Event] -> IO State
process s (Read_Output:remaining) = do  putStrLn ("current State is" ++ show s) >> process s remaining
process s (first:remaining) = do
  process (update s first) remaining
process s [] = do return s
