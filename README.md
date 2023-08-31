# haskell-tw-bot
A Simple Twitch bot (IRC) written in Haskell.

## TODO
- [x] Define `.env.example`
- [ ] Read `.env.example` and save to Struct
```go
type Message {
    Channel  :: String
    BotName  :: String
    BotToken :: String
    ircURL   :: Bool
    ircPort  :: Int
}
```
- [ ] Connect to Single channel
    - Must start receiving/printing
- [ ] Message Parser
```go
type Message {
    Channel :: String
    Sender  :: String
    Text    :: String
    isPing  :: Bool
    isNil   :: Bool
}
```
- [ ] Command Logic
- [ ] Multi-Channel support
