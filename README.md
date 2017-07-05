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
20:45:23.176 [info]  Starting Telegram MT.
Welcome abord `telegram-client-elixir-demo` !
Type `help` for the available commands.
> help
--- HELP Message ---
List of available commands :
* dump : dump a registry (either :dc or :session)
* connect : connect to Telegram's servers
* signin : sign in on Telegram
* send : send a message
* contacts : print the contact list
* debug : get/set the debug level
* help : print this message
* exit : exit this application

>

```
