defmodule Countdown do
  def timer do
    Stream.resource(
      fn ->
        # the number of seconds to the start of the next minute
        {_h, _m, s} = :erlang.time()
        60 - s - 1
      end,
      fn
        # wait for the next second, then return its countdown
        0 ->
          {:halt, 0}

        count ->
          Process.sleep(1000)
          {[inspect(count)], count - 1}
      end,
      fn _ -> nil end
      # nothing to deallocate
    )
  end
end
