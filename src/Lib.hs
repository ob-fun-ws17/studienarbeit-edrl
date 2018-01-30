module Lib
    (
    process
    )
where
import DataDefinitions
import YMLReader
import Data.Set (Set)
import qualified Data.Set as Set

update :: State -> Event -> State
update s (Add_Relation rel) = update (s { missing = (Set.union (missing s) (Set.fromList (input rel))), available = (Set.insert (output rel) (available s))}) Recompute
update s (Start_Execution app) = update  (s {available = (Set.union (available s) (Set.fromList (map inputname ( appinput app))))}) Recompute
update s (Trigger_Event a) = s
update s (Recompute) = s { missing = (Set.difference (missing s) (available s))}
update s (Read_Output) = s


process :: State -> [Event] -> State
process s (first:remaining) = process (update s first) remaining
process s [] = s
