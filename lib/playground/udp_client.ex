defmodule Playground.UdpClient do
  @moduledoc """
  Send and receive UDP messages.
  """

  @type ip_address :: {non_neg_integer(), non_neg_integer(), non_neg_integer(), non_neg_integer()}

  @doc """
  Create a UDP socket in passive mode.
  """
  @spec create_socket() :: {:ok, port()} | {:error, :system_limit | :inet.posix()}
  def create_socket() do
    :gen_udp.open(0, active: false)
  end

  @doc """
  Send a message to a specified host and port over UDP socket.
  """
  @spec send_message(port(), String.t(), non_neg_integer(), String.t()) ::
          :ok | {:error, :not_owner | :inet.posix()}
  def send_message(socket, host, port, data) do
    ip = to_ip_tuple(host)

    :gen_udp.send(socket, ip, port, data)
  end

  @doc """
  Receive a message over UDP socket. Default timeout is two seconds.
  """
  @spec receive_message(port(), timeout()) ::
          {:ok, String.t()} | {:error, :not_owner | :timeout | :inet.posix()}
  def receive_message(socket, timeout \\ 2_000) do
    case :gen_udp.recv(socket, 0, timeout) do
      {:ok, {_sender_host, _sender_port, data}} -> {:ok, data}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Close a UDP socket.
  """
  @spec close_socket(port()) :: :ok
  def close_socket(socket), do: :gen_udp.close(socket)

  @spec to_ip_tuple(String.t()) :: ip_address()
  defp to_ip_tuple(ip) do
    ip
    |> String.split(".")
    |> Enum.map(&String.to_integer(&1))
    |> List.to_tuple()
  end
end
