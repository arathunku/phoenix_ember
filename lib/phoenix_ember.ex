defmodule PhoenixEmber do

  def get_index(name) do
    {:ok, html} = File.read(PhoenixEmber.Path.index(name))


    html
  end
end
