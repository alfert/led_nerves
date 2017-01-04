defmodule LedNerves do
  use Application
  alias Nerves.Networking

  require Logger
  @wlan_interface :wlan0

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    start_ntp = fn state ->
      Logger.info("Network state change: #{inspect state}")
      if state |> Enum.any?(fn({k,v}) -> k == :status and v == "bound" end) do
        Logger.info("IP address bound, start ntp ")
        network_time()
      end
    end

    configure_wlan(start_ntp)
    # network_time()

    Blinky.blink()
    Logger.debug "Current time is: #{DateTime.utc_now() |> DateTime.to_string}"

    # Define workers and child supervisors to be supervised
    children = [
      # worker(LedNerves.Worker, [arg1, arg2, arg3]),
    ]

    opts = [strategy: :one_for_one, name: LedNerves.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def configure_wlan(on_change_fun \\ fn(_dict) -> :ok end) do
    Logger.debug "Configure WLAN"
    Logger.debug "modprobe the wifi module"
    System.cmd("/sbin/modprobe", ["8192cu"])
    :timer.sleep(250)

    System.cmd("/usr/sbin/wpa_supplicant", ["-s", "-B",
         "-i", @wlan_interface,
         "-D", "wext",
         "-c", "/etc/wpa_supplicant.conf"])
     :timer.sleep(500)

     Networking.setup(@wlan_interface, [on_change: on_change_fun])

    # opts = Application.get_env(:led_nerves, @wlan_interface)
    # Logger.debug "WLAN opts: #{inspect opts}"
    # Nerves.InterimWiFi.setup(@wlan_interface |> Atom.to_string(), opts)
  end

  def network_time() do
     System.cmd("/usr/sbin/ntpd", ["-g"])
  end
end
