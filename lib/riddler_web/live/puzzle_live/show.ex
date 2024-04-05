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

  attr :x, :integer, required: true
  attr :y, :integer, required: true
  attr :alive, :boolean, default: false

  defp rect(assigns) do
    ~H"""
    <rect
      x={@x * 10}
      y={@y * 10}
      width="10"
      height="10"
      rx="2"
      fill={fill_color(@alive)}
      class="hover:fill-slate-400"
    />
    """
  end

  defp fill_color(true), do: "black"
  defp fill_color(false), do: "white"
end
