defmodule Sequence.StackServer do
    use GenServer

    @ten_sec_timeout 1000 * 10

    def start(init_arg \\ ~w(a b c d e)) do
        GenServer.start_link(__MODULE__, init_arg, [debug: [:trace]])
    end

    def init(initial_stack) do
        { :ok, initial_stack, @ten_sec_timeout }
    end

    def handle_call(:pop, _from, [h | t] = stack) do
        {:reply, h, t}
    end

    def handle_call(:pop, _from, []) do
        {:reply, nil, []}
    end

    def handle_cast({:push, value}, stack) do
        {:noreply, [value | stack]}
    end

    def handle_info(:timeout, state) do
        IO.inspect("timed out after waiting @10_sec_timeout")
        {:stop, :no_activity_for_10_secs, state}
    end
end