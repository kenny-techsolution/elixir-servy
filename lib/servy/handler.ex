defmodule Servy.Handler do
  require Logger
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2]

  alias Servy.Conv
  @moduledoc "Handles HTTP requests"

  @doc "transform the request into a response"
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def route(%{ method: "GET", path: "/wildthings" } = conv) do
    %Conv{ conv| status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%{ method: "GET", path: "/bears" } = conv) do
    %Conv{ conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  @pages_path Path.expand("../../pages", __DIR__)

  def route(%{ method: "GET", path: "/bears/new" } = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%{ method: "GET", path: "/bears/"<>id } = conv) do
    %Conv{ conv | status: 200, resp_body: "Bear #{id}"}
  end

  def route(%{ method: "DELETE", path: "/bears/" <> _id} =conv) do
    %Conv{ conv | status: 403, resp_body: "Deleting a bear is forbidden"}
  end

  def route(%{ method: "GET", path: "/" <> name}=conv) do
    @pages_path
    |> Path.join("#{name}.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%{ path: path } = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here"}
  end



  def emojify(%{ status: 200}=conv) do
    %{ conv | resp_body: "🐻 #{conv.resp_body} 🐻"}
  end

  def format_response(%Conv{} = conv) do
    """
      HTTP/1.1 #{Conv.full_status(conv)}
      Content-Type: text/html
      Content-Length: #{byte_size(conv.resp_body)}

      #{conv.resp_body}
    """
  end


end

request = """
GET /bears/new HTTP/1.0
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

Servy.Handler.handle(request)
