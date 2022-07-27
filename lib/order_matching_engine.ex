defmodule OrderMatchingEngine do
  @moduledoc """
  Documentation for `OrderMatchingEngine`.
  """



  @doc """
  Build Order book from order request file.

  ## Examples
    iex> OrderMatchingEngine.build_order_book_from_order_request_file('fixtures/input.json')
    %OrderMatchingEngine.OrderBookModel{
    buy: [%OrderMatchingEngine.OrderInfo{price: 100.003, volume: 1.0},
          %OrderMatchingEngine.OrderInfo{price: 95.003, volume: 2}],
    sell: [%OrderMatchingEngine.OrderInfo{price: 104.003, volume: 1}]}

  """
  def build_order_book_from_order_request_file(order_request_file) do
    OrderRequestRepository.get(order_request_file) |> elem(1)
      |> Map.get(:orders)
      |> Enum.reduce(%OrderMatchingEngine.OrderBookModel{},&( add_order_to_order_book(&1, &2)))
  end

  @doc """
  Add order to OrderBookModel, which automatically matching the order or / and put the order in the booking order.

  ## Examples

    iex> order_book = %OrderMatchingEngine.OrderBookModel{
    ...>buy: [
    ...>  %OrderMatchingEngine.OrderInfo{price: 100.000, volume: 3.4},
    ...>  %OrderMatchingEngine.OrderInfo{price: 95.003, volume: 2}
    ...>],
    ...>sell: [
    ...>  %OrderMatchingEngine.OrderInfo{price: 100.003, volume: 2.4},
    ...>  %OrderMatchingEngine.OrderInfo{price: 104.003, volume: 1},
    ...>  %OrderMatchingEngine.OrderInfo{price: 110.003, volume: 2.4},
    ...>  %OrderMatchingEngine.OrderInfo{price: 120.003, volume: 2.4}
    ...>]
    ...>}
    iex> order = %OrderMatchingEngine.OrderRequestItem{amount: 8.4, command: "buy", price: 105.003}
    iex> OrderMatchingEngine.add_order_to_order_book(order,order_book)
    %OrderMatchingEngine.OrderBookModel{
    buy: [%OrderMatchingEngine.OrderInfo{price: 105.003, volume: 5.0},
      %OrderMatchingEngine.OrderInfo{price: 100.000, volume: 3.4},
      %OrderMatchingEngine.OrderInfo{price: 95.003, volume: 2}
    ],
    sell: [
      %OrderMatchingEngine.OrderInfo{price: 110.003, volume: 2.4},
      %OrderMatchingEngine.OrderInfo{price: 120.003, volume: 2.4}
    ]
    }

  """
  def add_order_to_order_book(new_order, order_book \\ %OrderMatchingEngine.OrderBookModel{}) do
    order_info = %OrderMatchingEngine.OrderInfo{price: new_order.price, volume: new_order.amount}

    if new_order.command == "buy" do
      {matchable_orders, not_matchable_orders} = Enum.split_with(order_book.sell, &(&1.price <= new_order.price))
      {order_left, after_matching_sell_orders} = matching_orders(order_info, matchable_orders)
      after_matching_sell_orders = after_matching_sell_orders ++ not_matchable_orders
      buy_orders = order_book.buy ++ [order_left]

      %{
        order_book
        | sell:
            after_matching_sell_orders
            |> squash_orders
            |> Enum.filter(fn order -> order.volume > 0.0 end)
            |> Enum.sort_by(& &1.price, :asc),
          buy:
            buy_orders
            |> squash_orders
            |> Enum.filter(fn order -> order.volume > 0.0 end)
            |> Enum.sort_by(& &1.price, :desc)
      }
    else
      {matchable_orders, not_matchable_orders} = Enum.split_with(order_book.buy, &(&1.price >= new_order.price))

      {order_left, after_matching_buy_orders} = matching_orders(order_info, matchable_orders)
      after_matching_buy_orders = after_matching_buy_orders ++ not_matchable_orders

      %{
        order_book
        | sell:
            (order_book.sell ++ [order_left])
            |> squash_orders
            |> Enum.filter(fn order -> order.volume > 0.0 end)
            |> Enum.sort_by(& &1.price, :asc),
          buy:
            after_matching_buy_orders
            |> squash_orders
            |> Enum.filter(fn order -> order.volume > 0.0 end)
            |> Enum.sort_by(& &1.price, :desc)
      }
    end
  end

  @doc """
    Squash Orders, To squash orders as sum of volume group by price.

    ## Examples
    iex> orders = [
    ...> %OrderMatchingEngine.OrderInfo{price: 130.003, volume: 1.4},
    ...> %OrderMatchingEngine.OrderInfo{price: 130.003, volume: 0.1},
    ...> %OrderMatchingEngine.OrderInfo{price: 100.003, volume: 3.4},
    ...> %OrderMatchingEngine.OrderInfo{price: 95.003, volume: 2},
    ...> %OrderMatchingEngine.OrderInfo{price: 95.003, volume: 0.1}
    ...> ]
    iex> OrderMatchingEngine.squash_orders(orders)
    [ %OrderMatchingEngine.OrderInfo{price: 130.003, volume: 1.5},
      %OrderMatchingEngine.OrderInfo{price: 100.003, volume: 3.4},
      %OrderMatchingEngine.OrderInfo{price: 95.003, volume: 2.1}]
  """
  def squash_orders(sorted_orders) do
    orders_by_price =
      sorted_orders
      |> Enum.reduce(
        %{},
        fn order, orders_by_price ->
           Map.put(orders_by_price, order.price, Map.get(orders_by_price, order.price, []) ++ [order])
        end
      )

    sorted_orders
    |> Enum.reduce(
      [],
      fn order, prices ->
        if !Enum.member?(prices, order.price) do prices ++ [order.price] else prices end
      end
    )
    |> Enum.map(fn price ->
      %OrderMatchingEngine.OrderInfo{
        price: price,
        volume: Enum.reduce(orders_by_price[price], 0, &(&1.volume + &2))
      }
    end)
  end

  @doc """
    Matching Orders, To deduct volume in booking orders.

    ## Examples
    iex> order = %OrderMatchingEngine.OrderInfo{price: 130.003, volume: 3.4}
    iex> orders = [
    ...> %OrderMatchingEngine.OrderInfo{price: 130.003, volume: 1.4},
    ...> %OrderMatchingEngine.OrderInfo{price: 100.003, volume: 3.4},
    ...> %OrderMatchingEngine.OrderInfo{price: 95.003, volume: 2}
    ...> ]
    iex> OrderMatchingEngine.matching_orders(order,orders)
    {
      %OrderMatchingEngine.OrderInfo{price: 130.003, volume: 0.0},
      [ %OrderMatchingEngine.OrderInfo{price: 130.003, volume: 0.0},
        %OrderMatchingEngine.OrderInfo{price: 100.003, volume: 1.4},
        %OrderMatchingEngine.OrderInfo{price: 95.003, volume: 2.0}]
    }

  """
  def matching_orders(new_order, sorted_booking_orders) do
    IO.puts("matching_orders start")
    {after_matching_orders, volume_left} =
      Enum.map_reduce(
        sorted_booking_orders,
        new_order.volume,
        fn order, volume_left ->
          matched_volume_in_decimal = Enum.min([volume_left, order.volume]) |> Decimal.from_float
          cal_vol = order.volume - Enum.min([volume_left, order.volume])
          IO.puts("cal #{order.volume} - #{Enum.min([volume_left, order.volume])} = #{cal_vol}")
          IO.puts("volume_left #{volume_left} - #{Enum.min([volume_left, order.volume])}= #{volume_left - Enum.min([volume_left, order.volume])}\n")
          {%{order |
            volume: order.volume
                    |> Decimal.from_float
                    |> Decimal.sub( matched_volume_in_decimal)
                    |> Decimal.to_float},
           volume_left
           |> Decimal.from_float
           |> Decimal.sub( matched_volume_in_decimal)
           |> Decimal.to_float }
        end
      )

    {%{new_order | volume: volume_left}, after_matching_orders}
  end
end
