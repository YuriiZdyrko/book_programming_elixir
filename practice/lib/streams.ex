defmodule Streams do
    alias Lists

    def ex do
        for n <- Lists.span(1, 10) do
            n
        end
    end
end