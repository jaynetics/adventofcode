defmodule Program do
  defstruct name: nil, weight: 0, child_names: [], children: []

  def tree do
    nodes = parse_nodes()
    nodes
    |> Enum.map(fn(node) -> node |> assign_children_out_of(nodes) end)
    |> Enum.find(fn(node) -> node |> is_root_of(nodes) end)
  end

  defp parse_nodes do
    input()
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&parse_node/1)
  end

  defp parse_node(string) do
    regex = ~r/(?<name>\w+) \((?<weight>\d+)\)(?: -> (?<child_names>.+))?/
    captures = Regex.named_captures(regex, string)
    %Program{
      name:        captures["name"],
      weight:      captures["weight"],
      child_names: captures["child_names"] |> parse_child_names
    }
  end

  defp parse_child_names(""),     do: []
  defp parse_child_names(string), do: string |> String.split(", ")

  defp assign_children_out_of(node, nodes) do
    recursive_children =
      nodes
      |> nodes_by_names(node.child_names)
      |> Enum.map(fn(node) -> node |> assign_children_out_of(nodes) end)

    Map.put(node, :children, recursive_children)
  end

  defp nodes_by_names(_nodes, []), do: []
  defp nodes_by_names(nodes, names) do
    nodes |> Enum.filter(fn(%{name: name}) -> names |> Enum.member?(name) end)
  end

  defp is_root_of(%{name: name}, nodes) do
    !Enum.any?(nodes, fn(other) -> other.child_names |> Enum.member?(name) end)
  end

  defp input do
    """
      ... paste input here...
    """
  end
end

root = Program.tree()
IO.inspect root.name
