defmodule Benchmark do
  def measure(function) do
    function |> :timer.tc() |> elem(0) |> Kernel./(1_000_000) |> IO.puts()
  end
end

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

  def filterVariant([_first | rest], acc, full, idx) do
    withoutElem = List.delete_at(full, idx)

    if comparePairs(withoutElem, "start") == 1 do
      filterVariant([], withoutElem, full, idx + 1)
    else
      filterVariant(rest, acc, full, idx + 1)
    end
  end

  def filterVariant(_, acc, full, _) do
    if length(acc) == 0 do
      full
    else
      Enum.reverse(acc)
    end
  end

  def iterateVariants(rowPairs) do
    lenUniqRowPairs = length(Enum.uniq(rowPairs))
    lenRowPairs = length(rowPairs)

    validVariants =
      Enum.map(rowPairs, fn pair ->
        cond do
          ## allow one dupe
          lenRowPairs == lenUniqRowPairs + 1 ->
            filterVariant(rowPairs, [], rowPairs, 0)

          lenUniqRowPairs == lenRowPairs ->
            Enum.filter(rowPairs, fn rowPair -> rowPair != pair end)

          lenUniqRowPairs != lenRowPairs ->
            rowPairs
        end
      end)
      |> Enum.filter(fn variant ->
        comparePairs(variant, "start") == 1
      end)

    if length(validVariants) >= 1 do
      1
    else
      0
    end
  end

  def pt2() do
    lines = getFileLines()

    totalsafe =
      Enum.map(lines, fn row ->
        String.split(row, " ", trim: true) |> Enum.map(fn char -> String.to_integer(char) end)
      end)
      |> Enum.filter(fn row -> length(row) > 0 end)
      |> Enum.map(fn rowPairs ->
        valid = comparePairs(rowPairs, "start")

        if valid != 1 do
          iterateVariants(rowPairs)
        else
          valid
        end
      end)
      |> Enum.reduce(fn curr_row, agg ->
        agg + curr_row
      end)

    IO.puts("result #{totalsafe}")
  end
end

Benchmark.measure(fn -> Day2.pt1() end)
Benchmark.measure(fn -> Day2.pt2() end)
