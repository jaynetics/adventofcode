defmodule Register do
  @verbose false

  def run_duet() do
    i = input() |> String.trim |> String.split("\n")

    conductor_pid = self()

    {:ok, p0_pid} = Task.start(fn -> run(i, %{"p" => 0}, 1, conductor_pid) end)
    {:ok, p1_pid} = Task.start(fn -> run(i, %{"p" => 1}, 0, conductor_pid) end)

    conduct_duet(%{0 => p0_pid, 1 => p1_pid}, %{0 => 0, 1 => 0})
  end

  defp conduct_duet(pids, send_counts) do
    receive do
      {num, data} ->
        send(pids[num], data)
        conduct_duet(pids, Map.put(send_counts, num, send_counts[num] + 1))
    after
      1000 ->
        IO.puts("processes were sent this num of msgs: #{inspect(send_counts)}")
    end
  end

  @instruction_pattern ~r/(?<operation>\w+) (?<ref1>\w) ?(?<ref2>-?\w*)/

  defp run(ins, map, other_id, co_pid, ptr \\ 0)
  defp run(ins, map, other_id, co_pid, ptr) do
    ci = Regex.named_captures(@instruction_pattern, Enum.at(ins, ptr))
    val = to_value(map, ci["ref1"]) || 0
    new_val = to_value(map, ci["ref2"])
    [new_map, new_ptr] = apply(
      Register,
      String.to_atom(ci["operation"]),
      [map, ci["ref1"], val, new_val, ptr, other_id, co_pid]
    )
    run(ins, new_map, other_id, co_pid, new_ptr + 1)
  end

  def set(map, k, _, nv, ptr, _, _), do: [Map.put(map, k, nv),         ptr]
  def add(map, k, v, nv, ptr, _, _), do: [Map.put(map, k, v + nv),     ptr]
  def mul(map, k, v, nv, ptr, _, _), do: [Map.put(map, k, v * nv),     ptr]
  def mod(map, k, v, nv, ptr, _, _), do: [Map.put(map, k, rem(v, nv)), ptr]
  def jgz(map, _, v, _,  ptr, _, _) when v < 1, do: [map, ptr]
  def jgz(map, _, _, nv, ptr, _, _), do: [map, ptr + nv - 1]

  def snd(map, _, v, nil, ptr, other_id, co_pid) do
    @verbose && IO.puts("sending #{v} from #{inspect(self())} to p#{other_id}")
    send(co_pid, {other_id, v})
    [map, ptr]
  end

  def rcv(map, k, _, nil, ptr, _, _) do
    @verbose && IO.puts("waiting at #{inspect(self())}")
    receive do
      data ->
        @verbose && IO.puts("received #{data} at #{inspect(self())}")
        [Map.put(map, k, data), ptr]
    after
      1000 -> Process.exit(self(), "done")
    end
  end

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

Register.run_duet()
