defmodule Servy.Wildthings do
  alias Servy.Bear
  def list_bear do
    [
      %Bear{id: 1, name: "Polly", type: "Grizzly", hibernating: true},
      %Bear{id: 2, name: "Sally", type: "Polar", hibernating: false},
      %Bear{id: 3, name: "Charlie", type: "Polar", hibernating: false},
      %Bear{id: 4, name: "Max", type: "Polar", hibernating: false},
      %Bear{id: 5, name: "Buddy", type: "Polar", hibernating: false},
      %Bear{id: 6, name: "Jack", type: "Polar", hibernating: false},
      %Bear{id: 7, name: "Toby", type: "Polar", hibernating: false},
      %Bear{id: 8, name: "Lily", type: "Polar", hibernating: false},
      %Bear{id: 9, name: "Lola", type: "Polar", hibernating: false},
      %Bear{id: 10, name: "Lily", type: "Polar", hibernating: false},
    ]
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bear(), fn bear -> bear.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id |> String.to_integer |> get_bear
  end
end
