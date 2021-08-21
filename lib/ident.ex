# require IEx
# IEx.pry

defmodule Ident do
  def main(string, filename) do
    string
    |> hash_string
    |> pick_color
    |> create_grid
    |> filter_odds
    |> create_squares
    |> draw_the_image
    |> save_image(filename)
  end

  @spec save_image(
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | byte,
              binary | []
            ),
          any
        ) :: :ok | {:error, atom}
  def save_image(image, filename) do
    File.write("#{filename}.png", image)
  end

  @spec draw_the_image(%Ident.Image{
          :color => atom | {byte, byte, byte} | {byte, byte, byte, byte},
          :grid_squares => any
        }) :: binary
  def draw_the_image(%Ident.Image{color: color, grid_squares: grid_squares}) do
    container = :egd.create(250, 250)
    color_square = :egd.color(color)

    Enum.each(grid_squares, fn {top_left, bottom_right} ->
      :egd.filledRectangle(container, top_left, bottom_right, color_square)
    end)

    :egd.render(container)
  end

  @spec create_squares(%Ident.Image{:grid => any, :grid_squares => any}) ::
          %Ident.Image{:grid => any, :grid_squares => list}
  def create_squares(%Ident.Image{grid: grid} = image) do
    grid_squares =
      Enum.map(grid, fn {_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end)

    %Ident.Image{image | grid_squares: grid_squares}
  end

  @spec filter_odds(%Ident.Image{:grid => any}) :: %Ident.Image{
          :grid => list
        }
  def filter_odds(%Ident.Image{grid: grid} = image) do
    filtered_grid =
      Enum.filter(grid, fn {code, _index} ->
        rem(code, 2) == 0
      end)

    %Ident.Image{image | grid: filtered_grid}
  end

  @spec create_grid(%Ident.Image{:grid => any, :hex => list}) ::
          %Ident.Image{:grid => [{any, integer}], :hex => list}
  def create_grid(%Ident.Image{hex: hex} = image) do
    grid =
      hex
      |> List.delete_at(length(hex) - 1)
      |> Enum.chunk_every(3)
      |> Enum.map(&create_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Ident.Image{image | grid: grid}
  end

  @spec create_row([...]) :: [...]
  def create_row(chunk) do
    [a, b, _c] = chunk
    chunk ++ [b, a]
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
