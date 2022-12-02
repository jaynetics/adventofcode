defmodule Program do
  defstruct name: nil, weight: 0, child_names: [], children: [], full_weight: 0

  ####################
  # part 2 additions #
  ####################

  def find_weight_correction do
    tree()
    |> set_full_weights
    |> do_find_weight_correction([])
  end

  defp set_full_weights(node) do
    node
    |> Map.merge(%{
      children:    node.children |> Enum.map(&set_full_weights/1),
      full_weight: calc_full_weight(node)
    })
  end

  defp calc_full_weight(%{weight: weight, children: children})
       when is_integer(weight) do
    weight + Enum.reduce(
      children, 0, fn(child, acc) -> acc + calc_full_weight(child) end
    )
  end

  defp do_find_weight_correction(node, siblings) do
    if node |> is_black_sheep_among(siblings) do
      node |> puts_weight_correction(siblings)
    end
      node.children
      |> Enum.each(fn(child) ->
           child_siblings = node.children |> List.delete(child)
           do_find_weight_correction(child, child_siblings)
         end)
    # end
  end

  defp is_black_sheep_among(_node, []), do: false
  defp is_black_sheep_among(%{full_weight: full_weight}, siblings) do
    siblings |> Enum.all?(fn(other) -> other.full_weight != full_weight end)
  end

  defp puts_weight_correction(node, [sibling | _others]) do
    new_weight = node.weight + (sibling.full_weight - node.full_weight)
    IO.puts "#{node.name} needs #{new_weight} instead of #{node.weight}"
  end

  ###########################
  # end of part 2 additions #
  ###########################

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
      weight:      captures["weight"] |> String.to_integer,
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

Program.find_weight_correction()
