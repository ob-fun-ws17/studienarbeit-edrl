{-# LANGUAGE ScopedTypeVariables #-}
module InterpreterSpec(spec) where

import Lib
import DataDefinitions
import Test.Hspec
import Test.QuickCheck

spec :: Spec
spec =
  describe "process" $ do
    it "processes Events" $
      (process Empty_State [Read_Output]) `shouldBe` Empty_State
    it "collects missing and available variables" $
      (process Empty_State [Add_File (EDRL_File "name1" "name2")]) `shouldBe` Filled_State (Missing_Vars ["name1"]) (Available_Vars ["name2"])
    it "collects multiple missing variables" $
      (process Empty_State [Add_File (EDRL_File "var1" "out1"),Add_File (EDRL_File "var2" "out2")]) `shouldBe` Filled_State (Missing_Vars ["var2","var1"]) (Available_Vars ["out2","out1"])
--    it "deletes missing variables once provided" $
--      (process Empty_State [Add_File (EDRL_File "var1" "out1"),Add_File (EDRL_File "out1" "out2")]) `shouldBe` Filled_State (Missing_Vars ["var1"]) (Available_Vars ["out2","out1"])
