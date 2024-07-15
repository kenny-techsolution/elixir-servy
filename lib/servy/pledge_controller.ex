def pledge_controller do
  def create(conv, %{"name"=> name, "amount"=> amount}) do
    Servy.PledgeServer.create_pledge(name, String.to_integer(amount))
    %{ conv | status: 201, resp_body: "#{name} pledged #{amount}"}
  end

  def index() do
    pledges = Servy.PledgeServer.get_pledges()
    %{ conv | status: 201, resp_body: inspect pledges}
  end
end
