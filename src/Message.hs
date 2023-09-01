module Message (
  Message( 
    NilMessage, 
    PingMessage, 
    TextMessage
  ), 
  messageFromString
) where

import Data.Maybe (fromMaybe)

data Message = 
  NilMessage |
  PingMessage |
  TextMessage { channel :: String, sender :: String, body :: String } 
  deriving (Show, Eq)

messageFromString :: String -> Message
messageFromString ('P': 'I': 'N': 'G' : _) = PingMessage
messageFromString msg = fromMaybe NilMessage (parseLine msg)

parseLine :: String -> Maybe Message
parseLine msg = 
  case words msg of
    ((':':userHost):"PRIVMSG":('#':channel):rest) -> do
      let user = takeWhile (/= '!') userHost
      let message = drop 1 $ unwords rest 
      return TextMessage { channel=channel, sender=user, body=message }
    _ -> Nothing
