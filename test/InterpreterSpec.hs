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
      (update emptyState Recompute) `shouldBe` emptyState
    it "collects missing variables" $
      (missing $ update emptyState $ Add_Relation $ Relation ["input1"] "output1" ["rule1"])
       `shouldBe` Set.singleton "input1"
    it "collects available variables" $
      (available $ update emptyState $ Add_Relation $ Relation ["input1"] "output1" ["rule1"])
       `shouldBe` Set.singleton "output1"
    it "collects multiple available variables" $
      (available $ foldr update' emptyState [Add_Relation (Relation ["input1"] "output1" ["rule1"]),Add_Relation (Relation ["input2"] "output2" ["rule2"])])
      `shouldBe` Set.fromList ["output1","output2"]
    it "collects multiple missing variables" $
      (missing $ foldr update' emptyState [Add_Relation (Relation ["input1"] "output1" ["rule1"]),Add_Relation (Relation ["input2"] "output2" ["rule2"])])
       `shouldBe` Set.fromList ["input1","input2"]
    it "deletes missing variables once provided" $
      (missing $ foldr update' emptyState [Add_Relation (Relation ["input1"] "output1" ["rule1"]),Add_Relation (Relation ["output1"] "output2" ["rule2"])])
      `shouldBe` Set.fromList ["input1"]
