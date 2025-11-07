defmodule TodoListTest do
  use ExUnit.Case
  doctest TodoList

  test "creates a new empty todo list" do
    todo_list = TodoList.new()
    assert %TodoList{next_id: 1, entries: %{}} = todo_list
  end

  test "adds entries to todo list with unique IDs" do
    todo_list =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2023-12-19], title: "Dentist"})
      |> TodoList.add_entry(%{date: ~D[2023-12-20], title: "Shopping"})
      |> TodoList.add_entry(%{date: ~D[2023-12-19], title: "Movies"})

    # Test entries for 2023-12-19 (should have both "Movies" and "Dentist")
    entries_19 = TodoList.entries(todo_list, ~D[2023-12-19])
    assert length(entries_19) == 2
    assert %{date: ~D[2023-12-19], id: 1, title: "Dentist"} in entries_19
    assert %{date: ~D[2023-12-19], id: 3, title: "Movies"} in entries_19

    # Test entries for 2023-12-20 (should have "Shopping")
    entries_20 = TodoList.entries(todo_list, ~D[2023-12-20])
    assert [%{date: ~D[2023-12-20], id: 2, title: "Shopping"}] = entries_20

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

  test "example from requirements" do
    todo_list = TodoList.new() |>
      TodoList.add_entry(%{date: ~D[2023-12-19], title: "Dentist"}) |>
      TodoList.add_entry(%{date: ~D[2023-12-20], title: "Shopping"}) |>
      TodoList.add_entry(%{date: ~D[2023-12-19], title: "Movies"})

    entries_19 = TodoList.entries(todo_list, ~D[2023-12-19])
    assert length(entries_19) == 2
    assert %{date: ~D[2023-12-19], id: 1, title: "Dentist"} in entries_19
    assert %{date: ~D[2023-12-19], id: 3, title: "Movies"} in entries_19
  end

  test "update_entry modifies an existing entry" do
    todo_list =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2023-12-19], title: "Dentist"})
      |> TodoList.add_entry(%{date: ~D[2023-12-20], title: "Shopping"})

    updated_list = TodoList.update_entry(
      todo_list,
      1,
      &Map.put(&1, :date, ~D[2023-12-20])
    )

    # Entry 1 should now have date 2023-12-20
    entry_1 = Map.get(updated_list.entries, 1)
    assert entry_1.date == ~D[2023-12-20]
    assert entry_1.title == "Dentist"

    # Entry 2 should be unchanged
    entry_2 = Map.get(updated_list.entries, 2)
    assert entry_2.date == ~D[2023-12-20]
    assert entry_2.title == "Shopping"
  end

  test "update_entry does nothing if entry doesn't exist" do
    todo_list = TodoList.new()
    updated_list = TodoList.update_entry(todo_list, 999, &Map.put(&1, :title, "New"))
    assert updated_list == todo_list
  end

  test "delete_entry removes an entry" do
    todo_list =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2023-12-19], title: "Dentist"})
      |> TodoList.add_entry(%{date: ~D[2023-12-20], title: "Shopping"})

    updated_list = TodoList.delete_entry(todo_list, 1)

    assert Map.has_key?(updated_list.entries, 2)
    refute Map.has_key?(updated_list.entries, 1)

    # Verify entries by date still work
    entries_19 = TodoList.entries(updated_list, ~D[2023-12-19])
    assert entries_19 == []

    entries_20 = TodoList.entries(updated_list, ~D[2023-12-20])
    assert length(entries_20) == 1
  end

  test "delete_entry handles non-existent entry gracefully" do
    todo_list = TodoList.new() |> TodoList.add_entry(%{date: ~D[2023-12-19], title: "Dentist"})
    updated_list = TodoList.delete_entry(todo_list, 999)
    assert updated_list.entries == todo_list.entries
  end

  test "Access behavior - get entry by ID" do
    todo_list =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2023-12-19], title: "Dentist"})

    assert Access.get(todo_list, 1) == %{date: ~D[2023-12-19], id: 1, title: "Dentist"}
    assert Access.get(todo_list, 999) == nil
  end

  test "Access behavior - put_in works with TodoList" do
    todo_list =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2023-12-19], title: "Dentist"})

    updated_list = put_in(todo_list[1].title, "Updated Dentist")

    entry = Map.get(updated_list.entries, 1)
    assert entry.title == "Updated Dentist"
  end

  test "Access behavior - update_in works with TodoList" do
    todo_list =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2023-12-19], title: "Dentist"})

    updated_list = update_in(todo_list[1].title, &String.upcase/1)

    entry = Map.get(updated_list.entries, 1)
    assert entry.title == "DENTIST"
  end
end
