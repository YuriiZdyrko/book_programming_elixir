defmodule WithExpr do
  # Benefits        
  # - don’t want those variables to leak out into the wider scope
  # - control over pattern-matching failures

  def example do
    with a <- "1",
         {:ok, value} <- {:ok, "result"} do
      IO.inspect("success")
    end

    with a <- "1",
         {:ok, value} <- {:error, "result error"} do
      IO.inspect("success")
    else
      {:another_err, _} -> IO.inspect("ignored")
      {:error, error} -> IO.inspect(error)
    end
  end
end
