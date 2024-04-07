defmodule RiddlerWeb.PuzzleLive.Show do
  use RiddlerWeb, :live_view

  alias Riddler.Game

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:puzzle, Game.get_puzzle!(id))}
  end

  defp page_title(:show), do: "Show Puzzle"
  defp page_title(:edit), do: "Edit Puzzle"
  defp page_title(:points), do: "Edit Points"
end
