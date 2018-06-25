defmodule ScreenMatrixTest do
  use ExUnit.Case
  doctest ScreenMatrix

  @empty_matrix List.duplicate(0, 100)

  test "start the new ScreenMatrix process" do
    assert {:ok, _pid} = ScreenMatrix.new()
  end

  test "empty matrix returns empty string" do
    start_matrix()
    assert "" == ScreenMatrix.process(@empty_matrix)
  end

  test "one point touch on first line returns valid x, y" do
    start_matrix()
    assert "" == ScreenMatrix.process([1] ++ List.duplicate(0, 99))
    assert "D(1,1)" == ScreenMatrix.process(@empty_matrix)
  end

  test "multi point touch on first line" do
    start_matrix()
    assert "" == ScreenMatrix.process([1, 0, 0, 0, 0, 0, 0, 0, 1] ++ List.duplicate(0, 90))
    assert "D(5,1)" == ScreenMatrix.process(@empty_matrix)
  end

  test "too large input empty matrix" do
    start_matrix()
    assert "" == ScreenMatrix.process(@empty_matrix ++ List.duplicate(0, 50))
  end

  test "too smal input empty matrix" do
    start_matrix()
    assert "" == ScreenMatrix.process(Enum.drop(@empty_matrix, -10))
  end

  test "too large input, non empty matrix" do
    start_matrix()
    assert "" == ScreenMatrix.process(@empty_matrix ++ List.duplicate(15, 10))
    assert "" == ScreenMatrix.process(@empty_matrix)
  end

  test "all points set" do
    start_matrix()
    assert "" == ScreenMatrix.process(List.duplicate(1, 100))
    assert "D(5,5)" == ScreenMatrix.process(@empty_matrix)
  end

  test "multiple touches in the row" do
    start_matrix()
    assert "" == ScreenMatrix.process([1, 1] ++ List.duplicate(0, 98))
    assert "" == ScreenMatrix.process(List.duplicate(0, 10) ++ [1, 1] ++ List.duplicate(0, 88))
    assert "D(1,2)" == ScreenMatrix.process(@empty_matrix)
  end

  test "touches in 2 lines" do
    start_matrix()
    assert "" == ScreenMatrix.process([1] ++ List.duplicate(0, 19) ++ [1] ++ List.duplicate(0, 89))
    assert "D(1,2)" == ScreenMatrix.process(@empty_matrix)
  end

  def start_matrix do
    {:ok, _pid} = ScreenMatrix.new()
  end
end
