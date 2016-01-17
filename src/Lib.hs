{-# LANGUAGE TemplateHaskell #-}

module Lib (runSoozee) where

import Lambdabot.Main (lambdabotMain, Modules, modules)

import Lambdabot.Plugin.Core
import Lambdabot.Plugin.Haskell
import Lambdabot.Plugin.IRC
import Lambdabot.Plugin.Novelty
import Lambdabot.Plugin.Social
import Lambdabot.Plugin.Reference
import Soozee.Plugin.Korea

runSoozee :: IO ()
runSoozee = do
    putStrLn "Starting Soozee..."
    code <- lambdabotMain mods []
    putStrLn $ "Exited with code: " ++ show code

mods :: Modules
mods = $(modules $ ["base", "system", "offlineRC", "compose", "help", "more"] ++ ["irc"] ++ haskellPlugins ++ ["bf", "dice", "slap", "unlambda"] ++ ["spell"] ++ ["tell", "seen", "poll", "activity"])
