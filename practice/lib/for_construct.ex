defmodule ForConstruct do
  # It takes Enumerable (Keyword List, List, Map, Range), 
  # and inserts into new Collectable structure (List, Map, Set)

  def for_example do
    maps = [
      %{a: 1, b: 2},
      %{a: 1, b: 3},
      %{a: 1, b: 4},
      %{a: 1, b: 5}
    ]

    for map = %{b: b} <- maps, b > 2 do
      %{b: b}
    end

    # [%{b: 4, b: 5}]
  end

  def into_example do
    [1, 2, 3, 4, 5] |> Enum.into(MapSet.new())

    [a: 1, b: 2] |> Enum.into(%{})

    1..10 |> Enum.into([])

    %{a: 1, b: 2} |> Enum.into([])
  end

  # AMAZING
  def for_into_example do
    for x <- ~w{ cat dog }, into: %{}, do: {x, String.upcase(x)}
    #  %{"cat" => "CAT", "dog" => "DOG"}
  end
end
