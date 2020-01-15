defmodule KeywordList do
  def long_syntax do
    [{:a, 1}, {:b, 2}, {:c, 3}]
  end

  def short_syntax do
    [a: 1, b: 2, c: 3]
  end
end
