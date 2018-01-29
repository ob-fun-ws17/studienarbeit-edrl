module Main where

import System.IO(BufferMode(NoBuffering), hSetBuffering, stdout)

data Domain =
  Domain Int
  deriving(Eq,Show)
data Event =
  EventAdd Int
  | EventMultiply Int
  | EventExit
  deriving(Eq,Show)

dmUpdate :: Domain -> Event -> Domain
dmUpdate (Domain v) (EventAdd a) = Domain (v + a)
dmUpdate (Domain v) (EventMultiply a) = Domain (v * a)
dmUpdate dm _ = dm

uiUpdate :: Domain -> IO [Event]
uiUpdate (Domain v) = do
  putStrLn $ "Value is now: " ++ show v
  if v < 50 then
    return [EventAdd 1, EventMultiply 2]
  else
    return [EventExit]

run :: Domain -> [Event] -> IO ()
run dm [] = do
  events <- uiUpdate dm
  run dm events
run _ (EventExit:_) =
  return ()
run dm (e:es) =
  run (dmUpdate dm e) es

main :: IO ()
main = run (Domain 0) []
