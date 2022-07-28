# OrderMatchingEngine
![](https://media.giphy.com/media/FZdvKM9owasj6/giphy.gif "Stock Market")

Matching engine is the engine support set of limit order commands from `input.json` The commands will be triggered in order from first (top) to last(bottom) of the list.

Input Examples:
```json
{
  "orders": [
    {"command": "sell", "price": 100.003, "amount": 2.4},
    {"command": "buy", "price": 90.394, "amount": 3.445}
  ]
}
```
Output of the matching engine is Order Book in `output.json`. The output has 2 attributes which are buy, sell attributes.

Buy section has Buy price, Buy volume.
- Buy prices are ordered from high to low
- Buy volume is accomulated of buy amount which lies in the same price.

Sell section: Sell section has Sell price, Sell volume
- Sell prices are ordered from low to high
- Sell volume is accomulated of sell amount which lies in the same price.

Output Examples:
```json
{
  "sell": [
    {
      "volume": 2.4,
      "price": 100.003
    }
  ],
  "buy": [
    {
      "volume": 3.445,
      "price": 90.394
    }
  ]
}
```
---

## Prerequisite
- Elixir, you can look for installation of Elixir in this [website](https://elixir-lang.org/install.html).
<br>
## Setup
```shell
mix deps.get
```
---
## Testing
```shell
mix test test/*
```
---
## Command

### To take input file(`input.json`) and build the book orders output file (`output.json`).
```shell
# build output.json file from input.json file
mix run -e "OrderMatchingEngine.build_order_book_from_order_request_file('input.json') |> OrderBookRepository.save"
```
---
## Module Docs
You can generate docs via this command:

```shell
mix docs
```
---
**TODO: task list**

- ✅ Read Json File
- ✅ Build Model
- ✅ Parse Json to Model
- ✅ Build Buy Sell Section
- ✅ Write Section to Json File
- ✅ Matching Engine (Time Priority)
- ✅ Order Book (list of orders, A matching engine uses the book to determine which orders can be fulfilled i.e. what trades can be made.)
- ✅ Refactor Code
- ✅ Finishing Docs
- ✅ Read me
