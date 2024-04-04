defmodule Riddler.Repo.Migrations.CreatePuzzles do
  use Ecto.Migration

  def change do
    create table(:puzzles) do
      add :name, :string
      add :height, :integer
      add :width, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
