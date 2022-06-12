defmodule Soliton do
  @moduledoc """
  Soliton-like behavior in automata

  see:

  - https://www.sciencedirect.com/science/article/abs/pii/0167278986900680
  - https://www.cs.princeton.edu/~ken/soliton-like86.pdf
  """

  import Integer, only: [is_even: 1]

  @typedoc "State of cells."
  @type state :: 0 | 1

  @doc """
  Runs a automaton.

  - `seed` - list of states
  - `generation` - number of generation
  - `r` - range (default `3`)
  """
  @spec run([state()], pos_integer(), pos_integer()) :: [[state()]]
  def run(seed, generation, r \\ 3) do
    width = length(seed)

    1..(width * (generation - 1))
    |> Enum.reduce(Enum.reverse(seed), fn _, line ->
      ps = line |> Enum.drop(width - r - 1) |> Enum.take(r + 1)
      cs = line |> Enum.take(r)

      next_cell =
        case Enum.sum(ps) + Enum.sum(cs) do
          0 -> 0
          i when is_even(i) -> 1
          _ -> 0
        end

      [next_cell | line]
    end)
    |> Enum.reverse()
    |> Enum.chunk_every(width)
  end
end
