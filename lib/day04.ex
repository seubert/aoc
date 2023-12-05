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

defmodule Day04.Part2 do
  def solve(input) do
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
