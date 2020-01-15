defmodule NumberGuess do
  def f(actual, range \\ 1..100_000) do
    first = List.first(Enum.to_list(range))
    last = List.last(Enum.to_list(range))

    check_match(actual, first, last)
  end

  def check_match(actual, first, last) do
    check_match(actual, first, last, middle(first, last))
  end

  def check_match(actual, first, _, middle) when actual < middle do
    IO.inspect("--")
    IO.inspect(first)
    IO.inspect(middle)
    IO.inspect("<")
    check_match(actual, first, middle)
  end

  def check_match(actual, first, last, middle) when actual > middle do
    IO.inspect("--")
    IO.inspect(last)
    IO.inspect(middle)
    IO.inspect(">")
    check_match(actual, middle, last)
  end

  def check_match(actual, first, _, middle) when actual == middle do
    IO.inspect("SUCCESS")
    actual
  end

  defp middle(first, last) do
    first + Float.round(Kernel./(last - first, 2))
  end
end
