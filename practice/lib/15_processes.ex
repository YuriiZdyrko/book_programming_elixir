defmodule Processes do
  def greet do
    IO.puts("Greeter activated, receiving...")

    receive do
      {sender, msg} ->
        Process.sleep(1000)
        IO.puts("Greet" <> " " <> msg)
        greet()
    end

    IO.puts("Greeter exited")
  end

  def run do
    pid = spawn(Processes, :greet, [])

    # Runs function (in separate thread), returns PID

    send(pid, {self(), "Yura"})

    IO.puts("... meanwhile in spawner process")

    send(pid, {self(), "Fuck"})

    receive do
      {sender, mst} ->
        IO.puts("Will not run")
    after
      3000 ->
        IO.puts("Will run")
    end
  end
end

defmodule ProcessesChain1 do
  def incrementer do
    receive do
      {[h | t], n} ->
        IO.puts("Looping..." <> to_string(n))
        send(h, {t, n + 1})

      {[], n} ->
        IO.puts("Finish")

      other ->
        IO.inspect("Nooo")
        IO.inspect(other)
    end
  end

  def spawn_x_processes(x) do
    for i <- 1..x do
      spawn(ProcessesChain1, :incrementer, [])
    end
  end

  def run(c \\ 10000) do
    [h | t] = spawn_x_processes(c)

    send(h, {t, 0})
  end
end

defmodule ProcessesChain do
  # Child process is 
  #  - initialized with next_pid
  #  - receives n, increments, sends to next_pid

  def child_process(next_pid) do
    receive do
      n ->
        IO.inspect("In child process " <> to_string(n))
        send(next_pid, n + 1)
    end
  end

  # Parent process: 

  # - initializes Child processes with next_pids in following fashion:
  # Child process 1 - self()
  # Child process 2 - pid 1
  # Child process 3 - pid 2
  # Child process 4 - pid 3
  # ...

  # - calls last of Child processes to trigger chain reaction

  # - receive final response from Child process 1

  def run(count \\ 100) do
    last_child_pid =
      1..count
      |> Enum.reduce(
        self(),
        fn _, next_pid ->
          spawn(__MODULE__, :child_process, [next_pid])
        end
      )

    send(last_child_pid, 0)

    receive do
      n ->
        IO.puts("In parent process " <> to_string(n))
    end
  end
end

defmodule SpawnLink do
  def failing_child do
    Process.sleep(400)
    exit(:boom)
  end

  def run do
    # If we trap exit, failing_child process is not crashing parent,
    # but sending {:EXIT, failing_child_pid, reason} to it.

    Process.flag(:trap_exit, true)

    spawn_link(__MODULE__, :failing_child, [])

    receive do
      {:EXIT, _pid, reason} ->
        IO.inspect(reason)

      anything ->
        IO.inspect("WHY?")
    end
  end
end

defmodule SpawnMonitor do
  def failing_child do
    Process.sleep(400)
    exit(:boom)
  end

  def run do
    {pid, ref} = spawn_monitor(__MODULE__, :failing_child, [])

    receive do
      {:DOWN, _ref, :process, _pid, reason} ->
        IO.inspect(reason)

      anything ->
        IO.inspect("WHY?")
    end
  end
end

defmodule Ex1 do
  def child(parent_pid) do
    send(parent_pid, :ping)
  end

  def run do
    spawn_link(__MODULE__, :child, [self()])

    Process.sleep(500)

    # look at mailbox
    :erlang.process_info(self(), :messages) |> IO.inspect()

    receive do
      msg ->
        IO.inspect(msg)
    end

    # look at mailbox
    :erlang.process_info(self(), :messages) |> IO.inspect()
  end
end

defmodule PMap do
  def run(arr \\ [1, 2, 3, 4, 5, 6]) do
    parent_pid = self()

    arr

    # List of PIDs of jobs
    |> Enum.map(
      &spawn_link(fn ->
        Process.sleep(:rand.uniform(1000))
        send(parent_pid, {self(), &1 * 10})
      end)
    )

    # For each PID in same order, generate receive block
    |> Enum.map(fn pid ->
      receive do
        {^pid, msg} -> IO.inspect(msg)
      end
    end)
  end
end

defmodule PFib do
  # initialize Calculator process, send :ready to Scheduler

  # Scheduler receives :ready
  # - sends :fib to Calculator if there's work to do
  # - sends :shutdown to Calculator if there's no work to do

  # Calculator
  # - sends :answer when done calculating
  # - Exits when receives :shutdown

  # Can be in Scheduler module
  def run(nums \\ [2, 10, 15, 20, 30, 40], calculators \\ 3) do      
    1..calculators 
    |> Enum.map(fn _ -> 
      spawn_link(__MODULE__, :calculator, [self()])
    end)
    |> loop(nums, [])


    # for num <- nums do
    #   request_calculation(num)
    # end

    # listen(nums)

    # calculators_pids
    # |> Enum.each(fn pid -> 
    #   send(pid, :shutdown)
    # end)

    # spawn_link each of available calculators

    # > ready
    # > ready
    # > ready
    # loop nums
    # Loop, listen to ready in a loop and decrease remaining amount each time
  end

  def loop(pids, queue, results) do
    receive do
      {:ready, calculator_pid} when length(queue) > 0 -> 
        [h | t] = queue
        send calculator_pid, {:fib, h, self()}
        loop(pids, t, results)
      {:ready, calculator_pid} when length(queue) == 0 ->
        send calculator_pid, :shutdown
        if (length(pids) > 1) do
          loop(List.delete(pids, calculator_pid), queue, results)
        else
          results
          |> Enum.sort(fn({n1, _}, {n2, _}) -> n1 >= n2 end)
          |> IO.inspect()
        end
      {:answer, n, result, calculator_pid} -> 
        IO.inspect "Result for " <> to_string(n) <> "is:" <> to_string(result)
        loop(pids, queue, [{n, result} | results])
      other ->
        IO.inspect "WAT"
        IO.inspect other
    end
  end

  # Can be in Calculator module
  def calculator(scheduler_pid) do
    Process.sleep(300)
    IO.inspect("sending :ready")
    send(scheduler_pid, {:ready, self()})

    receive do
      {:fib, n, scheduler_pid} ->
        send(scheduler_pid, {:answer, n, fib(n), self()})
        calculator(scheduler_pid)

      {:shutdown} ->
        exit(:normal)
    end
  end

  def fib(1), do: 1
  def fib(n), do: n * fib(n - 1)
end
