defmodule SchedulerWorker do
  @doc "Initialization"
  @callback loop(pid) :: pid

  @doc "Performs calculations"
  @callback calculate(pid, any, pid) :: :ok

  @doc "Shutdown"
  @callback shutdown(pid) :: :ok
end

defmodule Fib.Scheduler do

  @moduledoc """
  To run benchmark:
  Fib.Scheduler.benchmark_2 + @calculator Fib.Finder
  Fib.Scheduler.benchmark + @calculator Fib.Calculator
  """
  @calculator Fib.Calculator
  # @calculator Fib.Finder

  # initialize Calculator process, send :ready to Scheduler

  # Scheduler receives :ready
  # - sends :fib to Calculator if there's work to do
  # - sends :shutdown to Calculator if there's no work to do

  # Calculator
  # - sends :answer when done calculating
  # - Exits when receives :shutdown

  # Can be in Scheduler module

  def benchmark do
    [1, 4, 8, 16, 32]
    |> Enum.map(&time(fn -> run(&1) end))
  end

  def benchmark_2 do
    paths = File.ls!("lib")
    |> Enum.map(&("lib/" <> &1))

    [1, 4, 8, 16, 32]
    |> Enum.map(&time(fn -> run(&1, paths) end))
  end

  def time(func) when is_function(func) do
    {time, _} = :timer.tc(func)
    "TIME: " <> "#{to_string(time / 100_000)}"
  end

  def run(calculators \\ 2, nums \\ 5..20) do
    IO.inspect calculators
    IO.inspect nums

    1..calculators
    |> Enum.map(fn _ -> initialize_calculator() end)
    |> loop(Enum.into(nums, []), [])
  end

  def initialize_calculator do
    scheduler_pid = self()
    spawn_link(fn -> 
        IO.inspect("sending :ready")
        
        @calculator.loop(scheduler_pid)
    end)
  end

  def loop(pids, queue, results) do
    receive do
      {:ready, calculator_pid} when length(queue) > 0 ->
        [h | t] = queue
        # send(calculator_pid, {:fib, h, self()})
        @calculator.calculate(calculator_pid, h, self())
        loop(pids, t, results)

      {:ready, calculator_pid} when length(queue) == 0 ->
        # send(calculator_pid, :shutdown)
        @calculator.shutdown(calculator_pid)

        if length(pids) > 1 do
          loop(List.delete(pids, calculator_pid), queue, results)
        else
          results
          |> Enum.sort(fn {n1, _}, {n2, _} -> n1 >= n2 end)
          |> IO.inspect()
        end

      {:answer, n, result, calculator_pid} ->
        IO.inspect("Result for " <> to_string(n) <> "is:" <> to_string(result))
        loop(pids, queue, [{n, result} | results])

      other ->
        IO.inspect("WAT?")
    end
  end
end

defmodule Fib.Calculator do
  @behaviour SchedulerWorker
  def loop(scheduler_pid) do
    send(scheduler_pid, {:ready, self()})
    receive do
        {:calculate, n, scheduler_pid} ->
            # Make it slow
            Process.sleep 50
            
            send(scheduler_pid, {:answer, n, fib(n), self()})
            loop(scheduler_pid)
        :shutdown ->
            IO.inspect "shutting down calculator"
            exit(:normal)
        other ->
            IO.inspect "WAT?"
    end
  end

  @impl SchedulerWorker
  def calculate(pid, n, scheduler_pid) do
    send(pid, {:calculate, n, scheduler_pid})
    :ok
  end

  @impl SchedulerWorker
  def shutdown(pid) do
    send(pid, :shutdown)
    :ok
  end

  def fib(1), do: 1
  def fib(n), do: n * fib(n - 1)
end


defmodule Fib.Finder do
  @behaviour SchedulerWorker

  def loop(scheduler_pid) do
    send(scheduler_pid, {:ready, self()})
    receive do
        {:calculate, n, scheduler_pid} ->
            # Make it slow
            Process.sleep 50
            
            send(scheduler_pid, {:answer, n, find(n), self()})
            loop(scheduler_pid)
        :shutdown ->
            IO.inspect "shutting down calculator"
            exit(:normal)
        other ->
            IO.inspect "WAT?"
    end
  end

  @impl SchedulerWorker
  def calculate(pid, n, scheduler_pid) do
    send(pid, {:calculate, n, scheduler_pid})
    :ok
  end

  @impl SchedulerWorker
  def shutdown(pid) do
    send(pid, :shutdown)
    :ok
  end

  def find(n) do
    File.read!(n)
    |> String.graphemes 
    |> Enum.count(& &1 == "a")
  end
end


defmodule FibAgent do
  @moduledoc """
  Example of non tail-recursive fibonacci calculator.
  {:ok, agent} = FibAgent.start_link(); IO.puts FibAgent.fib(agent, 8)
  """
  import IEx

  def start_link do
    Agent.start_link(fn -> %{0 => 0, 1 => 1} end)
  end

  def fib(pid, n) do
    Agent.get_and_update(pid, &do_fib(&1, n))
  end

  defp do_fib(cache, n) do
    case cache[n] do
      nil ->
        IO.inspect("nil -> do_fib" <> to_string n)
        {n_1, cache} = do_fib(cache, n - 1)
        IO.inspect(cache)
        IO.inspect("nil -> n_1 + cache[n - 2]" <> to_string(n) <> "+" <> to_string(cache[n - 2]))
        result = n_1 + cache[n - 2]
        {result, Map.put(cache, n, result)}
      cached_value ->
        IO.inspect("{cached_value, ...}" <> to_string cached_value)
        IO.inspect(cache)
        {cached_value, cache}
    end
  end
end