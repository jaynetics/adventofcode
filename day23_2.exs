defmodule Register do
  def run_input() do
    input()
    |> String.trim
    |> optimize
    |> String.split("\n")
    |> run(%{"a" => 1})
  end

  @doc """
  The input program finds nonprimes between two large values.
  To optimize it, optimize the nonprime finding routine in L09-L24.

  set b 93        # L01 > debug setup. altered in L5-8 if a is nonzero.
  set c b         # L02 ^
  jnz a 2         # L03 > switch between debug and "production" setup.
  jnz 1 5         # L04 ^
  mul b 100       # L05 > "production" setup. sets b to a big number and
  sub b -100000   # L06 ^ c to an even bigger number.
  set c b         # L07 ^ note that c - b == 17 * <integer>, c.f. L31.
  sub c -17000    # L08 ^
    set f 1       # L09 > start main loop. by default, don't do h++ in L26.
    set d 2       # L10
      set e 2     # L11 > start inner loop. try d from 2 upto (b - 1).
        set g d   # L12 > start innermost loop. try e from 2 upto (b - 1).
        mul g e   # L13 ^
        sub g b   # L14 ^
        jnz g 2   # L15 > i.e. increment h in L26 if g == 0 (d * e == b).
        set f 0   # L16 ^ --- in other words: if current b is nonprime.
        sub e -1  # L17 > IF g == 0 (i.e. e == b) break ...
        set g e   # L18 ^
        sub g b   # L19 ^
        jnz g -8  # L20 ^ ELSE retry with e++. end of innermost loop.
      sub d -1    # L21 > IF g == 0 (i.e. d == b) break ...
      set g d     # L22 ^
      sub g b     # L23 ^
      jnz g -13   # L24 ^ ELSE retry with d++, and e >= 2. end of inner loop.
    jnz f 2       # L25 > h is incremented if g was zero (b == d) in L15
    sub h -1      # L26 ^
    set g b       # L27 > IF b has reached c, break out of main loop and
    sub g c       # L28 ^ quit the program ...
    jnz g 2       # L29 ^
    jnz 1 3       # L30 ^
    sub b -17     # L31 > ELSE (if b != c), add 17 to b and repeat
    jnz 1 -23     # L32 ^ the main loop from L9 on. end of main loop.
  """
  def optimize(input) do
    Regex.replace(~r/set f 1.*jnz g -13/is, input, "isp f b")
    |> String.replace("jnz 1 -23", "jnz 1 -8")
  end

  @instruction_pattern ~r/(?<op>\w+) (?<ref1>\w) ?(?<ref2>-?\w*)/

  defp run(instructions, map, ptr \\ 0)
  defp run(instructions, map, ptr) when ptr >= length(instructions), do: map
  defp run(instructions, map, ptr) do
    %{"op" => op, "ref1" => ref1, "ref2" => ref2} =
      Regex.named_captures(@instruction_pattern, Enum.at(instructions, ptr))

    { val1, val2 } = { to_value(map, ref1), to_value(map, ref2) }

    { new_map, new_ptr } = case({op, val1}) do
      { "set", _ } -> { Map.put(map, ref1, val2), ptr }
      { "sub", _ } -> { Map.put(map, ref1, val1 - val2), ptr }
      { "mul", _ } -> { Map.put(map, ref1, val1 * val2), ptr }
      { "jnz", 0 } -> { map, ptr }
      { "jnz", _ } -> { map, ptr + val2 - 1 }
      { "isp", _ } ->
        { Map.put(map, ref1, (if prime?(val2), do: 1, else: 0)), ptr }
    end

    run(instructions, new_map, new_ptr + 1)
  end

  defp to_value(_map, ""), do: nil
  defp to_value(map,  reference) do
    if String.match?(reference, ~r/\d/) do
      String.to_integer(reference)
    else
      Map.get(map, reference, 0)
    end
  end

  defp prime?(num) do
    max_div = num |> :math.sqrt |> Float.ceil |> trunc
    !Enum.any?(2..max_div, fn divisor -> rem(num, divisor) == 0 end)
  end

  defp input do
    """
    ... paste input here ...
    """
  end
end

IO.inspect Register.run_input()
