module Bot (
  start
)where

import System.IO
import qualified Network.Socket as N
import Config (
    getConfig, 
    Config(channel, botName, botToken, ircURL, ircPort)
  )
import Message (Message(NilMessage, PingMessage, TextMessage), messageFromString)
    
connectTo :: String -> String -> IO Handle
connectTo host port = do
  addr : _ <- N.getAddrInfo Nothing (Just host) (Just port)
  sock <- N.socket (N.addrFamily addr) (N.addrSocketType addr) (N.addrProtocol addr)
  N.connect sock (N.addrAddress addr)
  N.socketToHandle sock ReadWriteMode

write :: Handle -> String -> IO ()
write h str = do 
  let msg = str ++ "\r\n"
  hPutStr h msg
  putStr ("> " ++ msg)

forever :: IO () -> IO ()
forever a = do a; forever a

start :: Config -> IO ()
start cfg = do
  h <- connectTo (ircURL cfg) (ircPort cfg)
  write h ("PASS "  ++ botToken cfg )
  write h ("NICK "  ++ botName  cfg )
  write h ("JOIN #" ++ channel  cfg )
  listen h

listen :: Handle -> IO ()
listen h = forever $ do
    line <- hGetLine h 
    let msg = messageFromString line
    handleMsg h msg

handleMsg :: Handle -> Message -> IO ()
handleMsg h NilMessage = return ()
handleMsg h PingMessage = write h "PONG"
handleMsg _ msg = print msg
