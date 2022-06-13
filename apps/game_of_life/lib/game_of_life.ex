defmodule GameOfLife do
  @moduledoc """
  Implements *Conway's Game of Life* with Elixir and Rust.

  see [Conway's Game of Life - Wikipedia](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)
  """

  @width 320
  @height 320
  @palette [{255, 255, 255}, {0, 0, 0}]

  @spec run(non_neg_integer()) :: binary()
  def run(count \\ 10_000) do
    File.mkdir_p("images")
    Owl.ProgressBar.start(
      id: :count,
      label: "count",
      total: count,
      timer: true,
      bar_width_ratio: 0.85
    )

    1..count
    |> Enum.reduce(seed(), fn i, field ->
      pngex =
        Pngex.new(
          type: :indexed,
          width: @width,
          height: @height,
          depth: :depth8,
          palette: @palette
        )

      image = Pngex.generate(pngex, field)
      File.write(filename(i), image)

      Owl.ProgressBar.inc(id: :count)
      GameOfLife.Nif.next(@width, @height, field)
    end)
  end

  def run_ex(count \\ 10_000) do
    Owl.ProgressBar.start(
      id: :count,
      label: "count",
      total: count,
      timer: true,
      bar_width_ratio: 0.85
    )

    1..count
    |> Enum.reduce(:array.from_list(String.to_charlist(seed())), fn i, field ->
      pngex =
        Pngex.new(
          type: :indexed,
          width: @width,
          height: @height,
          depth: :depth8,
          palette: @palette
        )

      image = Pngex.generate(pngex, :array.to_list(field))
      File.write(filename(i), image)

      Owl.ProgressBar.inc(id: :count)

      next_field =
        Enum.flat_map(0..(@height - 1), fn y ->
          Enum.map(0..(@width - 1), fn x ->
            left = rem(x + @width - 1, @width)
            right = rem(x + 1, @width)
            top = rem(y + @height - 1, @height)
            bottom = rem(y + 1, @height)

            sum =
              [
                :array.get(top * @width + left, field),
                :array.get(top * @width + x, field),
                :array.get(top * @width + right, field),
                :array.get(y * @width + left, field),
                :array.get(y * @width + right, field),
                :array.get(bottom * @width + left, field),
                :array.get(bottom * @width + x, field),
                :array.get(bottom * @width + right, field)
              ]
              |> Enum.sum()

            case {:array.get(y * @width + x, field), sum} do
              {1, 2} -> 1
              {1, 3} -> 1
              {0, 3} -> 1
              _ -> 0
            end
          end)
        end)

      :array.from_list(next_field)
    end)
  end

  @spec filename(non_neg_integer()) :: String.t()
  defp filename(i) do
    "images/field-#{String.pad_leading(to_string(i), 5, "0")}.png"
  end

  @spec seed :: binary()
  defp seed do
    for _ <- 1..(@width * @height), into: <<>> do
      c =
        case :rand.uniform(10) do
          1 -> 1
          _ -> 0
        end

      <<c>>
    end
  end
end
