defmodule Playground.UdpServer do
  @moduledoc """
  Receive and send data via the UDP protocol.

  This module receives data from some external client
  and replys back with the same data.
  """

  use GenServer

  require Logger

  def start_link(port) do
    GenServer.start_link(__MODULE__, port)
  end

  @impl true
  def init(port) do
    opts = [
      :binary,
      :inet,
      active: true
    ]

    {:ok, _socket} = :gen_udp.open(port, opts)

    Logger.debug("#{__MODULE__} listening on port #{port}.")

    {:ok, %{}}
  end

  @impl true
  def handle_info({:udp, socket, address, port, data}, state) do
    Logger.debug("#{__MODULE__} received #{data} from #{format_ip_address(address)}:#{port}")

    :gen_udp.send(socket, address, port, data)

    {:noreply, state}
  end

  @spec format_ip_address(tuple()) :: String.t()
  defp format_ip_address(address) do
    address
    |> Tuple.to_list()
    |> Enum.join(".")
  end
end
