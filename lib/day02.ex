defmodule Day02.Part1 do
  @maxes %{green: 13, red: 12, blue: 14}
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&calculate_color_totals/1)
    |> Enum.sum()
  end

  def calculate_color_totals(line) do
    splits = String.split(line, ":", trim: true)
    draws = String.split(List.last(splits), ";")
    greens = length(calculate_color(draws, "green")) > 0
    blues = length(calculate_color(draws, "blue")) > 0
    reds = length(calculate_color(draws, "red")) > 0
    if !greens and !blues and !reds do
      id = String.to_integer(List.last(String.split(List.first(splits), " ")))
      IO.puts("Adding ID #{id} with green #{greens} blue #{blues} red #{reds}")
      id
    else
      0
    end
  end

  def calculate_color(draws, color_name) do
    color_reg = Regex.compile!("\\s*(\\d*) #{color_name}")
    draws
    |> Enum.map(fn n -> Regex.scan(color_reg, n) |> List.flatten() |> List.last() end)
    |> Enum.reject(&is_nil/1)
    |> Enum.filter(fn n -> String.to_integer(n) > @maxes[String.to_atom(color_name)] end)
  end
end

defmodule Day02.Part2 do
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&calculate_powers/1)
    |> Enum.sum()
  end

  def calculate_powers(line) do
    splits = String.split(line, ":", trim: true)
    green_max = calculate_color_max(List.last(splits), "green")
    red_max = calculate_color_max(List.last(splits), "red")
    blue_max = calculate_color_max(List.last(splits), "blue")
    green_max * red_max * blue_max
  end

  def calculate_color_max(draws, color_name) do
    color_reg = Regex.compile!("\\s*(\\d*) #{color_name}")
    Regex.scan(color_reg, draws)
    |> Enum.map(fn n -> List.last(n) |> String.to_integer() end)
    |> Enum.max()
  end
end

defmodule Mix.Tasks.Day02 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day02-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day02.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day02.Part2.solve(input))
  end
end
