-- | stellt den Einstiegspunkt in die Application dar
-- kümmert sich um das einlesen und interpretieren der Nutzereingaben
-- und das ansteuern des Interpreter
module Main where
import Interpreter
import DataDefinitions
import YMLReader
import Data.Yaml
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import qualified Data.Set as Set
import qualified Data.Map.Strict as Map
import qualified Data.Maybe as Maybe

-- | liest eine String-liste ein und covertiert es zu einem 'Event'
retrieve_Event ::  IO Event
retrieve_Event = do
   str <- readLn :: IO [String]
   event <- dispatchToEvent str
   return event


-- | convertiert String-listen zu 'Event'
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


-- | Einstiegspunkt. Startet die Application im leeren Zustand
main :: IO State
main = run (State Set.empty Set.empty [] Map.empty Map.empty [] )

-- | Liest in einer Schleife events ein und verarbeitet sie
run :: State -> IO State
run s = do
  event <- retrieve_Event
  state <- (if event == Error
    then do
      putStr "I have not Clue what you mean with any of that"
      return s
    else do
      newState <- process s [event]
      return newState)
  run state
