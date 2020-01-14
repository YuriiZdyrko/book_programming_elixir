defmodule Lists do
    def concatenate do
        [1,2,3] ++ [2,4,5]
    end

    def difference do
        [1,2,3] -- [2,4,5] 
        # [1, 3]
    end

    def inclusion do
        4 in [1,3,4,5]
        # true
    end


    def get_length(list \\ [1,3,4,5])
    def get_length([_ | t]), do: 1 + get_length(t)
    def get_length([]), do: 0

    def square_list(list \\ [1,2,3,4], result \\ [])
    def square_list([h | t], result), do: square_list(t, result ++ [h * h])
    def square_list([], result), do: result 

    def map(list \\ [1,2,3,4], mapper_fn \\ fn(arg) -> arg * 2 end)
    def map([h | t], mapper_fn) do
        [mapper_fn.(h) | map(t, mapper_fn)]
    end
    def map([], _), do: []

    def reduce(list \\ [1,2,3,4], reducer_fn \\ fn(arg1, arg2) -> arg1 * arg2 end, seed \\ 1)
    def reduce([h | t], reducer_fn, seed), do: reduce(t, reducer_fn, reducer_fn.(h, seed))
    def reduce([], _, seed), do: seed
end