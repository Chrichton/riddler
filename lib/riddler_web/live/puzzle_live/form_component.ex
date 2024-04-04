defmodule RiddlerWeb.PuzzleLive.FormComponent do
  use RiddlerWeb, :live_component

  alias Riddler.Game

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage puzzle records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="puzzle-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:height]} type="number" label="Height" />
        <.input field={@form[:width]} type="number" label="Width" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Puzzle</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{puzzle: puzzle} = assigns, socket) do
    changeset = Game.change_puzzle(puzzle)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"puzzle" => puzzle_params}, socket) do
    changeset =
      socket.assigns.puzzle
      |> Game.change_puzzle(puzzle_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"puzzle" => puzzle_params}, socket) do
    save_puzzle(socket, socket.assigns.action, puzzle_params)
  end

  defp save_puzzle(socket, :edit, puzzle_params) do
    case Game.update_puzzle(socket.assigns.puzzle, puzzle_params) do
      {:ok, puzzle} ->
        notify_parent({:saved, puzzle})

        {:noreply,
         socket
         |> put_flash(:info, "Puzzle updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_puzzle(socket, :new, puzzle_params) do
    case Game.create_puzzle(puzzle_params) do
      {:ok, puzzle} ->
        notify_parent({:saved, puzzle})

        {:noreply,
         socket
         |> put_flash(:info, "Puzzle created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
