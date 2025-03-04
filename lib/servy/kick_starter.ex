defmodule Servy.KickStarter do
  use GenServer
  def start_link(_arg) do
    IO.puts "starting the kickstarter..."
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_server do
    GenServer.call __MODULE__, :get_server
  end

  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_server();
    {:ok, server_pid}
  end

  def handle_call(:get_server, _from, state) do
    {:reply, state, state}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts "http server exited (#{inspect reason})"
    server_pid = start_server();
    {:noreply, server_pid}
  end

  def start_server do
    IO.puts "starting the http server..."
    port = Application.get_env(:servy, :port)
    server_pid = spawn_link Servy.HttpServer, :start, [port]
    Process.register server_pid, :http_server
  end
end
