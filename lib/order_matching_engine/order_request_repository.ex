defmodule OrderRequestRepository do
  @moduledoc """
  Documentation for `Repository of Order request`.
  """

  @doc """
  get Order requests

  ## Examples

    iex> OrderRequestRepository.get('fixtures/input.json')
    {:ok,
      %OrderMatchingEngine.OrderRequest{
       orders: [
         %OrderMatchingEngine.OrderRequestItem{amount: 2.4, command: "sell", price: 100.003},
         %OrderMatchingEngine.OrderRequestItem{amount: 3.4, command: "buy", price: 100.003},
         %OrderMatchingEngine.OrderRequestItem{amount: 2, command: "buy", price: 95.003},
         %OrderMatchingEngine.OrderRequestItem{amount: 1, command: "sell", price: 104.003}
       ]
      }}
  """
  def get(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, order_input} <- Poison.decode(body,
             as: %OrderMatchingEngine.OrderRequest{orders: [%OrderMatchingEngine.OrderRequestItem{}]}) do
      {:ok, order_input}
    else
      _ -> raise "Could not get OrderRequest from file: " + filename
    end

  end
end
