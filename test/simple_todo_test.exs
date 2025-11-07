defmodule TodoListTest do
  use ExUnit.Case
  doctest TodoList

  test "creates a new empty todo list" do
    todo_list = TodoList.new()
    assert todo_list == %TodoList{next_id: 1, entries: %{}}
  end

  test "adds entries to todo list with auto-generated IDs" do
    todo_list =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2023-12-19], title: "Dentist"})
      |> TodoList.add_entry(%{date: ~D[2023-12-20], title: "Shopping"})
      |> TodoList.add_entry(%{date: ~D[2023-12-19], title: "Movies"})

    # Test entries for 2023-12-19 (should have both "Movies" and "Dentist" with IDs 1 and 3)
    entries_19 = TodoList.entries(todo_list, ~D[2023-12-19])
    assert length(entries_19) == 2
    assert %{date: ~D[2023-12-19], id: 1, title: "Dentist"} in entries_19
    assert %{date: ~D[2023-12-19], id: 3, title: "Movies"} in entries_19

    # Test entries for 2023-12-20 (should have "Shopping" with ID 2)
    entries_20 = TodoList.entries(todo_list, ~D[2023-12-20])
    assert entries_20 == [%{date: ~D[2023-12-20], id: 2, title: "Shopping"}]

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
    assert %{date: ~D[2023-12-19], id: 1, title: "Task 1"} in entries
    assert %{date: ~D[2023-12-19], id: 2, title: "Task 2"} in entries
    assert %{date: ~D[2023-12-19], id: 3, title: "Task 3"} in entries
  end

  test "update_entry modifies an entry" do
    todo_list =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2023-12-19], title: "Dentist"})
      |> TodoList.add_entry(%{date: ~D[2023-12-20], title: "Shopping"})

    updated_todo_list =
      TodoList.update_entry(
        todo_list,
        1,
        &Map.put(&1, :date, ~D[2023-12-20])
      )

    # Entry with ID 1 should now have date 2023-12-20
    entries_20 = TodoList.entries(updated_todo_list, ~D[2023-12-20])
    assert length(entries_20) == 2
    assert %{date: ~D[2023-12-20], id: 1, title: "Dentist"} in entries_20
    assert %{date: ~D[2023-12-20], id: 2, title: "Shopping"} in entries_20

    # Entry with ID 1 should no longer be in 2023-12-19
    entries_19 = TodoList.entries(updated_todo_list, ~D[2023-12-19])
    assert entries_19 == []
  end

  test "update_entry handles non-existent entry gracefully" do
    todo_list = TodoList.new() |> TodoList.add_entry(%{date: ~D[2023-12-19], title: "Dentist"})

    updated_todo_list =
      TodoList.update_entry(
        todo_list,
        999,
        &Map.put(&1, :date, ~D[2023-12-20])
      )

    # Should remain unchanged
    assert updated_todo_list == todo_list
  end

  test "delete_entry removes an entry" do
    todo_list =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2023-12-19], title: "Dentist"})
      |> TodoList.add_entry(%{date: ~D[2023-12-20], title: "Shopping"})

    updated_todo_list = TodoList.delete_entry(todo_list, 1)

    # Entry with ID 1 should be removed
    entries_19 = TodoList.entries(updated_todo_list, ~D[2023-12-19])
    assert entries_19 == []

    # Entry with ID 2 should still exist
    entries_20 = TodoList.entries(updated_todo_list, ~D[2023-12-20])
    assert entries_20 == [%{date: ~D[2023-12-20], id: 2, title: "Shopping"}]
  end

  test "Access protocol works with put_in" do
    todo_list =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2023-12-19], title: "Dentist"})

    updated_todo_list = put_in(todo_list[1].date, ~D[2023-12-20])

    entries_20 = TodoList.entries(updated_todo_list, ~D[2023-12-20])
    assert %{date: ~D[2023-12-20], id: 1, title: "Dentist"} in entries_20
  end
end
