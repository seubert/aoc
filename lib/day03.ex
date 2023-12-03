defmodule Day03.Part1 do
  @moduledoc """
  _extremely_ heavily borrowed from https://github.com/mexicat/aoc-2023/blob/main/lib/aoc/day_03.ex
  I take no credit for this solution but the aforementioned code was really helpful in seeing elixir-y
  ways to do this.
  """
  @neighbors [{1, 0}, {0, 1}, {-1, 0}, {0, -1}, {1, 1}, {-1, 1}, {-1, -1}, {1, -1}]

  def neighbors() do
    @neighbors
  end

  def solve(input) do
    {lines, chars} = parse_input(input)

    Enum.reduce(chars, MapSet.new(), fn {x, y}, acc ->
      Enum.reduce(@neighbors, acc, fn {dx, dy}, acc ->
        neighbor = lines |> Enum.at(y + dy) |> String.at(x + dx)

        case neighbor do
          nil -> acc
          "." -> acc
          _ -> MapSet.put(acc, get_number({x + dx, y + dy}, lines))
        end
      end)
    end)
    |> Enum.map(fn {n, _} -> n end)
    |> Enum.sum()
  end

  def get_number({x, y}, lines) do
    line = Enum.at(lines, y)
    {left, right} = {find_index(x, line, -1), find_index(x, line, 1)}
    full_number = line |> String.slice(left, right - left + 1) |> String.to_integer()
    {full_number, {{left, y}, {right, y}}}
  end

  def find_index(x, line, direction) do
    char = String.at(line, x + direction) || ""

    # If we've gotten an integer, keep looking in that direction, otherwise this is
    # the index we care about
    case Integer.parse(char) do
      :error -> x
      _ -> find_index(x + direction, line, direction)
    end
  end

  def parse_input(input) do
    lines = String.split(input, "\n", trim: true)

    chars =
      lines
      |> Enum.with_index()
      |> Enum.reduce(MapSet.new(), fn {line, i}, acc ->
        Regex.scan(~r/[^0-9.]/, line, return: :index)
        |> List.flatten()
        |> Enum.reduce(acc, fn {start, _}, acc ->
          MapSet.put(acc, {start, i})
        end)
      end)

    {lines, chars}
  end
end

defmodule Day03.Part2 do
  def solve(input) do
    # get all the gears (* symbols)
    {lines, chars} = parse_input(input)

    Enum.reduce(chars, 0, fn {x, y}, acc ->
      # Get the numerical neighbors of each gear
      gearset =
        Enum.reduce(Day03.Part1.neighbors(), MapSet.new(), fn {dx, dy}, acc2 ->
          next_line = y + dy
          next_char = x + dx
          neighbor_line = Enum.at(lines, next_line)
          neighbor_char = String.at(neighbor_line, next_char)

          case neighbor_char do
            nil -> acc2
            "." -> acc2
            _ -> MapSet.put(acc2, Day03.Part1.get_number({next_char, next_line}, lines))
          end
        end)

      # If the set of numbers by the gear is exactly 2, multiply them and add them
      # to the running total
      case MapSet.size(gearset) do
        2 -> acc + (gearset |> Enum.map(fn {n, _} -> n end) |> Enum.product())
        _ -> acc
      end
    end)
  end

  def parse_input(input) do
    lines = String.split(input, "\n", trim: true)

    chars =
      lines
      |> Enum.with_index()
      |> Enum.reduce(MapSet.new(), fn {line, i}, acc ->
        Regex.scan(~r/\*/, line, return: :index)
        |> List.flatten()
        # Make a set of tuples from the results: {start_index, line_number}
        |> Enum.reduce(acc, fn {start, _}, acc ->
          MapSet.put(acc, {start, i})
        end)
      end)

    {lines, chars}
  end
end

defmodule Mix.Tasks.Day03 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day03-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day03.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day03.Part2.solve(input))
  end
end
