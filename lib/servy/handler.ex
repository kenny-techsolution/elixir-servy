defmodule Servy.Handler do

  def handle(request) do
    request
    |> parse
    |> route
    |> format_response
  end

  def parse(request) do
    #TODO Parse the request sting into a map.
    conv = %{ method: "GET", path: "/wildthings", resp_body: ""}
  end

  def route(conv) do
    conv = %{ method: "GET", path: "/wildthings", resp_body: "Bears"}
  end

  def format_response(conv) do
    """
      HTTP/1.1 200 OK\r\n
      Content-Type: text/html;
      Content-Length: 20

      Bears, Lions, Tigers
    """
  end

  request = """
    GET /wildthings HTTP/1.0\r\n
    Host: example.com\r\n
    User-Agent: ExampleBrowser/1.0\r\n
    Accept: */*\r\n

  """
end
