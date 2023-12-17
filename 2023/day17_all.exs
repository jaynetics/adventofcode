Mix.install([:heap])

defmodule Puzzle do
  @input_file Regex.replace(~r/day..\K.*/, __ENV__.file, "_input")

  def part1(), do: parse_input() |> run({1, 3})

  def part2(), do: parse_input() |> run({4, 10})

  def parse_input() do
    File.stream!(@input_file)
    |> Enum.map(&(Regex.scan(~r/\d/, &1) |> Enum.map(fn [d] -> String.to_integer(d) end)))
  end

  def run(grid, min_max_steps) do
    dest = {length(hd(grid)) - 1, length(grid) - 1}

    queue =
      [{0, 1}, {1, 0}]
      |> Enum.map(fn pos = {x, y} -> {cost(grid, pos), pos, {x, y, 1}} end)
      |> Enum.into(Heap.min())

    run(grid, min_max_steps, dest, queue, %MapSet{})
  end

  def run(grid, min_max_steps = {min_steps, _max_steps}, dest, queue, seen) do
    {{total_cost, pos, mov = {_dx, _dy, step}}, queue} = Heap.split(queue)
    seen_key = {pos, mov}

    cond do
      pos == dest and step >= min_steps ->
        total_cost

      seen_key in seen ->
        run(grid, min_max_steps, dest, queue, seen)

      true ->
        new_queue =
          directions(step, min_max_steps, pos, mov)
          |> Enum.map(fn {pos, mov} -> {cost(grid, pos), pos, mov} end)
          |> Enum.filter(fn {cost, _, _} -> cost end)
          |> Enum.map(fn {cost, pos, mov} -> {total_cost + cost, pos, mov} end)
          |> Enum.reduce(queue, fn option, queue -> Heap.push(queue, option) end)

        new_seen = MapSet.put(seen, seen_key)
        run(grid, min_max_steps, dest, new_queue, new_seen)
    end
  end

  def cost(_grid, {x, y}) when y < 0 or x < 0, do: nil
  def cost(grid, {x, y}), do: Enum.at(grid, y) |> then(&(&1 && Enum.at(&1, x)))

  def directions(step, {min_steps, max_steps}, {x, y}, {dx, dy, step}) do
    turn_dirs = [{{x + dy, y + dx}, {dy, dx, 1}}, {{x - dy, y - dx}, {-dy, -dx, 1}}]
    dirs = if step >= min_steps, do: turn_dirs, else: []
    if step < max_steps, do: [{{x + dx, y + dy}, {dx, dy, step + 1}} | dirs], else: dirs
  end
end

Puzzle.part1() |> IO.inspect(label: "part 1")
Puzzle.part2() |> IO.inspect(label: "part 2")
