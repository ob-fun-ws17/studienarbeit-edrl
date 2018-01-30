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
update s (Add_Relation rel) = State (Set.union (missing s) (Set.fromList (input rel))) (Set.insert (output rel) (available s) ) (values s) (order s) (functions s)
update s (Start_Execution app) = State (Set.difference (missing s) (available s)) (Set.union (available s) (Set.fromList (map inputname ( appinput app)))) (values s) (order s) (functions s)
update s (Trigger_Event a) = State (missing s) (available s) (values s)(order s) (functions s)
update s (Read_Output) = s


process :: State -> [Event] -> State
process s (first:remaining) = process (update s first) remaining
process s [] = s
