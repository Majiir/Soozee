module Soozee.Plugin.Korea (koreaPlugin) where

import Control.Monad (when, join)

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
            process = const doKorea
        }
    ],
    contextual = \text -> when (("korea" `isPrefixOf`) `any` words (map toLower text)) doKorea
}

doKorea :: Cmd (ModuleT () LB) ()
doKorea = io getKorea >>= mapM_ (\x -> say $ "http://majiir.net" ++ x)

getKorea :: IO (Maybe String)
getKorea = join . hush . fmap (findHeader HdrLocation) <$> simpleHTTP (getRequest "http://majiir.net/random")

-- TODO: use Control.Error.Util instead
hush :: Either b a -> Maybe a
hush = either (const Nothing) Just

