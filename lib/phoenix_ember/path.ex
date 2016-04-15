defmodule PhoenixEmber.Path do
  def index(name) do
    Path.join(dist(name), "/index.html")
  end

  def dist(name) do
    Path.expand("priv/static/#{name}")
  end

  def assets(name) do
    "#{dist(name)}/assets"
  end

  def ember do
    "node_modules/ember-cli/bin/ember"
  end

  def exec_dir(name) do
    Path.expand(name)
  end
end
