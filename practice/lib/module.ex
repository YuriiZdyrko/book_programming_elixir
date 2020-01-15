defmodule Times do
  def times(n) do
    n * 2
  end

  def triples(n), do: n * 3

  def quadruple(n), do: times(n) * times(n)
end
