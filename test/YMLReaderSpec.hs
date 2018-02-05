{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module YMLReaderSpec(spec) where

import Test.Hspec
import Test.QuickCheck
import Data.ByteString (ByteString)
import Data.Yaml
import Lib
import YMLReader
import DataDefinitions

relationYaml :: ByteString
relationYaml = "\
\input: \n\
\  - mouse-moved \n\
\  - screen-size \n\
\output: mouse-moved-percent \n\
\rule: \n\
\  - mouse-moved \n\
\  - div \n\
\  - screen-size \n\
\"

applicationYaml :: ByteString
applicationYaml = "\
\appinput: \n\
\  - inputname: const1 \n\
\    origin: \"12\" \n\
\appoutput: \n\
\  - outputname: result \n\
\    target: console \n\
\"




spec :: Spec
spec =
  describe "reader" $ do
    it "reads relations" $
      (decode relationYaml :: Maybe Relation) `shouldBe` Just (Relation ["mouse-moved","screen-size"] "mouse-moved-percent" ["mouse-moved","div","screen-size"])
    it "reads applications" $
      (decode applicationYaml :: Maybe Application) `shouldBe` Just (Application ([Application_Input "const1" "12"]) ([Application_Output "result" "console"]))
    it "reads nothing if format is not right" $
      (decode applicationYaml :: Maybe Relation) `shouldBe` Nothing
    it "reads nothing if format is not right" $
      (decode relationYaml :: Maybe Application) `shouldBe` Nothing
