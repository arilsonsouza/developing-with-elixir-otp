defmodule Servy do
  def hello(name) do
    "Hello, #{name}"
  end
end

Servy.hello("Elixir") |> IO.puts()
