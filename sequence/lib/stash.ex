defmodule Sequence.Stash do
    use GenServer

    @me __MODULE__

    def start_link(init_number) do
        GenServer.start_link(@me, init_number, name: @me)
    end

    def get() do
        GenServer.call(@me, :get)
    end

    def update(new_number) do
        GenServer.cast(@me, {:update, new_number})
    end

    def handle_call(:get, _, state) do
        {:reply, state, state}
    end

    def handle_cast({:update, new_number}, state) do
        {:noreply, new_number}
    end
end