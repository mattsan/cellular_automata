defmodule Soliton do
  @moduledoc """
  Soliton-like behavior in automata

  see:

  - https://www.sciencedirect.com/science/article/abs/pii/0167278986900680
  - https://www.cs.princeton.edu/~ken/soliton-like86.pdf
  """

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
    seed
    |> Stream.unfold(&{&1, develop(&1, r)})
    |> Enum.take(generation)
  end

  @spec develop([state()], pos_integer()) :: [state()]
  defp develop(list, r)

  defp develop(list, r) do
    develop([], list, r)
  end

  @spec develop([state()], [state()], pos_integer()) :: [state()]
  defp develop(left, right, r)

  defp develop(left, [], _) do
    left
    |> Enum.reverse()
  end

  defp develop(left, [c0 | right], r) do
    c1 = f(Enum.take(left, r) ++ [c0] ++ Enum.take(right, r))

    develop([c1 | left], right, r)
  end

  @spec f([state()]) :: state()
  defp f(list) do
    import Integer, only: [is_even: 1]

    list
    |> Enum.sum()
    |> case do
      i when i > 0 and is_even(i) -> 1
      _ -> 0
    end
  end
end
