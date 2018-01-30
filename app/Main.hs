module Main where
import Lib
import DataDefinitions
import qualified Data.Set as Set
import qualified Data.Map.Strict as Map


retrieve_Event ::  IO Event
retrieve_Event = do
   str <- readLn :: IO String
   putStrLn ("you typed " ++ show str)
   return Read_Output

main :: IO State
main = run (State Set.empty Set.empty [] Map.empty Map.empty)

run :: State -> IO State
run s = do
  event <- retrieve_Event
  let state = process s [event]
  run state
