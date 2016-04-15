defmodule Mix.Tasks.PhoenixEmber.Digest do
  use Mix.Task
  @shortdoc "Compile app(s)"

  def run(args) do
    {opts, args, _} = OptionParser.parse(args)
    name  = List.first(args)

    {:ok, _} = Application.ensure_all_started(:phoenix)

    outputs = if name do
      [PhoenixEmber.Commands.build(name)]
    else
      Mix.shell.info([:green,  "Building all defined apps."])
      PhoenixEmber.Config.apps
      |> Enum.map(fn {name, _} ->
        PhoenixEmber.Commands.build(name)
      end)
    end

    if Enum.any?(outputs, &(&1 == 1)) do
      Mix.shell.error("There was a problem with building apps. Logs above that line should contain more info.")
    else
      Mix.Project.build_structure()
      Mix.shell.info([:green,  "All app(s) have been billed successfully."])
    end
  end
end
