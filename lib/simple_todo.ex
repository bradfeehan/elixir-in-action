defmodule TodoList do
  @behaviour Access
  defstruct next_id: 1, entries: %{}

  def new(), do: %TodoList{}

  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.next_id)
    new_entries = Map.put(todo_list.entries, todo_list.next_id, entry)
    %{todo_list | entries: new_entries, next_id: todo_list.next_id + 1}
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Map.values()
    |> Enum.filter(&(&1.date == date))
  end

  def update_entry(todo_list, entry_id, updater_fun) do
    case Map.fetch(todo_list.entries, entry_id) do
      {:ok, old_entry} ->
        new_entry = updater_fun.(old_entry)
        new_entries = Map.put(todo_list.entries, entry_id, new_entry)
        %{todo_list | entries: new_entries}

      :error ->
        todo_list
    end
  end

  def delete_entry(todo_list, entry_id) do
    %{todo_list | entries: Map.delete(todo_list.entries, entry_id)}
  end

  # Access behaviour callbacks to support todo_list[id] and put_in/2
  @impl Access
  def fetch(%TodoList{entries: entries}, entry_id) do
    Map.fetch(entries, entry_id)
  end

  @impl Access
  def get_and_update(%TodoList{entries: entries} = todo_list, entry_id, fun) do
    case Map.get_and_update(entries, entry_id, fun) do
      {value, new_entries} -> {value, %{todo_list | entries: new_entries}}
      :error -> :error
    end
  end

  @impl Access
  def pop(%TodoList{entries: entries} = todo_list, entry_id) do
    case Map.pop(entries, entry_id) do
      {nil, _} -> {nil, todo_list}
      {value, new_entries} -> {value, %{todo_list | entries: new_entries}}
    end
  end
end
