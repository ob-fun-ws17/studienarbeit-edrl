{-# LANGUAGE ScopedTypeVariables #-}
module DataDefinitionsSpec(spec) where

import DataDefinitions
import Test.Hspec
import Test.QuickCheck

spec :: Spec
spec =
  describe "namedValue" $ do
    it "can be constructed with Double Datatype" $
      show (Named_Value "varName" 7.0) `shouldBe` "Named_Value {name = \"varName\", value = 7.0}"
