defmodule Benchmark do
  def measure(function) do
    function |> :timer.tc() |> elem(0) |> Kernel./(1_000_000) |> IO.puts()
  end
end

defmodule StinkyParser do
  def getTokenTypeAndArgsFromToken(token) do
    splitAtName = String.split(token, "(")
    name = Enum.at(splitAtName, 0)

    ints =
      String.split(Enum.at(splitAtName, 1), ",")
      |> Enum.map(fn char ->
        {integer, _str} = Integer.parse(char)
        integer
      end)

    [name, ints]
  end

  ## tokens to match mul(int, int)
  def parseRow(row) do
    ## row, curr token, gathered instructions
    parseRow(row, "", [])
  end

  def parseRow(<<"m", rest::binary>>, currToken, tokens) do
    if String.equivalent?(currToken, "") do
      parseRow(rest, "m", tokens)
    else
      parseRow(rest, "", tokens)
    end
  end

  def parseRow(<<"u", rest::binary>>, currToken, tokens) do
    if String.equivalent?(currToken, "m") do
      parseRow(rest, "#{currToken}u", tokens)
    else
      parseRow(rest, "", tokens)
    end
  end

  def parseRow(<<"l", rest::binary>>, currToken, tokens) do
    if String.equivalent?(currToken, "mu") do
      parseRow(rest, "#{currToken}l", tokens)
    else
      parseRow(rest, "", tokens)
    end
  end

  def parseRow(<<"(", rest::binary>>, currToken, tokens) do
    if String.equivalent?(currToken, "mul") do
      parseRow(rest, "#{currToken}(", tokens)
    else
      parseRow(rest, "", tokens)
    end
  end

  def parseRow(<<")", rest::binary>>, currToken, tokens) do
    if String.contains?(currToken, "mul(") and String.contains?(currToken, ",") do
      parseRow(rest, "", [getTokenTypeAndArgsFromToken(currToken) | tokens])
    else
      parseRow(rest, "", tokens)
    end
  end

  def parseRow(<<",", rest::binary>>, currToken, tokens) do
    if String.contains?(currToken, "mul(") and String.length(currToken) > String.length("mul(") do
      parseRow(rest, "#{currToken},", tokens)
    else
      parseRow(rest, "", tokens)
    end
  end

  def parseRow(<<d, rest::binary>>, currToken, tokens) when d in ?0..?9 do
    if String.contains?(currToken, "mul(") and not String.contains?(currToken, ")") do
      parseRow(rest, "#{currToken}#{d - ?0}", tokens)
    else
      parseRow(rest, "", tokens)
    end
  end

  def parseRow(<<_char, rest::binary>>, _, tokens) do
    parseRow(rest, "", tokens)
  end

  def parseRow(<<>>, _, tokens) do
    tokens
  end
end

defmodule Day3 do
  def getFileContent do
    File.read!("input.txt")
  end

  def multiplyList([int | rest]) do
    multiplyList(rest, int)
  end

  def multiplyList([int | rest], total) do
    multiplyList(rest, total * int)
  end

  def multiplyList(_, total) do
    total
  end

  def pt1() do
    result =
      getFileContent()
      |> StinkyParser.parseRow()
      |> Enum.map(fn token ->
        multiplyList(Enum.at(token, 1))
      end)
      |> Enum.reduce(fn curr, acc -> curr + acc end)

    IO.puts("pt 1 result: #{result}")
  end

  def pt2() do
  end
end

Benchmark.measure(fn -> Day3.pt1() end)
Benchmark.measure(fn -> Day3.pt2() end)
