defmodule Day2 do
  def getFileLines do
    File.read!("input.txt") |> String.split("\n")
  end

  def checkDiffAllowd(diff) do
    if diff < 0 do
      diff * -1 <= 3
    else
      diff <= 3
    end
  end

  def comparePairs([a, b | rest], direction) do
    if (a > b or a < b) and checkDiffAllowd(a - b) do
      dire =
        if a > b do
          "b"
        else
          "f"
        end

      if direction != dire and direction != "start" do
        0
      else
        comparePairs([b | rest], dire)
      end
    else
      0
    end
  end

  def comparePairs(_, _) do
    1
  end

  def pt1() do
    lines = getFileLines()

    totalsafe =
      Enum.map(lines, fn row ->
        String.split(row, " ", trim: true) |> Enum.map(fn char -> String.to_integer(char) end)
      end)
      |> Enum.filter(fn row -> length(row) > 0 end)
      |> Enum.map(fn rowPairs ->
        comparePairs(rowPairs, "start")
      end)
      |> Enum.reduce(fn curr_row, agg ->
        agg + curr_row
      end)

    IO.puts("result #{totalsafe}")
  end

  def pt2() do
  end
end

Day2.pt1()
Day2.pt2()
