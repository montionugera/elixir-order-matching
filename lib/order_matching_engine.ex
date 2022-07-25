
defmodule OrderMatchingEngine do
  @moduledoc """
  Documentation for `OrderMatchingEngine`.
  """

  @doc """
  Load order from file

  ## Examples

      iex> OrderMatchingEngine.load_orders_from_file('fixtures/input.json')
      {:ok,
      %OrderInput{
       orders: [
         %OrderElement{amount: 2.4, command: "sell", price: 100.003},
         %OrderElement{amount: 3.4, command: "buy", price: 100.003},
         %OrderElement{amount: 2, command: "buy", price: 95.003},
         %OrderElement{amount: 1, command: "sell", price: 104.003}
       ]
      }}
  """
  def load_orders_from_file(filename) do
#    %OrderInput{orders: []}
    with {:ok, body} <- File.read(filename),
         {:ok, order_input} <- Poison.decode(body,as: %OrderInput{orders: [%OrderElement{}]})
      do
        order_input |> inspect |> IO.puts
        {:ok, order_input}
      end
  end
end
