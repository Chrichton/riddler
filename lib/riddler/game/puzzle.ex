defmodule Riddler.Game.Puzzle do
  use Ecto.Schema
  import Ecto.Changeset

  alias Riddler.Game.Point

  schema "puzzles" do
    field :name, :string
    field :width, :integer
    field :height, :integer
    has_many :points, Point

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(puzzle, attrs) do
    puzzle
    |> cast(attrs, [:name, :height, :width])
    |> validate_required([:name, :height, :width])
  end
end
