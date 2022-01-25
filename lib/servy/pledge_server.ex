defmodule Servy.GenericServer do
  def start(callback_module, initial_state, name) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state, callback_module])
    Process.register(pid, name)
    pid
  end

  def call(pid, message) do
    send(pid, {:call, self(), message})

    receive do
      {:response, response} ->
        response
    end
  end

  def cast(pid, message) do
    send(pid, {:cast, message})
  end

  def listen_loop(state, callback_module) do
    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = callback_module.handle_call(message, state)
        send(sender, {:response, response})

        listen_loop(new_state, callback_module)

      {:cast, message} ->
        new_state = callback_module.handle_cast(message, state)
        listen_loop(new_state, callback_module)

      unexpected ->
        IO.puts("Unexpected message: #{inspect(unexpected)}")
        listen_loop(state, callback_module)
    end
  end
end

defmodule Servy.PledgeServer do
  alias Servy.GenericServer
  @name :pledge_server

  # Client Interface
  def start do
    IO.puts("Starting the pledge server...")
    GenericServer.start(__MODULE__, [], @name)
  end

  def create(name, amount) do
    GenericServer.call(@name, {:create_pledge, name, amount})
  end

  def recent_pledges() do
    GenericServer.call(@name, :recent_pledges)
  end

  def total_pledged() do
    GenericServer.call(@name, :total_pledged)
  end

  def clear do
    GenericServer.cast(@name, :clear)
  end

  # Server Callbacks

  def handle_cast(:clear, _state), do: []

  def handle_call(:total_pledged, state) do
    total = Enum.map(state, &elem(&1, 1)) |> Enum.sum()
    {total, state}
  end

  def handle_call(:recent_pledges, state) do
    {state, state}
  end

  def handle_call({:create_pledge, name, amount}, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state, 2)
    new_state = [{name, amount} | most_recent_pledges]
    {id, new_state}
  end

  defp send_pledge_to_service(_name, _amount) do
    # CODE GOES HERE TO SEND THE PLEDGE TO EXTERNAL SERVICE
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end

alias Servy.PledgeServer
pid = PledgeServer.start()

send(pid, {:stop, "hammertime"})

IO.inspect(PledgeServer.create("larry", 10))
IO.inspect(PledgeServer.create("moe", 20))
IO.inspect(PledgeServer.create("curly", 30))
IO.inspect(PledgeServer.create("daisy", 40))
IO.inspect(PledgeServer.create("grace", 50))

PledgeServer.clear()

IO.inspect(PledgeServer.recent_pledges())

IO.inspect(PledgeServer.total_pledged())

IO.inspect(Process.info(pid, :messages))
