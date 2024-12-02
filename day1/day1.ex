defmodule Day1 do
  def calcDiff(first, second) do
    diff = first - second

    if diff < 0 do
      diff * -1
    else
      diff
    end
  end

  def getSide(pairs, idx) do
    Enum.map(pairs, fn pair -> String.to_integer(Enum.at(pair, idx)) end) |> Enum.sort()
  end

  def pt1() do
    total =
      getGroupsFromFile()
      |> Enum.zip()
      |> Enum.map(fn {first, second} -> calcDiff(first, second) end)
      |> Enum.reduce(fn elem, acc -> elem + acc end)

    IO.puts(total)
  end

  def getGroupsFromFile() do
    pairs =
      File.read!("input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn line -> String.split(line, " ", trim: true) end)

    [getSide(pairs, 0), getSide(pairs, 1)]
  end

  def aggregateCounts(rightSide) do
    Enum.frequencies(rightSide)
  end

  def pt2 do
    pairs = getGroupsFromFile()
    aggRightFinds = aggregateCounts(Enum.at(pairs, 1))

    total =
      Enum.at(pairs, 0)
      |> Enum.map(fn row ->
        inMapRes = aggRightFinds[row]

        if inMapRes do
          inMapRes * row
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
