defmodule OrderMatchingEngineTest do
  use ExUnit.Case
  doctest OrderMatchingEngine

  test "Should build order book correctly by 1 buy 1 sell not matching_orders request" do
    assert OrderMatchingEngine.build_order_book_from_order_request_file('fixtures/input_ex1.json') ==
             %OrderMatchingEngine.OrderBookModel{
               buy: [%OrderMatchingEngine.OrderInfo{price: 90.394, volume: 3.445}],
               sell: [%OrderMatchingEngine.OrderInfo{price: 100.003, volume: 2.4}]}
  end

  test "Should build order book correctly by multiple buy multiple sell not matching_orders request" do
    assert OrderMatchingEngine.build_order_book_from_order_request_file('fixtures/input_ex2.json') ==
             %OrderMatchingEngine.OrderBookModel{
               buy: [%OrderMatchingEngine.OrderInfo{price: 90.394, volume: 4.445},
                 %OrderMatchingEngine.OrderInfo{price: 90.15, volume: 1.305},
                 %OrderMatchingEngine.OrderInfo{price: 89.394, volume: 4.3}],
               sell: [%OrderMatchingEngine.OrderInfo{price: 100.003, volume: 2.4},
                 %OrderMatchingEngine.OrderInfo{price: 100.013, volume: 2.2}]
             }
  end

  test "Should build order book correctly by multiple buy multiple sell simple matching_orders request" do
    assert OrderMatchingEngine.build_order_book_from_order_request_file('fixtures/input_ex3.json') ==
             %OrderMatchingEngine.OrderBookModel{
               buy: [%OrderMatchingEngine.OrderInfo{price: 90.394, volume: 2.245},
                 %OrderMatchingEngine.OrderInfo{price: 90.15, volume: 1.305},
                 %OrderMatchingEngine.OrderInfo{price: 89.394, volume: 4.3}],
               sell: [%OrderMatchingEngine.OrderInfo{price: 100.003, volume: 2.4},
                 %OrderMatchingEngine.OrderInfo{price: 100.013, volume: 2.2}]
             }
  end

  test "Should build order book correctly by multiple buy multiple sell partially matching_orders request" do
    assert OrderMatchingEngine.build_order_book_from_order_request_file('fixtures/input_ex4.json') ==
             %OrderMatchingEngine.OrderBookModel{
               buy: [%OrderMatchingEngine.OrderInfo{price: 100.01, volume: 1.6},
                 %OrderMatchingEngine.OrderInfo{price: 91.33, volume: 1.8},
                 %OrderMatchingEngine.OrderInfo{price: 90.15, volume: 0.15},
                 %OrderMatchingEngine.OrderInfo{price: 89.394, volume: 4.3}],
               sell: [%OrderMatchingEngine.OrderInfo{price: 100.013, volume: 2.2},
                 %OrderMatchingEngine.OrderInfo{price: 100.15, volume: 3.8}]
             }


  end

end
