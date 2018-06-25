defmodule ScreenMatrix do
  use GenServer

  @moduledoc """
  Documentation for ScreenMatrix.
  """

  @doc """
  """
  def new do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def process(matrix) do
    matrix =
      case Enum.count(matrix) do
        size when size < 100 -> matrix ++ List.duplicate(0, 100 - size)
        size when size > 100 -> Enum.drop(matrix, 100 - size)
        _ -> matrix
      end

    GenServer.call(__MODULE__, {:process, matrix})
  end

  @impl true
  def init(_args) do
    {:ok, {0, 0}}
  end

  @impl true
  def handle_call({:process, matrix}, _from, data = {0, 0}) do
    if empty?(matrix) == true do
      {:reply, "", data}
    else
      {:reply, "", get_points(matrix)}
    end
  end

  def handle_call({:process, matrix}, _from, {x, y}) do
    if empty?(matrix) == true do
      {:reply, "D(#{x},#{y})", {0, 0}}
    else
      {:reply, "", get_points(matrix)}
    end
  end

  defp empty?(matrix) do
    not Enum.any?(matrix, &(&1 != 0))
  end

  defp get_points(matrix) do
    matrix
    |> Enum.reduce_while({1, 1, []}, &scan_matrix/2)
    |> get_x_y()
  end

  defp get_x_y(points) do
    points
    |> Enum.unzip()
    |> max_x_y()
  end

  defp max_x_y({xs, ys}) do
    {min_x, max_x} = Enum.min_max(xs)
    {min_y, max_y} = Enum.min_max(ys)
    {div(max_x + min_x, 2), div(max_y + min_y, 2)}
  end

  defp scan_matrix(0, {10, 10, acc}), do: {:halt, acc}
  defp scan_matrix(_v, {10, 10, acc}), do: {:halt, [{10, 10} | acc]}
  defp scan_matrix(0, {10, y, acc}), do: {:cont, {1, y + 1, acc}}
  defp scan_matrix(_v, {10, y, acc}), do: {:cont, {1, y + 1, [{10, y} | acc]}}
  defp scan_matrix(0, {x, y, acc}), do: {:cont, {x + 1, y, acc}}
  defp scan_matrix(_v, {x, y, acc}), do: {:cont, {x + 1, y, [{x, y} | acc]}}
end
