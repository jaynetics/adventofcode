defmodule Puzzle do
  @input_file Regex.replace(~r/day..\K.*/, __ENV__.file, "_input")

  def part1() do
    items()
    |> Enum.chunk_every(2)
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {[l, r], idx}, acc ->
      if compare(l, r) == 1, do: acc + idx, else: acc
    end)
  end

  def part2() do
    items()
    |> Enum.concat([[[2]], [[6]]])
    |> Enum.sort(&(compare(&2, &1) < 1))
    |> Enum.with_index(1)
    |> Enum.reduce(1, fn {el, idx}, acc ->
      if el == [[2]] || el == [[6]], do: acc * idx, else: acc
    end)
  end

  defp items() do
    {:ok, data} = File.read(@input_file)
    String.split(data, ~r/\n+/) |> Enum.map(&(Code.eval_string(&1) |> elem(0)))
  end

  defp compare(l, r) when is_list(l) and is_list(r) do
    Enum.with_index(l)
    |> Enum.find_value(fn {le, idx} ->
      cmp_val = compare(le, Enum.at(r, idx))
      if cmp_val != 0, do: cmp_val
    end) || 1
  end

  defp compare(_, r) when is_nil(r), do: -1
  defp compare(l, r) when is_list(l) and not is_list(r), do: compare(l, [r])
  defp compare(l, r) when is_list(r) and not is_list(l), do: compare([l], r)
  defp compare(l, r) when is_integer(l) and l > r, do: -1
  defp compare(l, r) when is_integer(l) and l < r, do: 1
  defp compare(l, r) when is_integer(l) and l == r, do: 0
end

Puzzle.part1() |> IO.puts()
Puzzle.part2() |> IO.puts()
