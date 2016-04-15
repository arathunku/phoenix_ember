defmodule Mix.Tasks.PhoenixEmber.Test do
  use Mix.Task
  @shortdoc "Runs ember's app tests"

  def run(args) do
    {opts, args, _} = OptionParser.parse(args)
    name  = List.first(args)

    outputs = if name do
      [PhoenixEmber.Commands.test(name)]
    else
      PhoenixEmber.Config.apps
      |> Enum.map(fn {name, _} -> PhoenixEmber.Commands.test(name) end)
    end

    if Enum.any?(outputs, &(&1 == 1)) do
      Mix.shell.error("Some tests failed. Look into output")
    else
      Mix.shell.info([:green,  "All tests passed"])
    end
  end
end
