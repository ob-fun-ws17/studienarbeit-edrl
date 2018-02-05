{-# LANGUAGE ScopedTypeVariables #-}
module InterpreterSpec(spec) where

import Lib
import YMLReader
import DataDefinitions
import Test.Hspec
import Test.QuickCheck
import Data.Set (Set)
import qualified Data.Set as Set
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map

emptyState = State Set.empty Set.empty [] Map.empty Map.empty []

spec :: Spec
spec =
  describe "process" $ do
    it "processes Events" $
      (update emptyState $ Start_Execution $ Application [] []) `shouldBe` emptyState
    it "collects missing variables" $
      (missing $ update emptyState $ Add_Relation $ Relation ["input1"] "output1" ["rule1"])
       `shouldBe` Set.singleton "input1"
    it "collects available variables" $
      (available $ update emptyState $ Add_Relation $ Relation ["input1"] "output1" ["rule1"])
       `shouldBe` Set.singleton "output1"
    it "collects multiple available variables" $
      (available $ foldl update emptyState [Add_Relation (Relation ["input1"] "output1" ["rule1"]),Add_Relation (Relation ["input2"] "output2" ["rule2"])])
      `shouldBe` Set.fromList ["output1","output2"]
    it "collects multiple missing variables" $
      (missing $ foldl update emptyState [Add_Relation (Relation ["input1"] "output1" ["rule1"]),Add_Relation (Relation ["input2"] "output2" ["rule2"])])
       `shouldBe` Set.fromList ["input1","input2"]
    it "deletes missing variables once provided" $
      (missing $ foldl update emptyState [
        Add_Relation (Relation ["input1"] "output1" ["rule1"])
        ,Add_Relation (Relation ["output1"] "output2" ["rule2"])
        ,Start_Execution (Application [] [])
        ])
      `shouldBe` Set.fromList ["input1"]
    it "can interpret a simple calculation" $
      (foldl update emptyState [
        Add_Relation (Relation [] "const1" ["720"])
        ,Add_Relation (Relation ["const1","const2"] "result" ["const1","div","const2"])
        ,Start_Execution (Application [Application_Input "const2" "2"] [])
        ])
      `shouldBe` emptyState {
        missing = Set.fromList []
        , available = Set.fromList ["const1","const2","result"]
        , values = [Named_Value {name = "result", value = 360.0}
        ,Named_Value {name = "const2", value = 2.0}
        ,Named_Value {name = "const1", value = 720.0}]
        , order = Map.fromList [("const1",["result"]),("const2",["result"]),("result",[])]
        , functions = Map.fromList [("const1",["720"]),("const2",["2"]),("result",["const1","div","const2"])]
        , errors = []}
    it "can update values" $
      (update emptyState {
        missing = Set.fromList []
        , available = Set.fromList ["const1","result","const2"]
        , values = [Named_Value "const1" 720,Named_Value "const2" 2,Named_Value "result" 360]
        , order = Map.fromList [("const1",["result"]),("const2",["result"]),("result",[])]
        , functions = Map.fromList [("const1",["720"]),("result",["const1","div","const2"])]
        } $ Trigger_Event $ Named_Value "const2" 3)
      `shouldBe` emptyState {
        missing = Set.fromList []
        , available = Set.fromList ["const1","result","const2"]
        , values = [Named_Value "result" 240,Named_Value "const2" 3,Named_Value "const1" 720]
        , order = Map.fromList [("const1",["result"]),("const2",["result"]),("result",[])]
        , functions = Map.fromList [("const1",["720"]),("result",["const1","div","const2"])]
        }
    it "can interpret a more complex calculation" $
      (Set.fromList $ values $ foldl update emptyState [
        Add_Relation (Relation [] "const1" ["720"])
        ,Add_Relation (Relation ["const1","const2"] "const3" ["const1","div","const2"])
        ,Add_Relation (Relation ["const1","const2"] "const4" ["const1","mul","const2"])
        ,Add_Relation (Relation ["const3","const4"] "result" ["const3","add","const4"])
        ,Start_Execution (Application [Application_Input "const2" "2"] [])
        ])
      `shouldBe` Set.fromList [Named_Value "const1" 720,Named_Value "const2" 2,Named_Value "const3" 360,Named_Value "const4" 1440, Named_Value "result" 1800]
    it "propagates changes correctly" $
      (Set.fromList $ values $ foldl update emptyState [
        Add_Relation (Relation [] "const1" ["720"])
        ,Add_Relation (Relation ["const1","const2"] "const3" ["const1","div","const2"])
        ,Add_Relation (Relation ["const1","const2"] "const4" ["const1","mul","const2"])
        ,Add_Relation (Relation ["const3","const4"] "result" ["const3","add","const4"])
        ,Start_Execution (Application [Application_Input "const2" "2"] [])
        ,Trigger_Event $ Named_Value "const2" 3
        ])
      `shouldBe` Set.fromList [Named_Value "const1" 720,Named_Value "const2" 3,Named_Value "const3" 240,Named_Value "const4" 2160, Named_Value "result" 2400]
