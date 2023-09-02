module Main where

import Config ( getConfig )
import Bot ( start )

main :: IO ()
main = do
  cfg <- getConfig
  start cfg
