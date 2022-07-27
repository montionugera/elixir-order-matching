defmodule OrderMatchingEngine.OrderRequest do
  @moduledoc """
  Data model for `OrderInput`.
  """
  defstruct [:orders]
end

defmodule OrderMatchingEngine.OrderRequestItem do
  @moduledoc """
  Data model for `OrderElement`.
  """
  defstruct command: "sell", price:  100.003, amount: 2.4
end
