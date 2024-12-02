defmodule Day1 do
  ## pair smallest in left column with smallest on right column
  ## then calculate distances between pairs
  ## no negative distances, always substract bigger from smaller (or multiply by -1 to turn positive in the end)
  ## add all distances

  def calc_diff(first, second) do
    diff = first - second

    if diff < 0 do
      diff * -1
    else
      diff
    end
  end

  def get_side(pairs, idx) do
    Enum.map(pairs, fn pair -> String.to_integer(Enum.at(pair, idx)) end) |> Enum.sort()
  end

  def pt1() do
    total =
      getGroupsFromFile()
      |> Enum.zip()
      |> Enum.map(fn {first, second} -> calc_diff(first, second) end)
      |> Enum.reduce(fn elem, acc -> elem + acc end)

    IO.puts(total)
  end

  def getGroupsFromFile() do
    pairs =
      File.read!("input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn line -> String.split(line, " ", trim: true) end)

    [get_side(pairs, 0), get_side(pairs, 1)]
  end

  def aggregateCounts(right_side) do
    Enum.frequencies(right_side)
  end

  def pt2 do
    pairs = getGroupsFromFile()
    agg_right_finds = aggregateCounts(Enum.at(pairs, 1))

    total =
      Enum.at(pairs, 0)
      |> Enum.map(fn row ->
        in_map_res = agg_right_finds[row]

        if in_map_res do
          in_map_res * row
        else
          row * 0
        end
      end)
      |> Enum.reduce(fn elem, acc -> elem + acc end)

    IO.puts(total)
  end
end

Day1.pt1()
Day1.pt2()
