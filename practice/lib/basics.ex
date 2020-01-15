defmodule Basics do
  def pattern_match do
    a = 1
    1 = a
    # 2 = a error

    %{a: a, b: b} = entire_thing = %{a: 1, b: 2, c: 3}

    IO.inspect(a)
    IO.inspect(b)
    IO.inspect(entire_thing)

    # Ignoring exact value
    %{a: _, b: 2} = entire_thing = %{a: 1, b: 2, c: 3}

    # Pin operator will force matching to exact value, 
    # instead of binding to variable
    a = 1
    ^a = 1
  end
end
