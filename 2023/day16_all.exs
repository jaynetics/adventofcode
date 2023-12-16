defmodule Puzzle do
  @input_file Regex.replace(~r/day..\K.*/, __ENV__.file, "_input")

  # Start from "outside" the grid (hence -1). Use agent to sync between beams.
  def part1() do
    parse_input() |> trace(-1, 0) |> count_uniq_xy() |> then(&(&1 - 1))
  end

  # Sadly Agents have a lot of overhead, so this takes 5 minutes :/
  # I wonder if there is a good search pruning approach without queue in Elixir?
  def part2() do
    grid = parse_input()
    [w, h] = dimensions(grid)

    start_points =
      for(x <- 0..(w - 1), y <- [-1, h], do: {x, y}) ++
        for(x <- [-1, w], y <- 0..(h - 1), do: {x, y})

    start_points
    |> Enum.map(fn {x, y} -> (trace(grid, x, y) |> count_uniq_xy()) - 1 end)
    |> Enum.max()
  end

  def parse_input() do
    File.stream!(@input_file)
    |> Enum.map(&(String.trim(&1) |> String.graphemes()))
  end

  def dimensions(grid), do: [Enum.count(Enum.at(grid, 0)), Enum.count(grid)]

  # choose direction based on starting point
  def trace(grid, x, y) do
    {:ok, agent} = Agent.start_link(fn -> %{} end)
    [w, h] = dimensions(grid)

    cond do
      x == -1 -> trace(grid, x, y, 1, 0, %{}, agent)
      y == -1 -> trace(grid, x, y, 0, 1, %{}, agent)
      x == w -> trace(grid, x, y, -1, 0, %{}, agent)
      y == h -> trace(grid, x, y, 0, -1, %{}, agent)
    end
  end

  def trace(_grid, x, y, vx, vy, seen, _) when is_map_key(seen, {x, y, vx, vy}), do: seen

  def trace(grid, x, y, vx, vy, _seen, agent) when is_integer(vx) and is_integer(vy) do
    seen =
      Agent.get_and_update(agent, fn m -> Map.put(m, {x, y, vx, vy}, true) |> then(&{&1, &1}) end)

    [nx, ny] = [x + vx, y + vy]
    next_row = grid |> Enum.at(ny)
    next_el = if nx >= 0 && ny >= 0 && next_row, do: next_row |> Enum.at(nx), else: nil

    case {next_el, vx, vy} do
      {".", _, _} -> trace(grid, nx, ny, vx, vy, seen, agent)
      {"-", _, 0} -> trace(grid, nx, ny, vx, vy, seen, agent)
      {"-", 0, _} -> trace(grid, nx, ny, [-1, 1], [0], seen, agent)
      {"|", _, 0} -> trace(grid, nx, ny, [0], [-1, 1], seen, agent)
      {"|", 0, _} -> trace(grid, nx, ny, vx, vy, seen, agent)
      {"/", _, _} -> trace(grid, nx, ny, vy * -1, vx * -1, seen, agent)
      {"\\", _, _} -> trace(grid, nx, ny, vy, vx, seen, agent)
      {nil, _, _} -> seen
    end
  end

  def trace(grid, x, y, vx, vy, seen, agent) when is_list(vx) and is_list(vy) do
    for(vx_el <- vx, vy_el <- vy, do: trace(grid, x, y, vx_el, vy_el, seen, agent))
    |> Enum.reduce(&Map.merge/2)
  end

  def count_uniq_xy(seen) do
    Enum.map(seen, fn {{x, y, _, _}, _} -> {x, y} end) |> Enum.uniq() |> Enum.count()
  end
end

Puzzle.part1() |> IO.inspect(label: "part 1")
Puzzle.part2() |> IO.inspect(label: "part 2")
