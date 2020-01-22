defprotocol MyProtocol do
    @fallback_to_any true
    def inspect(thing, opts)
end

defimpl Inspect, for: Reference do
    @moduledoc """
    Usage:
    inspect (ref(0, 1, 2, 3))
    """

    def inspect(ref, _opts) do
        '#Ref' ++ rest = :erlang.ref_to_list(ref)
        "#Reference" <> IO.iodata_to_binary(rest)
    end
end


defprotocol Caesar do
  def encrypt(thing, shift)

  def rot13(thing)
end

defimpl Caesar, for: BitString do
  def encrypt(string, shift) when shift > byte_size(string) do
      encrypt(string, rem(shift, byte_size(string)))
  end 

  def encrypt(<<head :: binary-size(1)>> <> rest, shift) when shift > 0 do
      encrypt(rest <> head, shift - 1)
  end

  def encrypt(string, 0), do: string

  def rot13(string), do: encrypt(string, 13)
end

defimpl Caesar, for: List do
  def encrypt(list, shift) when shift > length(list) do
      encrypt(list, rem(shift, length(list)))
  end

  def encrypt([h | t], shift) when shift > 0 do
      encrypt(t ++ h, shift - 1)
  end

  def encrypt(list, 0), do: list

  def rot13(list), do: encrypt(list, 13)
end
