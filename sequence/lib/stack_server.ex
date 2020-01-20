defmodule Sequence.StackServer do
  use GenServer

  @ten_sec_timeout 1000 * 10

  @moduledoc """
  To test this, do
  Sequence.StackServer.test
  """

  @doc """
  start_link is called automatically by a supervisor
  """
  def start_link(init_arg \\ ~w(a b c d e)) do
    IO.inspect("starting #{__MODULE__}")
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__, debug: [:trace])
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  def push(v) do
    GenServer.cast(__MODULE__, {:push, v})
  end

  def test do
    push("pushed1")
    push("pushed2")
  end

  def fail do
    GenServer.stop(__MODULE__, :not_normal)
  end

  def init(initial_stack) do
    {:ok, initial_stack, @ten_sec_timeout}
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
    # {:stop, :no_activity_for_10_secs, state}
    {:noreply, state}
  end
end
