{-# LANGUAGE ScopedTypeVariables #-}
module DataDefinitionsSpec(spec) where

import DataDefinitions
import Test.Hspec
import Test.QuickCheck

spec :: Spec
spec =
  describe "namedValue" $ do
    it "can be constructed with String Datatype" $
      show (Named_Value "varName" "varValue") `shouldBe` "Named_Value \"varName\" \"varValue\""
    it "can be constructed with Integer Datatype" $
      show (Named_Value "varName" 7) `shouldBe` "Named_Value \"varName\" 7"
