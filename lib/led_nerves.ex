defmodule LedNerves do
  use Application

  require Logger
  @wlan_interface :wlan0

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false


    configure_wlan()
    Blinky.blink()

    # Define workers and child supervisors to be supervised
    children = [
      # worker(LedNerves.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LedNerves.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def configure_wlan() do
    Logger.debug "Configure WLAN"
    opts = Application.get_env(:led_nerves, @wlan_interface)
    Logger.debug "modprobe the wifi module"
    System.cmd("/sbin/modprobe", ["8192cu"])
    :timer.sleep(250)
    res = System.cmd("/sbin/lsmod")
    Logger.debug "output of lsmod: #{inspect res}"

    System.cmd("/usr/sbin/wpa_supplicant", ["-s", "-B",
         "-i", @wlan_interface,
         "-D", "wext",
         "-c", "/etc/wpa_supplicant.conf"])
     :timer.sleep(500)

     Networking.setup @wlan_interface

    # Nerves.InterimWiFi.setup "wlan0", opts
    # Logger.debug "WLAN opts: #{inspect opts}"
    # Logger.debug "WLAN status: #{inspect Nerves.NetworkInterface.status("wlan0")}"
    # Logger.debug "WLAN status: #{inspect Nerves.NetworkInterface.settings("wlan0")}"
  end

end
