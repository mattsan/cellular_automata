defmodule GHModel do
  @moduledoc """
  グリーンベルグ゠ヘイスティングモデル (Greenberg-Hastings model) の実装例

  see [Greenberg–Hastings cellular automaton - Wikipedia](https://en.wikipedia.org/wiki/Greenberg–Hastings_cellular_automaton)

  コマンドラインから実行可能。

  ```sh
  $ mix run -e GHModel.generate
  ```
  """

  @type field :: binary()
  @type color_code :: 0 | 1 | 2

  @width 512
  @height 512
  @palette [
    {255, 255, 255},
    {255, 0, 0},
    {255, 255, 0}
  ]
  @retio 12
  @default_generations 1_000

  @doc """
  画像を生成する

  - `generate` - 生成する世代数（デフォルト: #{@default_generations}）
  """
  @spec generate(non_neg_integer()) :: :ok
  def generate(generations \\ @default_generations) do
    File.mkdir_p("images")
    Owl.ProgressBar.start(
      id: :generations,
      label: "generations",
      total: generations,
      timer: true,
      bar_width_ratio: 0.85
    )

    1..generations
    |> Enum.reduce(seed(@width, @height, @retio), fn i, field ->
      write_image(filename(i), field)
      Owl.ProgressBar.inc(id: :generations)
      GHModel.Field.Nif.develop(@width, @height, field)
    end)
  end

  @doc """
  ファイル名を生成する

  ## 引数

  - `generation` - 世代番号

  ## 戻り値

  - 名前の中に世代番号を含んだファイル名
  """
  @spec filename(non_neg_integer()) :: String.t()
  def filename(generation) when is_integer(generation) and generation >= 0 do
    Path.join(["images", :io_lib.format("gh-~5.10.0b.png", [generation])])
  end

  @doc """
  ビットマップを PNG 形式の画像として保存する

  ## 引数

  - `filename` - 出力するファイル名
  - `bitmap` - 画像のビットマップ
  """
  @spec write_image(String.t(), field()) :: :ok
  def write_image(filename, bitmap) do
    pngex =
      Pngex.new(type: :indexed, width: @width, height: @height, depth: :depth8, palette: @palette)

    image = Pngex.generate(pngex, bitmap)
    File.write(filename, image)
  end

  @doc """
  場の初期状態を生成する

  - `width` - 場の幅
  - `height` - 場の高さ
  - `retio` - ドットの数の比率（1〜100）

  ## 戻り値

  - 場の状態
  """
  @spec seed(pos_integer(), pos_integer(), pos_integer()) :: field()
  def seed(width, height, retio) do
    for _ <- 1..(width * height), into: <<>> do
      case :rand.uniform(100) do
        i when i > retio -> <<0>>
        i when i > div(retio, 2) -> <<1>>
        _ -> <<2>>
      end
    end
  end
end
