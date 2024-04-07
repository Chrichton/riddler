defmodule Riddler.Repo.Migrations.CreatePoints do
  use Ecto.Migration

  def change do
    create table(:points) do
      add :x, :integer
      add :y, :integer
      add :puzzle_id, references(:puzzles, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:points, [:puzzle_id])
  end
end
