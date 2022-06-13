defmodule GHModel.Field.Nif do
  use Rustler, otp_app: :gh_model, crate: :ghmodel_field_nif

  def develop(_width, _height, _field), do: :erlang.nif_error(:nif_not_loaded)
end
