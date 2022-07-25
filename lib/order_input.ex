defmodule OrderInput do
  @moduledoc """
  Data model for `OrderInput`.
  """
  defstruct [:orders]
end

defmodule OrderElement do
  @moduledoc """
  Data model for `OrderElement`.
  """
  defstruct command: "sell", price:  100.003, amount: 2.4
end

#{:ok, order_input} <- Poison.decode!(body,as %OrderInput{})