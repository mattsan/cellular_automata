defmodule Ca.Soliton.OptionsTest do
  use ExUnit.Case

  alias Mix.Tasks.Ca.Soliton.Options

  describe "parse/1 default" do
    test "default" do
      expected_positions =
        ~w[490 493 494 496 497 500 570 572 630 631 632 633 634 635 710 711 712]
        |> Enum.map(&String.to_integer/1)

      assert {:ok, %Options{} = options} = Options.parse([])
      assert options.generation == 720
      assert options.range == 3
      assert options.seed == Options.expand_line(720, expected_positions)
      assert options.help == false
    end
  end

  describe "parse/1 generation" do
    test "valid" do
      assert {:ok, %Options{} = options} = Options.parse(~w[--generation 123])
      assert options.generation == 123
    end

    test "valid alias" do
      assert {:ok, %Options{} = options} = Options.parse(~w[-g 234])
      assert options.generation == 234
    end

    test "invalid" do
      assert {:error, {:invalid_arguments_or_options, args: args, options: invalid_options}} =
               Options.parse(~w[-g two-trhee-four])

      assert args == []
      assert invalid_options == [{"-g", "two-trhee-four"}]
    end
  end

  describe "parse/1 range" do
    test "vaild" do
      assert {:ok, %Options{} = options} = Options.parse(~w[--range 5])
      assert options.range == 5
    end

    test "valid alias" do
      assert {:ok, %Options{} = options} = Options.parse(~w[-r 6])
      assert options.range == 6
    end

    test "invalid" do
      assert {:error, {:invalid_arguments_or_options, args: args, options: invalid_options}} =
               Options.parse(~w[-r six])

      assert args == []
      assert invalid_options == [{"-r", "six"}]
    end
  end

  describe "parse/1 width & points" do
    test "valid" do
      assert {:ok, %Options{} = options} = Options.parse(~w[--width 345 --points 100,200,300])
      assert Options.expand_line(345, [100, 200, 300]) == options.seed
    end

    test "invalid / invalid width" do
      assert {:error, {:invalid_arguments_or_options, [args: args, options: invalid_options]}} =
               Options.parse(~w[--width three-four-five --points 100,200,300])

      assert args == []
      assert invalid_options == [{"--width", "three-four-five"}]
    end

    test "invalid / invalid points" do
      assert {:error, {:parsing_positions, "hundred,two-hundred,three-hundred"}} =
               Options.parse(~w[--width 345 --points hundred,two-hundred,three-hundred])
    end
  end

  describe "parse/1 output" do
    test "valid" do
      assert {:ok, %Options{} = options} = Options.parse(~w[--output soliton.png])
      assert options.output == "soliton.png"
    end

    test "valid alias" do
      assert {:ok, %Options{} = options} = Options.parse(~w[-o soliton.png])
      assert options.output == "soliton.png"
    end

    test "invalid" do
      assert {:error, {:invalid_arguments_or_options, [args: args, options: invalid_options]}} =
               Options.parse(~w[-o])

      assert args == []
      assert invalid_options == [{"-o", nil}]
    end
  end

  describe "parse/1 help" do
    test "valid" do
      assert {:ok, %Options{} = options} = Options.parse(~w[--help])
      assert options.help == true
    end
  end

  describe "expand_line/1" do
    test "empty" do
      expected = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      assert Options.expand_line(16, []) == expected
    end

    test "points" do
      expected = [1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1]
      assert Options.expand_line(16, [0, 4, 11, 15]) == expected
    end
  end

  describe "parse_points/1" do
    test "valid / blank" do
      assert {:ok, []} = Options.parse_points("")
    end

    test "valid / separeate numbers with commnas" do
      assert {:ok, [1, 1, 2, 3, 5, 8]} = Options.parse_points("1,1,2,3,5,8")
    end

    test "valid / separeate numbers with spaces" do
      assert {:ok, [1, 1, 2, 3, 5, 8]} = Options.parse_points("1 1 2 3 5 8")
    end

    test "valid / separeate numbers with commnas and spaces" do
      assert {:ok, [1, 1, 2, 3, 5, 8]} = Options.parse_points("1, 1, 2, 3, 5, 8")
    end

    test "invalid / invalid delimiters" do
      assert {:error, {:parsing_positions, "1.1.2.3.5.8"}} = Options.parse_points("1.1.2.3.5.8")
    end

    test "invalid / non-number characters" do
      assert {:error, {:parsing_positions, "fibonacci"}} = Options.parse_points("fibonacci")
    end
  end
end
