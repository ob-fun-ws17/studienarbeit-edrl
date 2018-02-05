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
update s (Add_Relation rel) = s {
  missing = computeMissingAfterRelationAddon s rel
  ,available = computeAvailableAfterRelationAddon s rel
  ,functions = Map.insert (output rel) (rule rel) (functions s)
  ,order = Map.union
    (foldr
      (Map.alter $ \val -> if val == Nothing then Just [output rel] else Just $ (output rel):(Maybe.fromJust val) )
      (order s)
      (input rel)
      )
    (Map.singleton (output rel) [])
  ,values = if (length (rule rel)) == 1 then (Named_Value (output rel) (evaluateExpression s (rule rel) ) ):(values s) else (values s)
  }
update s (Start_Execution app) =
  let startValues = map (uncurry Named_Value) $ map (\input -> (inputname input, (read (origin input)) ::Double)) (appinput app) in
    let availableVars =  computeAvailableAfterApplicationAddon s app in
      let  missingVars = Set.difference (missing s) availableVars
        in
          foldr update' s{
          available = availableVars
          ,missing = missingVars
          ,functions = foldl insert' (functions s) (appinput app)
          ,values = startValues ++ (values s)
          } $ (map Trigger_Event startValues)
update s (Trigger_Event namedVal) =
  let newState = changeValue s namedVal in
    let triggerEventList = do {
      lookedUp <- ( Map.lookup (name namedVal) (order newState) )
      ; return $ map  Trigger_Event $ map (reCalculateValue newState) lookedUp
      } in
      if triggerEventList == Nothing then s{errors = ("Error finding following Variables for: " ++ (name namedVal) ++ " in " ++ (show newState)):(errors newState)}
        else foldl update newState (Maybe.fromJust triggerEventList)
update s (Recompute) = s { missing = Set.difference (missing s) (available s)}

insert' ma (Application_Input name val) = Map.insert name [val] ma
update' :: Event -> State -> State
update' e s = update s e

evaluateExpression :: State -> [String] -> Double
evaluateExpression s [a,"div",b] = (retrieveValue s a) / (retrieveValue s b)
evaluateExpression s [a,"mul",b] = (retrieveValue s a) * (retrieveValue s b)
evaluateExpression s [a,"add",b] = (retrieveValue s a) + (retrieveValue s b)
evaluateExpression s [a] = read a


retrieveValue :: State -> String -> Double
retrieveValue s valueName =
  let resultList =  filter (named valueName) (values s) in
    if null resultList then -1234 else value $ head $ resultList


reCalculateValue :: State -> String -> Named_Value
reCalculateValue s recalculated = Named_Value recalculated $ evaluateExpression s $ Maybe.fromJust $ Map.lookup recalculated $ functions s

changeValue :: State -> Named_Value -> State
changeValue s namedVal =  s {values = namedVal:(filter (not . named (name namedVal)) (values s)) }

named :: String -> Named_Value -> Bool
named key (Named_Value name _) = (name == key)

computeAvailableAfterApplicationAddon s app = Set.union (available s) $ Set.fromList $ map inputname $ appinput app
computeMissingAfterRelationAddon s rel = Set.union (missing s) $ Set.fromList $ input rel
computeAvailableAfterRelationAddon s rel = Set.insert (output rel) (available s)

process :: State -> [Event] -> IO State
process s (Read_Output:remaining) = do  putStrLn ("current State is" ++ show s) >> process s remaining
process s (first:remaining) = do
  process (update s first) remaining
process s [] = do return s
