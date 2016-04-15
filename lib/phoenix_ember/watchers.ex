defmodule PhoenixEmber.Watchers do
  import PhoenixEmber.Path
  import PhoenixEmber.Config

  import Supervisor.Spec

  def start_link() do
    case Supervisor.start_link(watchers(),
                               strategy: :one_for_one,
                               name: :phoenix_ember_watchers) do
      {:ok, pid} ->
        {:ok, pid}
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp watchers do
    apps
    |> Enum.filter(fn {_, opts} -> Keyword.get(opts, :watch, false) end)
    |> Enum.map(&(elem(&1, 0)))
    |> Enum.map(fn (name) ->
      worker(
        Phoenix.Endpoint.Watcher,
        [
          exec_dir(name),
          "node",
          PhoenixEmber.Commands.prepare_build(name, watch: true)
        ],
        id: {"npm", PhoenixEmber.Commands.prepare_build(name, watch: true)},
        restart: :transient
      )
    end)
  end
end
