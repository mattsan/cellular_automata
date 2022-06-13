defmodule GameOfLife.Nif do
  @moduledoc false
  use Rustler, otp_app: :game_of_life, crate: :game_of_life_nif

  def next(_width, _height, _field), do: :erlang.nif_error(:nif_not_loaded)
end
