# require IEx
# IEx.pry

defmodule Ident do
  def main(string) do
    string
    |> hash_string
    |> pick_color
    |> create_grid
  end

  @spec create_grid(%Ident.Image{:hex => list}) :: list
  def create_grid(%Ident.Image{hex: hex} = _image) do
    chunked_list = hex
    |> List.delete_at(length(hex) - 1)
    |> Enum.chunk_every(3)
    for chunk <- chunked_list do
      [a, b, _c] = chunk
      chunk ++ [a, b]
    end
  end

  @spec hash_string(
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | byte,
              binary | []
            )
        ) :: any
  def hash_string(string) do
    hex =
      :crypto.hash(:md5, string)
      |> :binary.bin_to_list()

    %Ident.Image{hex: hex}
  end

  @spec pick_color(%Ident.Image{
          :color => any,
          :hex => nonempty_maybe_improper_list
        }) :: %Ident.Image{
          :color => {any, any, any},
          :hex => nonempty_maybe_improper_list
        }
  def pick_color(%Ident.Image{hex: [r, g, b | _tail]} = image) do
    %Ident.Image{image | color: {r, g, b}}
  end
end
