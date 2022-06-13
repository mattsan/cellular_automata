defmodule Mix.Tasks.Ca.Soliton do
  @moduledoc "Soliton-like behavior in automata"
  @shortdoc "Soliton-like behavior in automata"

  use Mix.Task

  alias Mix.Tasks.Ca.Soliton.Options

  @palette [{255, 255, 255}, {0, 0, 0}]

  @impl Mix.Task
  def run(args) do
    IO.puts("Soliton-like behavior in automata\n")

    args
    |> Options.parse()
    |> run_soliton()
  end

  defp run_soliton({:ok, %Options{help: false} = options}) do
    IO.puts("""
      output:     #{options.output}
      width:      #{length(options.seed)}
      generation: #{options.generation}
      seed:       #{Enum.join(options.seed)}
    """)

    bitmap =
      Soliton.run(options.seed, options.generation, options.range)
      |> List.flatten()

    pngex =
      Pngex.new(
        type: :indexed,
        width: length(options.seed),
        height: options.generation,
        depth: :depth8,
        palette: @palette
      )

    image = Pngex.generate(pngex, bitmap)
    File.write(options.output, image)
  end

  defp run_soliton({:ok, %Options{}}) do
    IO.puts("Help")
  end

  defp run_soliton({:error, reason}) do
    IO.puts(Options.error_message(reason))
  end
end
