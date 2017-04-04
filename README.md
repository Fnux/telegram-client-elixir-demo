# TelegramClient

A simple example for [telegram_mt](https://github.com/Fnux/telegram-mt-elixir).

## Installation

```
git clone https://github.com/Fnux/telegram-client-elixir-demo
cd telegram-client-elixir-demo
mix deps.get
mix compile
```

## Usage

```
iex -S mix
Erlang/OTP 19 [erts-8.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false]

08:46:28.821 [info]  No authorization key found for DC 4. Requesting...
08:46:29.553 [info]  The authorization key was successfully generated.

iex> import TelegramClient
TelegramClient

iex> sign_in
Please enter your phone number :0041000000000

08:47:46.997 [info]  TelegramClient received a new message : auth.sentCode

Please enter the security code :00000

08:48:28.482 [info]  TelegramClient received a new message : auth.authorization

iex> ...
```
