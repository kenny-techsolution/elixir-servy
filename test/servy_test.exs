defmodule ServyTest do
  use ExUnit.Case
  doctest Servy.Parser

  alias Servy.Parser

  test "greets the world" do
    assert 1 + 1 == 2
  end

  test "parses a list of header fields into a map" do
    header_lines = ["A: 1", "B: 2"]
    headers = Parser.parse_headers(header_lines, %{})
    assert headers == %{"A" => "1", "B" => "2"}
  end
end
