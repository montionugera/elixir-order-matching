defmodule OrderMatchingEngine.OrderRequest do
  @moduledoc """
  Data model for `OrderRequest`.
  """
  defstruct [:orders]
end

defmodule OrderMatchingEngine.OrderRequestItem do
  @moduledoc """
  Data model for `OrderRequestItem`, element of the `OrderRequest`.
  """
  defstruct command: "sell", price:  100.003, amount: 2.4
end
