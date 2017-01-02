defmodule LedNerves do
  use Application
  alias Nerves.Networking

  require Logger
  @wlan_interface :wlan0

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    configure_wlan()
    network_time()

    Blinky.blink()
    Logger.debug "Current time is: #{DateTime.utc_now() |> DateTime.to_string}"
    
    # Define workers and child supervisors to be supervised
    children = [
      # worker(LedNerves.Worker, [arg1, arg2, arg3]),
    ]

    opts = [strategy: :one_for_one, name: LedNerves.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def configure_wlan() do
    Logger.debug "Configure WLAN"
    Logger.debug "modprobe the wifi module"
    System.cmd("/sbin/modprobe", ["8192cu"])
    :timer.sleep(250)

    System.cmd("/usr/sbin/wpa_supplicant", ["-s", "-B",
         "-i", @wlan_interface,
         "-D", "wext",
         "-c", "/etc/wpa_supplicant.conf"])
     :timer.sleep(500)

     Networking.setup(@wlan_interface)

    # opts = Application.get_env(:led_nerves, @wlan_interface)
    # Logger.debug "WLAN opts: #{inspect opts}"
    # Nerves.InterimWiFi.setup(@wlan_interface |> Atom.to_string(), opts)
  end

  def network_time() do
     System.cmd("/usr/sbin/ntpd", ["-g"])
  end
end
