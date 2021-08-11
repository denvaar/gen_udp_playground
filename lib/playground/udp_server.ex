defmodule Playground.UdpServer do
  @moduledoc """
  Receive and send data via the UDP protocol.

  This module receives data from multiple clients
  and echos the messages to the whole group.
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

    {:ok, %{clients: %{}}}
  end

  @impl true
  def handle_info({:udp, socket, address, port, data}, %{clients: clients}) do
    Logger.debug("#{__MODULE__} received #{data} from #{format_ip_address(address)}:#{port}")

    clients = Map.put(clients, "#{format_ip_address(address)}:#{port}", [address, port])

    broadcast_data(socket, clients, data)

    {:noreply, %{clients: clients}}
  end

  defp broadcast_data(socket, clients, data) do
    client_list =
      clients
      |> Map.keys()
      |> Enum.join(", ")

    Logger.debug("#{__MODULE__} sending data to #{client_list}")

    for [address, port] <- Map.values(clients) do
      :gen_udp.send(socket, address, port, data)
    end
  end

  @spec format_ip_address(tuple()) :: String.t()
  defp format_ip_address(address) do
    address
    |> Tuple.to_list()
    |> Enum.join(".")
  end
end
