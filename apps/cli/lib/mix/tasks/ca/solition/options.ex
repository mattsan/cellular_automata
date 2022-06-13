defmodule Mix.Tasks.Ca.Soliton.Options do
  defstruct [:seed, :generation, :range, :output, :help]

  @output_filename "soliton.png"

  @options [
    strict: [
      generation: :integer,
      range: :integer,
      width: :integer,
      points: :string,
      output: :string,
      help: :boolean
    ],
    aliases: [
      g: :generation,
      r: :range,
      w: :width,
      p: :points,
      o: :output,
      h: :help
    ]
  ]
  @points "490,493,494,496,497,500,570,572,630,631,632,633,634,635,710,711,712"

  @doc false
  def new do
    %__MODULE__{
      seed: [],
      generation: 720,
      range: 3,
      output: @output_filename,
      help: false
    }
  end

  def parse(args) do
    case OptionParser.parse(args, @options) do
      {options, [], []} ->
        {seed_options, operation_options} = Keyword.split(options, [:width, :points])

        with {:ok, points} <- parse_points(Keyword.get(seed_options, :points, @points)),
             width <- Keyword.get(seed_options, :width, 720),
             options <- Keyword.put(operation_options, :seed, expand_line(width, points)) do
          {
            :ok,
            options
            |> Enum.reduce(new(), fn {key, value}, acc -> %{acc | key => value} end)
          }
        else
          error ->
            error
        end

      {_, args, invalid_options} ->
        {:error, {:invalid_arguments_or_options, args: args, options: invalid_options}}
    end
  end

  @doc false
  def expand_line(length, points) do
    0..(length - 1)
    |> Enum.reduce({[], Enum.sort(points)}, fn
      i, {line, [i | points]} -> {[1 | line], points}
      _, {line, points} -> {[0 | line], points}
    end)
    |> then(fn {line, _} -> Enum.reverse(line) end)
  end

  @doc false
  def parse_points(points_string) do
    points_string
    |> String.replace(",", " ")
    |> String.split()
    |> Enum.map(&Integer.parse/1)
    |> Enum.reduce({:ok, []}, fn
      {n, ""}, {:ok, points} -> {:ok, [n | points]}
      _, _ -> {:error, {:parsing_positions, points_string}}
    end)
    |> then(fn
      {:ok, points} -> {:ok, Enum.reverse(points)}
      error -> error
    end)
  end

  def error_message({:parsing_positions, points_string}) do
    """
      invalid points: #{points_string}
    """
  end

  def error_message({:invalid_arguments_or_options, args: args, options: invalid_options}) do
    """
      invalid options: #{Enum.join(args ++ Enum.map(invalid_options, &elem(&1, 0)), ", ")}
    """
  end
end
