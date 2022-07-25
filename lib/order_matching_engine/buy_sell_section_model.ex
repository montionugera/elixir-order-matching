defmodule OrderMatchingEngine.BuySellSectionModel do
  @moduledoc """
  Data model for `Buy and Sell section`.
  """
  defstruct buy: [], sell: []
  
end

defmodule OrderMatchingEngine.OrderInfo do
  @moduledoc """
  Data model for `OrderElement`.
  """
  defstruct price:  100.003, volume: 2.4
end