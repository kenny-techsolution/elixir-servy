defmodule Recurse do
  def sum([head| tail], acc) do
    acc = acc+head
    sum(tail, acc)
  end

  def sum([], acc), do: acc

  def triple([head| tail]) do
    [ head*3 | triple(tail)]
  end

  def triple([]), do: []

end
