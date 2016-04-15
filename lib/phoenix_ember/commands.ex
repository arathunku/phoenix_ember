defmodule PhoenixEmber.Commands do
  import PhoenixEmber.Path
  import PhoenixEmber.Config

  def test(name) do
    prepare_test(name) |> exec(name)
  end

  def build(name, opts \\ []) do
    prepare_build(name, opts) |> exec(name)
  end

  def prepare_test(name) do
    [
      cmd_prefix(name),
      "test",
      "--environment",
      build_env
    ]
  end

  def prepare_build(name, opts \\ []) do
    opts = Keyword.put_new(opts, :watch, false)

    [
      cmd_prefix(name),
      "build",
      "--watch", Keyword.get(opts, :watch),
      "--environment", build_env,
      "--output-path", dist(name)
    ]
  end


  defp cmd_prefix(name) do
    ember
  end

  defp exec(cmd, name) do
    Mix.Shell.IO.cmd("(cd #{exec_dir(name)} && #{cmd |> Enum.join(" ")})")
  end

  defp build_env do
    if(Mix.env == :prod, do: "production", else: "development")
  end
end
