defmodule Servy.PledgeServer do

  use GenServer
  @name :pledge_server

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  def child_spec(arg) do
    %{id: Servy.PledgeSerer, restart: :temporary, shutdown: 5000,
  start: {Servy.PledgeServer, :start_link, [[]]}, type: :worker}
  end

  # Client Interface

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(_arg) do
    IO.puts "Starting the pledge server..."
    GenServer.start_link(__MODULE__,%State{},name: @name)
  end

  def create_pledge(name, amount) do
    GenServer.call @name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    GenServer.call @name, :recent_pledges
  end

  def total_pledged do
    GenServer.call @name, :total_pledged
  end

  def set_cache_size(size) do
    GenServer.cast @name, {:set_cache_size, size}
  end

  def clear do
    GenServer.cast @name, :clear
  end

  def init(state) do
    pledges = fetch_recent_pledges_from_service()
    new_state = %{ state | pledges: pledges }
    {:ok, new_state}
  end

  # Server callbacks
  def handle_call(:recent_pledges, _from, state) do
    {:reply,  state.pledges,state }
  end

  def handle_call(:total_pledged, _from, state) do
    total = Enum.map(state.pledges, &elem(&1, 1)) |> Enum.sum
    {:reply, total, state}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state.pledges, 2)
    new_state = %{ state | pledges: [ {name, amount} | most_recent_pledges ]}

    {:reply, id, new_state}
  end

  def handle_cast(:clear, _state) do
    {:noreply, []}
  end

  def handle_cast({:set_cache_size, size}, state) do
    new_state = %{ state | cached_size: size}
    {:noreply, new_state}
  end

  def handle_info(message, state) do
    IO.puts "Received unexpected message: #{inspect message}"
    {:noreply, state}
  end

  defp send_pledge_to_service(_name, _amount) do
    # CODE GOES HERE TO SEND PLEDGE TO EXTERNAL SERVICE
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  defp fetch_recent_pledges_from_service do
    # CODE GOES HERE TO FETCH RECENT PLEDGES FROM EXTERNAL SERVICE

    # Example return value:
    [ {"wilma", 15}, {"fred", 25} ]
  end

end

# alias Servy.PledgeServer

# { :ok, pid } = PledgeServer.start()

# send pid, {:stop, "hammertime"}

# IO.inspect PledgeServer.create_pledge("larry", 10)
# IO.inspect PledgeServer.create_pledge("moe", 20)
# IO.inspect PledgeServer.create_pledge("curly", 30)
# IO.inspect PledgeServer.create_pledge("daisy", 40)
# IO.inspect PledgeServer.create_pledge("grace", 50)

# IO.inspect PledgeServer.recent_pledges()

# IO.inspect PledgeServer.total_pledged()

# IO.inspect Process.info(pid, :messages)
