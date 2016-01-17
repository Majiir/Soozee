module Soozee.Plugin.Korea (koreaPlugin) where

import Data.Char (toLower)
import Data.List (isPrefixOf)

import Lambdabot.Command (Command(..), command, Cmd, say)
import Lambdabot.Module (Module(..), newModule, ModuleT)
import Lambdabot.Monad (LB)
import Lambdabot.Util (io)

import Network.HTTP (simpleHTTP, getRequest, findHeader, HeaderName(HdrLocation))

koreaPlugin :: Module ()
koreaPlugin = newModule {
    moduleCmds = return [
        (command "korea") {
            aliases = ["kpop"],
            help = say "Korea! http://majiir.net/",
            process = doKorea
        }
    ],
    contextual = \text -> do
        if any (isPrefixOf "korea") $ (map . map) toLower $ words text
            then doKorea text
            else return ()
}

doKorea :: String -> Cmd (ModuleT () LB) ()
doKorea _ = do
    link <- io $ do
        r <- simpleHTTP (getRequest "http://majiir.net/random")
        case r of
            (Left _) -> return Nothing
            (Right rsp) -> return $ findHeader HdrLocation rsp
    case link of
        (Just str) -> say $ "http://majiir.net" ++ str
        Nothing -> return ()
