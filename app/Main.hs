{-# LANGUAGE OverloadedStrings #-}
module Main where

import Message (
    Message( NilMessage, PingMessage, TextMessage ), 
    messageFromString
  )

import System.Environment (lookupEnv)
import Configuration.Dotenv (loadFile, defaultConfig)
import Data.Maybe (fromMaybe)
import Network.Socket 
import Network.Socket.ByteString (recv, sendAll)
import Data.ByteString.Char8 (pack, unpack)

main :: IO ()
main = do
  print $ messageFromString ":xmicagira!xmicagira@xmicagira.tmi.twitch.tv PRIVMSG #xplebe :Faz o keny g?\r"
  bot

foo :: IO ()
foo = do
  putStrLn "Test"
  

bot :: IO ()
bot = do
  -- load env file (.env)
  config <- getConfig
  let hints = defaultHints { addrSocketType = Stream }
  addr:_ <- getAddrInfo (Just hints) (Just (ircURL config)) (Just (ircPort config))
  sock <- socket (addrFamily addr) (addrSocketType addr) (addrProtocol addr)
  connect sock (addrAddress addr)

  print $ messageFromString ":xmicagira!xmicagira@xmicagira.tmi.twitch.tv PRIVMSG #xplebe :Faz o keny g?\r"

  sendMessage sock $ "PASS " ++ botToken config
  sendMessage sock $ "NICK " ++ botName config
  sendMessage sock $ "JOIN #" ++ channel config

  loop sock


loop :: Socket -> IO()
loop sock = do
  msg <- recv sock 1024
  let res = map messageFromString $ lines $ unpack msg
  --let res = map (\x -> (x, checkMsg x)) msgs
  processMessages sock res
  print res
  loop sock
  --putStrLn $ show config
  --putStrLn "Hello, Haskell!"
  --

processMessages :: Socket -> [Message] -> IO ()
processMessages socket msgs = do
  let _ = map (processMessage socket) msgs
  return ()

processMessage :: Socket -> Message -> IO ()
processMessage sock msg = 
  case msg of 
    NilMessage -> putStrLn ">"
    PingMessage -> pong sock
    TextMessage channel sender body -> putStrLn $ "Text Message | From: @"  ++ sender ++ " | Channel: " ++ channel ++ " | Body: '" ++ body ++ "'"

-- pong send a "PONG" message back to not 
pong :: Socket -> IO ()
pong sock = sendMessage sock "PONG"

escape :: String -> String
escape str = str ++ "\r\n"

sendMessage :: Socket -> String -> IO ()
sendMessage sock str = sendAll sock $ pack $ escape str

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

