defmodule Sequence.Server do
    use GenServer

    def start(number \\ 1) do
        GenServer.start_link(__MODULE__, number, [debug: [:trace]])
    end

    def init(initial_number) do
        { :ok, initial_number }
    end

    def handle_call(:next_number, _from, currrent_number) do
        {:reply, currrent_number, currrent_number + 1}
    end

    def handle_cast({:inc, delta}, current_number) do
        {:noreply, current_number + delta}
    end
end