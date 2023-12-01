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

defmodule Day01.Part2 do
  @string_number_map %{one: 1, two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9}
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&retrieve_number/1)
    |> Enum.sum()
  end

  def retrieve_number(line) do
    Regex.scan(~r/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/, line)
    |> Enum.map(fn (x) -> List.last(x) end)
    |> (&("#{translate_number_string(List.first(&1))}#{translate_number_string(List.last(&1))}")).()
    |> String.to_integer
  end

  def translate_number_string(number_string) do
    if Regex.match?(~r/^\d+$/, number_string) do
      number_string
    else
      @string_number_map[String.to_atom(number_string)]
    end
  end
end

defmodule Mix.Tasks.Day01 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day01-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day01.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day01.Part2.solve(input))
  end
end
