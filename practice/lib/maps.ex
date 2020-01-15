defmodule Maps do
  def example do
    my_var = 1

    [
      %{[1, 2, 3] => "list key"},
      %{%{a: 1, b: 2, c: 3} => "other map key"},
      %{:"#{my_var}" => "string atom key"},
      %{my_atom: "atom key"}
    ]
    |> Enum.each(&IO.inspect(&1))

    "keys can be anything"
  end
end
