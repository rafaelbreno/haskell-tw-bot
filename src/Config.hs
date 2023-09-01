module Config(
  Config(channel, botName, botToken, ircURL, ircPort),
  getConfig
) where

import Data.Maybe (fromMaybe)
import System.Environment (lookupEnv)
import Configuration.Dotenv (loadFile, defaultConfig)

data Config = Config {
  channel  :: String,
  botName  :: String,
  botToken :: String,
  ircURL   :: String,
  ircPort  :: String
} deriving (Show, Eq)

getConfig :: IO Config
getConfig = do 
  loadFile defaultConfig
  channel     <- fromMaybe "defaultChannel"     <$> lookupEnv "CHANNEL"
  botName     <- fromMaybe "defaultBotName"     <$> lookupEnv "BOT_USERNAME"
  botToken    <- fromMaybe "defaultBotToken"    <$> lookupEnv "BOT_TOKEN"
  ircURL      <- fromMaybe "irc.chat.twitch.tv" <$> lookupEnv "IRC_URL"
  ircPort     <- fromMaybe "6667"               <$> lookupEnv "IRC_PORT"

  return Config {
    channel = channel,
    botName  = botName,
    botToken = botToken,
    ircURL   = ircURL,
    ircPort  = ircPort
  } 

