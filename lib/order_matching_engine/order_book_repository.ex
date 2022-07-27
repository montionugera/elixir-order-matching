defmodule OrderBookRepository do

  @moduledoc """
  Documentation for `Repository of Order Book`.
  """


  @doc """
  Write Order Book to file.

  ## Examples
    iex> order_book = %OrderMatchingEngine.OrderBookModel{ buy: [
    ...> %OrderMatchingEngine.OrderInfo{price: 130.003, volume: 3.4},
    ...> ],
    ...> sell: [
    ...>    %OrderMatchingEngine.OrderInfo{price: 100.003, volume: 2.4},
    ...>  ]
    ...>  }
    iex> filename = 'tmp/output.json'
    iex> OrderBookRepository.save(order_book,filename)
    iex> File.read(filename)
    {:ok, ~s({"sell":[{"volume":2.4,"price":100.003}],"buy":[{"volume":3.4,"price":130.003}]})}
  """
  def save(order_book, filename \\ "output.json") do
    File.rm(filename)
    File.write(filename, Poison.encode!(order_book), [:binary])
  end
end
