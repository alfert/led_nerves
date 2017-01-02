defmodule LedNerves.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rpi"

  def project do
    [app: :led_nerves,
     version: "0.0.1",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.2.1"],
     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps() ++ system(@target)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {LedNerves, []},
     applications: [:logger,
      #  :nerves_interim_wifi,
      :nerves_networking,
      :nerves_leds, :nerves]]
  end

  def deps do
    [
      {:nerves, "~> 0.4.0"},
      {:nerves_leds, "~> 0.7.0"},
      # {:nerves_interim_wifi, "~> 0.1.0"}
      {:nerves_networking, "~> 0.6.0"}
    ]
  end

  def system(target) do
    [{:"nerves_system_#{target}", ">= 0.0.0"}]
    # [{:"nerves_system_#{target}", path: "/tmp/nerves_system_#{target}"}]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

end
