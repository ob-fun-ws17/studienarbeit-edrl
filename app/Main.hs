module Main where
import Lib
import DataDefinitions



retrieve_Event ::  IO Event
retrieve_Event = do
   str <- readLn :: IO String
   putStrLn ("you typed " ++ show str)
   return Read_Output

main :: IO State
main = run Empty_State

run :: State -> IO State
run s = do
  event <- retrieve_Event
  let state = process s [event]
  run state
