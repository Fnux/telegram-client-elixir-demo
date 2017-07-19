# TelegramClient

A simple example for [telegram_mt](https://github.com/Fnux/telegram-mt-elixir).

## Installation

```
git clone https://github.com/Fnux/telegram-client-elixir-demo
cd telegram-client-elixir-demo
mix deps.get
```

Copy `config/config.example.exs` to `config/config.exs` and fill it.
Run `mix escript.build` to generate the executable.

## Usage

```
fnux/telegram-client-elixir-demo [master ●] » ./telegramclient
11:10:10.080 [info]  Starting Telegram MT.
Welcome abord `telegram-client-elixir-demo` !
Type `help` for the available commands.
> help
--- HELP Message ---
List of available commands :
* help : print this message
* connect : connect to Telegram's servers
* signin : sign in on Telegram
* send : send a message
* contacts : print the contact list
* chats : print the chats list
* gen-authkey : generate the authorization key
* export : export session parameters
* import : import session parameters
* exit : exit this application
Debug commands :
* debug : get/set the debug level
* dump : dump a registry (either :dc or :session)
--- Signin procedure ---
* connect -> gen-authkey -> signin

>

```
