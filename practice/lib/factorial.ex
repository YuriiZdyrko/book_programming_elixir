defmodule Factorial do
  def f(1), do: 1
  def f(n), do: n * f(n - 1)
end

defmodule FactorialTail do
  # This is function head. It's used to define default values
  def f(n, r \\ 1)

  def f(1, r), do: r
  def f(n, r), do: f(n - 1, r * n)
end

defmodule Sum do
  def f(0), do: 0
  def f(n), do: n + f(n - 1)
end

defmodule GCD do
  def f(a, b, divisor \\ 1, largest \\ 1)

  def f(a, b, divisor, largest) when divisor <= a and divisor <= b do
    if rem(a, divisor) == 0 && rem(b, divisor) == 0 do
      f(a, b, divisor + 1, divisor)
    else
      f(a, b, divisor + 1, largest)
    end
  end

  def f(a, b, _, largest), do: largest
end

defmodule GCD do
  def f(a, b, divisor \\ 1, largest \\ 1)

  def f(a, b, divisor, largest) when divisor <= a and divisor <= b do
    if rem(a, divisor) == 0 && rem(b, divisor) == 0 do
      f(a, b, divisor + 1, divisor)
    else
      f(a, b, divisor + 1, largest)
    end
  end

  def f(a, b, _, largest), do: largest
end
