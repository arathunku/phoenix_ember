defmodule PhoenixEmber.Config do
  def apps do
    Application.get_env(:phoenix_ember, :apps)
  end
end
