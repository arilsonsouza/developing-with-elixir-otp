defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse()
    |> log()
    |> route()
    |> format_response()
  end

  def parse(request) do
    [method, path, _version] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, resp_body: ""}
  end

  def route(conv) do
    route(conv, conv.method, conv.path)
  end

  def route(conv, "GET", "/wildthings") do
    %{conv | resp_body: "Bears, Lions, Tigers"}
  end

  def route(conv, "GET", "/bears") do
    %{conv | resp_body: "Teddy, Smokey, Paddington"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp log(conv), do: IO.inspect(conv)
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request
|> Servy.Handler.handle()
|> IO.puts()

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request
|> Servy.Handler.handle()
|> IO.puts()

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request
|> Servy.Handler.handle()
|> IO.puts()
