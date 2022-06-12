defmodule SolitonTest do
  use ExUnit.Case
  doctest Soliton

  describe "run/2" do
    test "0 0 0 0 0 0 1 0 1 0" do
      input =
        ~w[0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0]
        |> Enum.map(&String.to_integer/1)

      expected =
        [
          ~w[0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0],
          ~w[0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0],
          ~w[0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0],
          ~w[0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0],
          ~w[0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0]
        ]
        |> Enum.map(fn line -> line |> Enum.map(&String.to_integer/1) end)

      assert Soliton.run(input, 5) == expected
    end

    test "0 0 0 0 0 0 1 1 1 0" do
      input =
        ~w[0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0]
        |> Enum.map(&String.to_integer/1)

      expected =
        [
          ~w[0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0],
          ~w[0 0 0 0 0 0 0 1 1 0 1 0 0 0 0 0],
          ~w[0 0 0 0 0 1 0 1 1 0 0 0 0 0 0 0],
          ~w[0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0],
          ~w[0 0 1 1 0 1 0 0 0 0 0 0 0 0 0 0]
        ]
        |> Enum.map(fn line -> line |> Enum.map(&String.to_integer/1) end)

      assert Soliton.run(input, 5) == expected
    end
  end
end
