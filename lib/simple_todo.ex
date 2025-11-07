defmodule TodoList do
  defstruct next_id: 1, entries: %{}

  def new(), do: %TodoList{}

  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.next_id)
    
    new_entries = Map.put(todo_list.entries, todo_list.next_id, entry)
    
    %TodoList{
      todo_list |
      entries: new_entries,
      next_id: todo_list.next_id + 1
    }
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Map.values()
    |> Enum.filter(&(&1.date == date))
  end

  def update_entry(todo_list, entry_id, updater_fun) do
    case Map.get(todo_list.entries, entry_id) do
      nil -> todo_list
      entry ->
        updated_entry = updater_fun.(entry)
        updated_entries = Map.put(todo_list.entries, entry_id, updated_entry)
        %TodoList{todo_list | entries: updated_entries}
    end
  end

  def delete_entry(todo_list, entry_id) do
    %TodoList{todo_list | entries: Map.delete(todo_list.entries, entry_id)}
  end

  @behaviour Access

  def fetch(todo_list, key) do
    Access.fetch(todo_list.entries, key)
  end

  def get_and_update(todo_list, key, fun) do
    {value, updated_entries} = Access.get_and_update(todo_list.entries, key, fun)
    {value, %TodoList{todo_list | entries: updated_entries}}
  end

  def pop(todo_list, key) do
    {value, updated_entries} = Map.pop(todo_list.entries, key)
    {value, %TodoList{todo_list | entries: updated_entries}}
  end
end
