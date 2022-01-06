defmodule Servy.BearController do
  alias Servy.{Conv, Wildthings, Bear}

  @templates_path Path.expand("../../templates/bears", __DIR__)
  def index(%Conv{} = conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

    render(conv, "index.eex", bears: bears)
  end

  def show(%Conv{} = conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    render(conv, "show.eex", bear: bear)
  end

  def create(%Conv{} = conv, %{"type" => type, "name" => name} = _params) do
    %{conv | status: 201, resp_body: "Create a #{type} bear named #{name}!"}
  end

  defp render(%Conv{} = conv, template_file, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template_file)
      |> EEx.eval_file(bindings)

    %{conv | status: 200, resp_body: content}
  end
end
