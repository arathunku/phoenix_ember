defmodule PhoenixEmber.Helpers.Assets do
  import PhoenixEmber.Path

  def ember_script_tags(name, opts \\ []) do
    { :safe, script_tags(name) }
  end

  def ember_stylesheet_tags(name) do
    { :safe, stylesheet_tags(name) }
  end

  defp script_tags(name, opts \\ []) do
    opts = default_opts(name, opts)


    assets_by(name, ~r/vendor(.*)\.js\z/) ++ assets_by(name, ~r/#{name}(.*)\.js\z/)
    |> Enum.map(&([Keyword.get(opts, :prepand), &1]))
    |> Enum.map(&(["<script src=\"", &1, "\"></script>"]))
    |> Enum.join()
  end

  defp stylesheet_tags(name, opts \\ []) do
    opts = default_opts(name, opts)

    assets_by(name, ~r/vendor(.*)\.js\z/) ++ assets_by(name, ~r/#{name}(.*)\.js\z/)
    |> Enum.map(&([Keyword.get(opts, :prepand), &1]))
    |> Enum.map(&(["<link rel=\"stylesheet\" href=\"", &1, "\">"]))
    |> Enum.join()
  end

  defp assets_by(name, predicate) do
    {:ok, files } = File.ls(assets(name))

    Enum.filter(files, &(Regex.match?(predicate, &1)))
  end

  defp default_opts(name, opts) do
    Keyword.put_new(opts, :prepand, "#{name}/assets/")
  end
end
