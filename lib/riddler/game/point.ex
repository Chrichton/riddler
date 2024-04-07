defmodule Riddler.Game.Point do
  alias Riddler.Game.Puzzle
  use Ecto.Schema
  import Ecto.Changeset

  schema "points" do
    field :y, :integer
    field :x, :integer
    belongs_to :puzzle, Puzzle

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(point, attrs) do
    point
    |> cast(attrs, [:x, :y])
    |> validate_required([:x, :y])
  end
end
