
defmodule OrderMatchingEngine do
  @moduledoc """
  Documentation for `OrderMatchingEngine`.
  """

  @doc """
  Load order from file

  ## Examples

      iex> OrderMatchingEngine.load_orders_from_file('fixtures/input.json')
      {:ok,
      %OrderMatchingEngine.OrderInput{
       orders: [
         %OrderMatchingEngine.OrderElement{amount: 2.4, command: "sell", price: 100.003},
         %OrderMatchingEngine.OrderElement{amount: 3.4, command: "buy", price: 100.003},
         %OrderMatchingEngine.OrderElement{amount: 2, command: "buy", price: 95.003},
         %OrderMatchingEngine.OrderElement{amount: 1, command: "sell", price: 104.003}
       ]
      }}
  """
  def load_orders_from_file(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, order_input} <- Poison.decode(body,as: %OrderMatchingEngine.OrderInput{orders: [%OrderMatchingEngine.OrderElement{}]})
      do
        order_input |> inspect |> IO.puts
        {:ok, order_input}
      end
  end


  @doc """
  Build Buy Sell Section from OrderInput

  ## Examples

    iex> {_,order_input} = OrderMatchingEngine.load_orders_from_file('fixtures/test_input_case_build_buy_sell_section.json')
    iex> OrderMatchingEngine.build_buy_sell_section(order_input)
    %OrderMatchingEngine.BuySellSectionModel{
    buy: [
      %OrderMatchingEngine.OrderInfo{price: 130.003, volume: 3.4},
      %OrderMatchingEngine.OrderInfo{price: 100.003, volume: 3.4},
      %OrderMatchingEngine.OrderInfo{price: 95.003, volume: 2}
    ],
    sell: [
      %OrderMatchingEngine.OrderInfo{price: 100.003, volume: 2.4},
      %OrderMatchingEngine.OrderInfo{price: 104.003, volume: 1},
      %OrderMatchingEngine.OrderInfo{price: 110.003, volume: 2.4},
      %OrderMatchingEngine.OrderInfo{price: 120.003, volume: 2.4}
    ]
    }

  """
  def build_buy_sell_section(%OrderMatchingEngine.OrderInput{orders: orders} = _order_input) do
    %OrderMatchingEngine.BuySellSectionModel{
      buy: orders
           |> Enum.filter(fn order -> order.command == "buy"  end)
           |> Enum.sort_by(&(&1.price),:desc)
           |> Enum.map(fn order -> %OrderMatchingEngine.OrderInfo{price: order.price,volume: order.amount } end),
      sell: orders
            |> Enum.filter(fn order -> order.command == "sell"  end)
            |> Enum.sort_by(&(&1.price),:asc)
            |> Enum.map(fn order -> %OrderMatchingEngine.OrderInfo{price: order.price,volume: order.amount } end),
    }
  end


  @doc """
  Build Buy Sell Section from OrderInput

  ## Examples
    iex> order_section = %OrderMatchingEngine.BuySellSectionModel{ buy: [
    ...> %OrderMatchingEngine.OrderInfo{price: 130.003, volume: 3.4},
    ...> ],
    ...> sell: [
    ...>    %OrderMatchingEngine.OrderInfo{price: 100.003, volume: 2.4},
    ...>  ]
    ...>  }
    iex> filename = 'tmp/output.json'
    iex> OrderMatchingEngine.write_order_section(order_section,filename)
    iex> File.read(filename)
    {:ok, ~s({"sell":[{"volume":2.4,"price":100.003}],"buy":[{"volume":3.4,"price":130.003}]})}
  """
  def write_order_section(order_section,filename \\ "output.json") do
    File.rm(filename)
    File.write(filename, Poison.encode!(order_section), [:binary])
  end
end
