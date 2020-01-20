defmodule Sequence.Server do
  use GenServer

  def test do
    __MODULE__.start()
    __MODULE__.inc(10)
    __MODULE__.inc(10)
    __MODULE__.next_number()
  end

  def start(number \\ 1) do
    GenServer.start_link(__MODULE__, number, name: __MODULE__, debug: [:trace])
  end

  def next_number do
    GenServer.call(__MODULE__, :next_number)
  end

  def inc(delta) do
    GenServer.cast(__MODULE__, {:inc, delta})
  end

  def halt do
    System.halt(0)
  end

  def init(initial_number) do
    {:ok, initial_number}
  end

  def handle_call(:next_number, _from, currrent_number) do
    {:reply, currrent_number, currrent_number + 1}
  end

  def handle_cast({:inc, delta}, current_number) do
    {:noreply, current_number + delta}
  end

  def terminate(reason, state) do
    IO.inspect("LOL")
  end
end
