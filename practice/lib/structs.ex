defmodule MyStruct do
  defstruct a: 1, b: 2

  def example do
    %MyStruct{a: 1, b: 3}
  end
end
