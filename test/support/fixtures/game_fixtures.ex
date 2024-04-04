defmodule Riddler.GameFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Riddler.Game` context.
  """

  @doc """
  Generate a puzzle.
  """
  def puzzle_fixture(attrs \\ %{}) do
    {:ok, puzzle} =
      attrs
      |> Enum.into(%{
        height: 42,
        name: "some name",
        width: 42
      })
      |> Riddler.Game.create_puzzle()

    puzzle
  end
end
