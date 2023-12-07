defmodule Puzzle do
  @input_file Regex.replace(~r/day..\K.*/, __ENV__.file, "_input")

  def part1() do
    parse_input1()
    |> Enum.map(&count_better_timings/1)
    |> Enum.reduce(&*/2)
  end

  def part2() do
    parse_input2()
    |> count_better_timings()
  end

  defp parse_input1() do
    {:ok, data} = File.read(@input_file)

    numbers =
      Regex.scan(~r/\d+/, data)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

    Enum.split(numbers, round(length(numbers) / 2))
    |> Tuple.to_list()
    |> Enum.zip()
    |> Enum.into(%{})
  end

  defp parse_input2() do
    {:ok, data} = File.read(@input_file)

    String.split(data, "\n", parts: 2)
    |> Enum.map(&Regex.replace(~r/\D/, &1, ""))
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  defp count_better_timings({time, distance}) do
    check = fn new_time -> new_time * (time - new_time) > distance end

    opts = 1..(time - 1)
    first_win = Enum.at(opts, bisect_idx(opts, check))

    opts = (time - 1)..first_win
    last_win = Enum.at(opts, bisect_idx(opts, check))

    last_win - first_win + 1
  end

  defp bisect_idx(enum, check) do
    do_bisect_idx(enum, check, 0, Enum.count(enum) - 1)
  end

  defp do_bisect_idx(enum, check, min, max) when min < max do
    mid = floor((min + max) / 2)
    value = Enum.at(enum, mid)
    {new_min, new_max} = if check.(value), do: {min, mid}, else: {mid + 1, max}
    do_bisect_idx(enum, check, new_min, new_max)
  end

  defp do_bisect_idx(enum, check, min, max) when min == max do
    if check.(Enum.at(enum, min)), do: min, else: nil
  end
end

Puzzle.part1() |> IO.inspect()
Puzzle.part2() |> IO.inspect()
