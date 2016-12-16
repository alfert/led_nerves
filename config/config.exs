# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"

# config for Raspberry Pi A+ / B+ / B / Zero (target rpi)
config :led_nerves, led_list: [ :red, :green ]
config :nerves_leds, names: [ red: "led0", green: "led1" ]
