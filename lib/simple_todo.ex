defmodule TodoList do
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

  defimpl Access do
    def fetch(todo_list, entry_id) do
      Map.fetch(todo_list.entries, entry_id)
    end

    def get_and_update(todo_list, entry_id, fun) do
      case Map.get_and_update(todo_list.entries, entry_id, fun) do
        {value, new_entries} ->
          {value, %{todo_list | entries: new_entries}}

        :error ->
          :error
      end
    end

    def pop(todo_list, entry_id) do
      case Map.pop(todo_list.entries, entry_id) do
        {value, new_entries} ->
          {value, %{todo_list | entries: new_entries}}

        {nil, _} ->
          {nil, todo_list}
      end
    end
  end
end
