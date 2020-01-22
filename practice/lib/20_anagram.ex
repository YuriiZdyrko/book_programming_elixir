defmodule Dictionary do
  @moduledoc """
  Agent
  Groups words by signature (ordered characters list)
  Returns %{[signature] => [word, owrd, ...]} map for a word
  """

  @name __MODULE__

  def start_link,
    do: Agent.start_link(fn -> %{} end, name: @name)

  def add_words(words),
    do: Agent.update(@name, &do_add_words(&1, words))

  def anagrams_of(word),
    do: Agent.get(@name, &Map.get(&1, signature_of(word)))

  # Private

  defp do_add_words(map, words),
    do: Enum.reduce(words, map, &add_one_word(&1, &2))

  defp add_one_word(word, map),
    do: Map.update(map, signature_of(word), [word], &[word | &1])

  defp signature_of(word),
    do: word |> to_charlist |> Enum.sort() |> to_string
end

defmodule WordListLoader do
  @moduledoc """
  Example of using Task
  """

  @doc """
  Stream.map + Task.async = ❤
  """
  def load_from_files(file_names) do
    file_names
    |> Stream.map(fn name -> Task.async(fn -> load_task(name) end) end)
    |> Enum.map(&Task.await/1)
  end

  defp load_task(file_name) do
    File.stream!(file_name, [], :line)
    |> Enum.map(&String.trim/1)
    |> Dictionary.add_words()
  end
end

defmodule AnagramTest do
  def run do
    Dictionary.start_link()

    paths =
      ~w(1 2 3 4)
      |> Enum.map(fn filename -> "./assets/anagram/" <> filename end)
      |> WordListLoader.load_from_files()

    Dictionary.anagrams_of("organ")
  end
end
