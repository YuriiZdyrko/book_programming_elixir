defmodule Charlist do
    def asci(str \\ 'asdfasdfфівафіва123') do
        Enum.all?(str, fn char -> 
            char in 1..200
        end)
    end

    def anagram(w1 \\ "asdf", w2 \\ "fdsa") do
        c1 = to_charlist w1
        c2 = to_charlist w2

        Enum.sum(c1) == Enum.sum(c2)
    end
end