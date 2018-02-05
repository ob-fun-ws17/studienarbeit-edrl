module Main where
import Lib
import DataDefinitions
import YMLReader
import Data.Yaml
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import qualified Data.Set as Set
import qualified Data.Map.Strict as Map
import qualified Data.Maybe as Maybe


retrieve_Event ::  IO Event
retrieve_Event = do
   str <- readLn :: IO [String]
   event <- dispatchToEvent str
   return event

dispatchToEvent :: [String] -> IO Event
dispatchToEvent ["add_relation",a] = do
  file <- BS.readFile a
  let rel = (decode file :: Maybe Relation) in
    return $ if rel == Nothing then Error else Add_Relation $ Maybe.fromJust rel
dispatchToEvent ["start_execution",a] =do
  file <- BS.readFile a
  let app = (decode file :: Maybe Application) in
    return $ if app == Nothing then Error else Start_Execution $ Maybe.fromJust app
dispatchToEvent ["change",a,b] = do return $ Trigger_Event $ Named_Value a $ ((read b)::Double)
dispatchToEvent ["read",a] = do
  file <- BS.readFile a
  let app = (decode file :: Maybe Application) in
    return $ if app == Nothing then Error else Read_Output $ Maybe.fromJust app
dispatchToEvent _ = do return Error

main :: IO State
main = run (State Set.empty Set.empty [] Map.empty Map.empty [] )

run :: State -> IO State
run s = do
  event <- retrieve_Event
  state <- (if event == Error
    then do
      putStr "Sorry, i didnt understand that"
      return s
    else do
      newState <- process s [event]
      return newState)
  run state
