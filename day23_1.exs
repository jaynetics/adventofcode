defmodule Register do
  def run_input() do
    input() |> String.trim |> String.split("\n") |> run()
  end

  @instruction_pattern ~r/(?<op>\w+) (?<ref1>\w) ?(?<ref2>-?\w*)/

  defp run(instructions, map \\ %{}, ptr \\ 0, ops \\ %{})
  defp run(instructions, _, ptr, ops) when ptr >= length(instructions), do: ops
  defp run(instructions, map, ptr, ops) do
    %{"op" => op, "ref1" => ref1, "ref2" => ref2} =
      Regex.named_captures(@instruction_pattern, Enum.at(instructions, ptr))

    { val, new_val } = { to_value(map, ref1), to_value(map, ref2) }

    { new_map, new_ptr } = case({op, val}) do
      { "set", _ } -> { Map.put(map, ref1, new_val), ptr }
      { "sub", _ } -> { Map.put(map, ref1, val - new_val), ptr }
      { "mul", _ } -> { Map.put(map, ref1, val * new_val), ptr }
      { "jnz", 0 } -> { map, ptr }
      { "jnz", _ } -> { map, ptr + new_val - 1 }
    end

    new_ops = Map.put(ops, op, Map.get(ops, op, 0) + 1)

    run(instructions, new_map, new_ptr + 1, new_ops)
  end

  defp to_value(_map, ""), do: nil
  defp to_value(map,  reference) do
    if String.match?(reference, ~r/\d/) do
      String.to_integer(reference)
    else
      Map.get(map, reference, 0)
    end
  end

  defp input do
    """
    ... paste input here ...
    """
  end
end

IO.inspect Register.run_input()
