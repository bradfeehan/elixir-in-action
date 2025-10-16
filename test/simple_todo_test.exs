defmodule TodoListTest do
  use ExUnit.Case
  doctest TodoList

  test "creates a new empty todo list" do
    todo_list = TodoList.new()
    assert todo_list == %{}
  end

  test "adds entries to todo list" do
    todo_list =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2023-12-19], title: "Dentist"})
      |> TodoList.add_entry(%{date: ~D[2023-12-20], title: "Shopping"})
      |> TodoList.add_entry(%{date: ~D[2023-12-19], title: "Movies"})

    # Test entries for 2023-12-19 (should have both "Movies" and "Dentist")
    entries_19 = TodoList.entries(todo_list, ~D[2023-12-19])
    assert length(entries_19) == 2
    assert %{date: ~D[2023-12-19], title: "Movies"} in entries_19
    assert %{date: ~D[2023-12-19], title: "Dentist"} in entries_19

    # Test entries for 2023-12-20 (should have "Shopping")
    entries_20 = TodoList.entries(todo_list, ~D[2023-12-20])
    assert entries_20 == [%{date: ~D[2023-12-20], title: "Shopping"}]

    # Test entries for non-existent date (should return empty list)
    entries_18 = TodoList.entries(todo_list, ~D[2023-12-18])
    assert entries_18 == []
  end

  test "handles multiple entries for same date" do
    todo_list =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2023-12-19], title: "Task 1"})
      |> TodoList.add_entry(%{date: ~D[2023-12-19], title: "Task 2"})
      |> TodoList.add_entry(%{date: ~D[2023-12-19], title: "Task 3"})

    entries = TodoList.entries(todo_list, ~D[2023-12-19])
    assert length(entries) == 3
    assert %{date: ~D[2023-12-19], title: "Task 1"} in entries
    assert %{date: ~D[2023-12-19], title: "Task 2"} in entries
    assert %{date: ~D[2023-12-19], title: "Task 3"} in entries
  end
end
