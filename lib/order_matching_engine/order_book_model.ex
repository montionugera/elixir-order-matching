defmodule OrderMatchingEngine.OrderBookModel do
  @moduledoc """
  Data model for `OrderBook`.
  """
  defstruct buy: [], sell: []
  
end

defmodule OrderMatchingEngine.OrderInfo do
  @moduledoc """
  Data model as `OrderInfo`, element in `OrderBook`.
  """
  defstruct price:  100.003, volume: 2.4
end