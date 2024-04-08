defmodule Riddler.Game do
  @moduledoc """
  The Game context.
  """

  import Ecto.Query, warn: false

  alias Postgrex.Extensions.Point
  alias Ecto.Multi
  alias Riddler.Repo
  alias Riddler.Game.{Puzzle, Point}

  @doc """
  Returns the list of puzzles.

  ## Examples

      iex> list_puzzles()
      [%Puzzle{}, ...]

  """
  def list_puzzles do
    Repo.all(Puzzle)
  end

  @doc """
  Gets a single puzzle.

  Raises `Ecto.NoResultsError` if the Puzzle does not exist.

  ## Examples

      iex> get_puzzle!(123)
      %Puzzle{}

      iex> get_puzzle!(456)
      ** (Ecto.NoResultsError)

  """
  def get_puzzle!(id) do
    Repo.get!(Puzzle, id)
    |> Repo.preload([:points])
  end

  @doc """
  Creates a puzzle.

  ## Examples

      iex> create_puzzle(%{field: value})
      {:ok, %Puzzle{}}

      iex> create_puzzle(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_puzzle(attrs \\ %{}) do
    %Puzzle{}
    |> Puzzle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a puzzle.

  ## Examples

      iex> update_puzzle(puzzle, %{field: new_value})
      {:ok, %Puzzle{}}

      iex> update_puzzle(puzzle, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_puzzle(%Puzzle{} = puzzle, attrs) do
    puzzle
    |> Puzzle.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a puzzle.

  ## Examples

      iex> delete_puzzle(puzzle)
      {:ok, %Puzzle{}}

      iex> delete_puzzle(puzzle)
      {:error, %Ecto.Changeset{}}

  """
  def delete_puzzle(%Puzzle{} = puzzle) do
    Repo.delete(puzzle)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking puzzle changes.

  ## Examples

      iex> change_puzzle(puzzle)
      %Ecto.Changeset{data: %Puzzle{}}

  """
  def change_puzzle(%Puzzle{} = puzzle, attrs \\ %{}) do
    Puzzle.changeset(puzzle, attrs)
  end

  def save_puzzle_points(puzzle, points) do
    dt =
      DateTime.utc_now()
      |> DateTime.truncate(:second)

    new_points =
      Enum.map(
        points,
        fn {x, y} ->
          %{x: x, y: y, puzzle_id: puzzle.id, inserted_at: dt, updated_at: dt}
        end
      )

    Multi.new()
    |> Multi.delete_all(:points, Ecto.assoc(puzzle, :points))
    |> Multi.insert_all(:insert_points, Point, new_points)
    |> Repo.transaction()
  end
end
