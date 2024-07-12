defmodule Servy.BearController do
  alias Servy.Conv
  alias Servy.Wildthings
  alias Servy.Bear

  def index(conv) do
    items = Wildthings.list_bear()
      |> Enum.filter(&Bear.is_grizzly(&1))
      |> Enum.sort(&Bear.order_asc_by_name(&1, &2))
      |> Enum.map(&bear_item(&1))
      |> Enum.join

    # Transform bears to an HTML list
    %Conv{ conv | status: 200, resp_body: "<ul>#{items}</ul>"}
  end

  defp bear_item(b) do
    "<li>#{b.name} - #{b.type}</li>"
  end

  def show(conv, %{"id"=> id}) do
    bear = Wildthings.get_bear(id)
    %Conv{ conv | status: 200, resp_body: "<h1>Bear #{bear.id}: #{bear.name}</h1>"}
  end

  def create(conv, %{"name"=>name, "type" => type}) do
    %Conv{ conv| status: 200, resp_body: "Created a #{type} bear named #{name}"}
  end

  def delete(conv, _params) do
    %Conv{ conv | status: 403, resp_body: "Deleting a bear is forbidden"}
  end
end
