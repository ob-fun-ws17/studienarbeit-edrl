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

emptyState = State Set.empty Set.empty [] Map.empty Map.empty

spec :: Spec
spec =
  describe "process" $ do
    it "processes Events" $
      (process emptyState [Read_Output]) `shouldBe` emptyState
    it "collects missing and available variables" $
      (process emptyState [
      Add_Relation(Relation ["input1"] "output1" ["rule1"])
      ]) `shouldBe`
      emptyState {missing = Set.singleton "input1" , available = Set.singleton "output1"}
    it "collects multiple missing variables" $
      (process emptyState [
      Add_Relation(Relation ["input1"] "output1" ["rule1"])
      ,Add_Relation(Relation ["input2"] "output2" ["rule2"])
      ]) `shouldBe`
      emptyState {missing = Set.fromList ["input1","input2"] , available =Set.fromList ["output1","output2"]}
    it "deletes missing variables once provided" $
      (process emptyState [
      Add_Relation(Relation ["input1"] "output1" ["rule1"])
      ,Add_Relation(Relation ["output1"] "output2" ["rule2"])
      ]) `shouldBe`
      emptyState {missing = Set.fromList ["input1"] , available =Set.fromList ["output1","output2"]}
