defmodule Day01.Part1 do
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&retrieve_number/1)
    |> Enum.sum()
  end

  def retrieve_number(line) do
    Regex.scan(~r/\d/, line)
    |> (&("#{List.first(&1)}#{List.last(&1)}")).()
    |> String.to_integer()
  end
end

defmodule Mix.Tasks.Day01 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day01-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day01.Part1.solve(input))
    # IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day01.Part2.solve(input))
  end
end
