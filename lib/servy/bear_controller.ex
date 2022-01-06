defmodule Servy.BearController do
  alias Servy.{Conv, Widlthings}

  def index(%Conv{} = conv) do
    bears = Widlthings.list_bears()

    %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def show(%Conv{} = conv, %{"id" => id}) do
    %{conv | status: 200, resp_body: "Bear #{id}"}
  end

  def create(%Conv{} = conv, %{"type" => type, "name" => name} = _params) do
    %{conv | status: 201, resp_body: "Create a #{type} bear named #{name}!"}
  end
end
