defmodule Processes do
    def greet do
        IO.puts "Greeter activated, receiving..."
        receive do
            {sender, msg} ->
                Process.sleep(1000)
                IO.puts "Greet" <> " " <> msg
                greet()
        end
        IO.puts "Greeter exited"
    end

    def run do
        pid = spawn(Processes, :greet, [])
        
        # Runs function (in separate thread), returns PID

        send pid, {self(), "Yura"}

        IO.puts "... meanwhile in spawner process"

        send pid, {self(), "Fuck"}

        receive do
            {sender, mst} ->
                IO.puts "Will not run"
            after 3000 ->
                IO.puts "Will run"
        end
    end
end

defmodule ProcessesChain1 do
    def incrementer do
        receive do
            {[h | t], n} ->
                IO.puts("Looping..." <> to_string n)
                send(h, {t, n+1})
            {[], n} ->
                IO.puts("Finish")
            other ->
                IO.inspect "Nooo"
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

        send h, {t, 0}
    end
end



defmodule ProcessesChain do
    # Child process is 
    #  - initialized with next_pid
    #  - receives n, increments, sends to next_pid

    def child_process(next_pid) do
        receive do
            n ->
                Process.sleep(10)
                IO.inspect("In child process " <> to_string n)
                send next_pid, n + 1
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
        last_child_pid = 1..count
        |> Enum.reduce(
            self(), 
            fn(_, next_pid)-> 
                spawn(__MODULE__, :child_process, [next_pid])
            end
        )

        send(last_child_pid, 0)

        receive do
            n ->
                IO.puts "In parent process " <> to_string n
        end
    end
end