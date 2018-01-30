module Lib
    (
    process,
    update
    )
where
import DataDefinitions
import YMLReader
import Data.Set (Set)
import qualified Data.Set as Set

update :: State -> Event -> State
update s (Add_Relation rel) = update' Recompute $ s { missing = computeMissingAfterRelationAddon s rel, available = computeAvailableAfterRelationAddon s rel}
update s (Start_Execution app) = update' Recompute $ s {available = computeAvailableAfterApplicationAddon s app }
update s (Trigger_Event a) =  s
update s (Recompute) = s { missing = Set.difference (missing s) (available s)}

update' :: Event -> State -> State
update' e s = update s e

computeAvailableAfterApplicationAddon s app = Set.union (available s) $ Set.fromList $ map inputname $ appinput app
computeMissingAfterRelationAddon s rel = Set.union (missing s) $ Set.fromList $ input rel
computeAvailableAfterRelationAddon s rel = Set.insert (output rel) (available s)

process :: State -> [Event] -> IO State
process s (Read_Output:remaining) = do  putStrLn ("current State is" ++ show s) >> process s remaining
process s (first:remaining) = do
  process (update s first) remaining
process s [] = do return s
