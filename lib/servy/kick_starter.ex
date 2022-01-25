defmodule Servy.KickStarter do
  use GenServer

  def start_link(_args) do
    IO.puts("Starting the kickstarter...")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.flag(:trap_exit, true)

    {:ok, start_server()}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts("HttpServer exited (#{inspect(reason)})")

    {:noreply, start_server()}
  end

  defp start_server do
    IO.puts("Starting the HTTP server...")
    server_pid = spawn_link(Servy.HttpServer, :start, [4000])
    Process.register(server_pid, :http_server)

    server_pid
  end
end
