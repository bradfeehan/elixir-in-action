defmodule TodoList.CsvImporterTest do
  use ExUnit.Case

  test "imports a todo list from a CSV file" do
    # Create a temporary CSV file
    csv_content = """
    2023-12-19,Dentist
    2023-12-20,Shopping
    2023-12-19,Movies
    """

    # Write to a temporary file
    filename = "test_todos.csv"
    File.write!(filename, csv_content)

    try do
      todo_list = TodoList.CsvImporter.import(filename)

      # Test entries for 2023-12-19 (should have both "Movies" and "Dentist")
      entries_19 = TodoList.entries(todo_list, ~D[2023-12-19])
      assert length(entries_19) == 2
      assert %{date: ~D[2023-12-19], id: 1, title: "Dentist"} in entries_19
      assert %{date: ~D[2023-12-19], id: 3, title: "Movies"} in entries_19

      # Test entries for 2023-12-20 (should have "Shopping")
      entries_20 = TodoList.entries(todo_list, ~D[2023-12-20])
      assert length(entries_20) == 1
      assert %{date: ~D[2023-12-20], id: 2, title: "Shopping"} in entries_20
    after
      # Clean up the temporary file
      File.rm(filename)
    end
  end
end
