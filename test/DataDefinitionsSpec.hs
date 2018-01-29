{-# LANGUAGE ScopedTypeVariables #-}
module DataDefinitionsSpec(spec) where

import DataDefinitions
import Test.Hspec
import Test.QuickCheck

spec :: Spec
spec =
  describe "namedValue" $ do
    it "can be constructed with String Datatype" $
      show (String_Value "varName" "varValue") `shouldBe` "String_Value \"varName\" \"varValue\""
    it "can be constructed with Integer Datatype" $
      show (Integer_Value "varName" 7) `shouldBe` "Integer_Value \"varName\" 7"
