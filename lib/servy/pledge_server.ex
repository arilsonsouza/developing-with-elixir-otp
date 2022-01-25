defmodule Servy.PledgeServer do
  def create(name, amount) do
    {:ok, id} = send_pledge_to_service(name, amount)

    # CACHE THE PLEDGE:
    [{name, amount}]
  end

  def recent_pledges do
    # Returns the most recent pledges (cache):
  end

  defp send_pledge_to_service(_name, _amount) do
    # CODE GOES HERE TO SEND THE PLEDGE TO EXTERNAL SERVICE
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
