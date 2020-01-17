defmodule BitsBytes do
  def basics do
    bitstring1 = <<1.234::size(32), 2, 3>>
    # <<63, 157, 243, 182, 2, 3>>

    byte_size(bitstring1) == 6

    bitstring2 = <<1.234::size(64), 2, 3>>
    # <<63, 243, 190, 118, 200, 180, 57, 88, 2, 3>>

    # 63, 243, 190, 118, 200, 180, 57 = 8 * 8 = 64 bits
    # 2, 3 = 16 bits

    # TOTAL = 80 bits

    # BYTE_SIZE = 80 / 8 = 10

    byte_size(bitstring2) == 10
  end

  def exe_center(str \\ ["cat", "zebra", "elephant", "largewordblah"]) do
    largest_len = String.length(List.last(str))

    result =
      for s <- str do
        pad =
          ((largest_len - String.length(s)) / 2)
          |> trunc

        String.duplicate("\s", pad) <> s <> "\n"
      end

    Enum.each(result, &IO.puts(&1))
  end

  def exe_capitalize_sentences(s \\ "oh. a DOG. woof. ") do
    s
    |> String.split(". ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(". ")
    |> String.trim()
  end

  def read_file do
    fixed_contents = "./assets/ch_11_p_225" |> File.stream!() |> Stream.map(&String.trim/1)

    [row1 | rest] = fixed_contents |> Enum.to_list()

    IO.inspect(row1)
    IO.inspect(rest)
  end
end
