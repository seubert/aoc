defmodule Day04.Part1 do
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(0, fn {_, winning_numbers, my_numbers}, acc ->
      my_winners = MapSet.intersection(winning_numbers, my_numbers) |> MapSet.size()

      case my_winners do
        0 -> acc
        1 -> acc + 1
        _ -> acc + Integer.pow(2, my_winners - 1)
      end
    end)
  end

  def parse_line(line) do
    parts = String.split(line, ":")
    card_number = Regex.run(~r/\d+/, List.first(parts)) |> List.flatten() |> List.first() |> String.to_integer()
    number_parts = String.split(List.last(parts), ~r/\|/) |> List.flatten()
    winning_numbers = Regex.scan(~r/\d+/, List.first(number_parts)) |> MapSet.new()
    my_numbers = Regex.scan(~r/\d+/, List.last(number_parts)) |> MapSet.new()
    {card_number, winning_numbers, my_numbers}
  end
end

defmodule Day04.Card do
  defstruct [wins: 0, copies: 1]
end

defmodule Day04.Part2 do
  require IEx
  def solve(input) do
    card_wins = input
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_line/1)

    calculated_wins = Enum.reduce(card_wins, Map.new(card_wins), fn {card_number, card}, acc ->
      case card.wins do
        0 -> acc
        _ -> add_wins(acc, card_number, card.wins)
      end
    end)

    Enum.reduce(calculated_wins, 0, fn {card_number, card}, acc ->
      acc + card.copies
    end)
  end

  def add_wins(cards, card_number, wins) do
    Enum.reduce(card_number + 1 .. card_number + wins, cards, fn card_number_to_change, acc ->
      calculating_card = Map.get(cards, card_number)
      card_to_change = Map.get(cards, card_number_to_change)
      case card_to_change do
        nil -> acc
        _ -> Map.put(acc, card_number_to_change, %{card_to_change | copies: card_to_change.copies + calculating_card.copies})
      end
    end)
  end

  def parse_line(line) do
    parts = String.split(line, ":")
    card_number = Regex.run(~r/\d+/, List.first(parts)) |> List.flatten() |> List.first() |> String.to_integer()
    number_parts = String.split(List.last(parts), ~r/\|/) |> List.flatten()
    winning_numbers = Regex.scan(~r/\d+/, List.first(number_parts)) |> MapSet.new()
    my_numbers = Regex.scan(~r/\d+/, List.last(number_parts)) |> MapSet.new()
    wins = MapSet.intersection(winning_numbers, my_numbers) |> MapSet.size()
    {card_number, %Day04.Card{wins: wins}}
  end
end

defmodule Mix.Tasks.Day04 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day04-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day04.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day04.Part2.solve(input))
  end
end
