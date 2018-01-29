-- / A Lib module
module Lib
    (
    process
    )
where
import DataDefinitions

update :: State -> Event -> State
update (Empty_State) (Add_File (EDRL_File a b)) = Filled_State (Missing_Vars [a]) (Available_Vars [b])
update (Filled_State (Missing_Vars (mi)) (Available_Vars (av))) (Add_File (EDRL_File a b)) = Filled_State (Missing_Vars (a:mi)) (Available_Vars (b:av))
update s (Start_Execution a) = s
update s (Trigger_Event a) = s
update s (Read_Output) = s

updateMissing :: Missing_Vars -> Event -> Missing_Vars
update (Missing_Vars (mv)) (Add_File (EDRL_File inp out)) = Missing_Vars  (inp:mv)
update (Missing_Vars (mv))

process :: State -> [Event] -> State
process s (first:remaining) = process (update s first) remaining
process s [] = s


DUMP∷

updateMissing missing available newInput newOutput = if newInput not in available then (newInput:missing) else if newOutput in missing then remove missing newOutput else missing
updateAvailable available newOutput = if newOutput in available then error else (newOutput:available)
updateFollowedBy followedBy newInput newOutput = ((newInput,newOutput):followedBy)

varUpdate vars varName newVarValue = (add (remove vars varName) (varName,newVarValue))
varsUpdate vars [(varName,varValue):more] = varsUpdate (varUpdate vars varName varValue) more
varsUpdate vars [] = vars

calculateNext vars [(varName,changedVarValue):moreChangedVars] functions [function:notProcessedFunctions] = calculateNext (moreChangedVars:(function varName changedVarValue)) 
