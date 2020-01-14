defmodule AnonFunc do
    def example do
        func = fn (a, b) -> a + b end

        func.(1, 3)
    end

    def ex_a(0, 0, c) do
        "FizzBuzz"
    end

    def ex_a(0, b, c) do
        "Fizz"
    end

    def ex_a(a, 0, c) do
        "Buzz"
    end

    def ex_a_test do
        "FizzBuzz" = ex_a 0, 0, "blah"

        "Fizz" = ex_a 0, "foo", "bar"

        "Buzz" = ex_a "foo", 0, "bar"
    end



    def ex_b(str) do
        fn second_str -> 
            str <> second_str
        end
    end

    def ex_b_test do
        ex_b("pre_").("meditation")
    end


    def ex_c do
        # Enum.map [1,2,3,4], fn x -> x + 2 end
        # Enum.each [1,2,3,4], fn x -> IO.inspect x end

        Enum.map [1,2,3,4], &(&1 + 2)
        Enum.each [1,2,3,4], &IO.inspect/1
    end
end