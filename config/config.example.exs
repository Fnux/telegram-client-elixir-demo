# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# Telegram MT
config :telegram_mt,
  api_id: 00000,
  api_hash: "00000000000000000000000000000000",
  public_key: "public_key" # escript only, `priv` directory not supported

# Telegram TL : only required for escript since it does not support `priv`
config :telegram_tl, api_layer: 23,
                     api_path: "api-layer-23.json",
                     tl_path: "mtproto.json"

# Logger
config :logger, :console,
                format: "$time $metadata[$level] $levelpad$message\n"
