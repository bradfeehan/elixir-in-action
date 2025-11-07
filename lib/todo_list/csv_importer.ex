defmodule TodoList.CsvImporter do
  @moduledoc """
  Imports TodoList entries from a CSV file.

  The CSV file should have one entry per line in the format:
  date,title

  Example:
  2023-12-19,Dentist
  2023-12-20,Shopping
  """

  @doc """
  Imports a TodoList from a CSV file.

  The CSV file should contain one entry per line in the format `date,title`.
  Dates must be in ISO 8601 format (YYYY-MM-DD).

  ## Example

      todo_list = TodoList.CsvImporter.import("todos.csv")
      entries = TodoList.entries(todo_list, ~D[2023-12-19])

  """
  def import(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> TodoList.new()
  end

  defp parse_line(line) do
    [date_string, title] = String.split(line, ",", parts: 2)
    date = Date.from_iso8601!(date_string)
    %{date: date, title: title}
  end
end
