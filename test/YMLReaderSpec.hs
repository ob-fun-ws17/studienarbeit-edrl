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
\out: mouse-moved-percent \n\
\rule: \n\
\  - mouse-moved \n\
\  - div \n\
\  - screen-size \n\
\"

spec :: Spec
spec =
  describe "reader" $ do
    it "reads relations" $
      (decode relationYaml :: Maybe Relation) `shouldBe` Just (Relation ["mouse-moved","screen-size"] "mouse-moved-percent" ["mouse-moved","div","screen-size"])
