defmodule Register do
  def run_instructions() do
    do_run_instructions(input() |> String.trim |> String.split("\n"), %{})
  end

  @instruction_pattern ~r/(?<operation>\w+) (?<key>\w) ?(?<ref>-?\w*)/

  defp do_run_instructions(ins, map, ptr \\ 0, snd \\ 0)
  defp do_run_instructions(ins, map, ptr, _sn) when ptr >= length(ins), do: map
  defp do_run_instructions(ins, map, ptr, snd) do
    ci = Regex.named_captures(@instruction_pattern, Enum.at(ins, ptr))
    [new_map, new_ptr, new_snd] = apply(
      Register,
      String.to_atom(ci["operation"]),
      [map, ci["key"], map[ci["key"]] || 0, to_value(map, ci["ref"]), ptr, snd]
    )
    do_run_instructions(ins, new_map, new_ptr + 1, new_snd)
  end

  def set(map, k, _, nv,  ptr, snd), do: [Map.put(map, k, nv),         ptr, snd]
  def add(map, k, v, nv,  ptr, snd), do: [Map.put(map, k, v + nv),     ptr, snd]
  def mul(map, k, v, nv,  ptr, snd), do: [Map.put(map, k, v * nv),     ptr, snd]
  def mod(map, k, v, nv,  ptr, snd), do: [Map.put(map, k, rem(v, nv)), ptr, snd]
  def snd(map, k, _, nil, ptr, _  ), do: [map, ptr, map[k]]
  def rcv(map, _, 0, nil, ptr, snd), do: [map, ptr, snd]
  def rcv(_,   _, _, nil, _,   snd), do: [IO.inspect(snd), System.halt(0)]
  def jgz(map, _, v, _,   ptr, snd) when v < 1, do: [map, ptr, snd]
  def jgz(map, _, _, nv,  ptr, snd), do: [map, ptr + nv - 1, snd]

  defp to_value(_map, ""), do: nil
  defp to_value(map,  ref) do
    if String.match?(ref, ~r/\d/) do
      String.to_integer(ref)
    else
      map[ref] || 0
    end
  end

  defp input do
    """
    ... paste input here ...
    """
  end
end

Register.run_instructions()
