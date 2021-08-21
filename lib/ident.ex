defmodule Ident do
  @moduledoc """
    This is a method that creates a unique Identicon for an inputed string
    and outputs a png file with the unique Identicon image.
  """

  @doc """
    This is the main function that takes a string and filename as arguments.
    Then outputs the identicon to a png file.

  ## Function
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
  """
  @spec main(
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | byte,
              binary | []
            ),
          any
        ) :: :ok | {:error, atom}
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

  @doc """
    This function saves the final image to the the root of the directory
    with the filename inputed.

  ##Function
      def save_image(image, filename) do
        File.write("\#{filename}.png", image)
      end
  """

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

  @doc """
    This function draws the image with the egd drawer and then renders
    the image to container built.

  ## Function
      def draw_the_image(%Ident.Image{color: color, grid_squares: grid_squares}) do
        container = :egd.create(250, 250)
        color_square = :egd.color(color)

        Enum.each(grid_squares, fn {top_left, bottom_right} ->
          :egd.filledRectangle(container, top_left, bottom_right, color_square)
        end)

        :egd.render(container)
      end
  """

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

  @doc """
    This functions creates the points for the squares. It creates a list
    of tuples of tuples that contains the coordinates of the top left square
    and the coordinate of the bottom right square. Calculated using the index.

  ## Function
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
  """

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

  @doc """
    This function filters the grid to only output even hex numbers.

  ## Function
      def filter_odds(%Ident.Image{grid: grid} = image) do
        filtered_grid =
          Enum.filter(grid, fn {code, _index} ->
            rem(code, 2) == 0
          end)

        %Ident.Image{image | grid: filtered_grid}
      end
  """

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

  @doc """
    This function creates a list of tuples containing the hex number
    and its index.

  ## Function
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
  """

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

  @doc """
    This functions creates a chunk or sub-list that is symetrical.

  ## Function
      def create_row(chunk) do
        [a, b, _c] = chunk
        chunk ++ [b, a]
      end
  """

  @spec create_row([...]) :: [...]
  def create_row(chunk) do
    [a, b, _c] = chunk
    chunk ++ [b, a]
  end

  @doc """
    This function turns a string into a hash with the md5 algorithm.
    It then converts that to a list of integers.

  ## Function
      def hash_string(string) do
        hex =
          :crypto.hash(:md5, string)
          |> :binary.bin_to_list()

        %Ident.Image{hex: hex}
      end
  """

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

  @doc """
    This function picks the color from the first three integers
    in the list.

  ## Function
      def pick_color(%Ident.Image{hex: [r, g, b | _tail]} = image) do
        %Ident.Image{image | color: {r, g, b}}
      end
  """

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
