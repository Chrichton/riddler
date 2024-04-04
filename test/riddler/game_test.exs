defmodule Riddler.GameTest do
  use Riddler.DataCase

  alias Riddler.Game

  describe "puzzles" do
    alias Riddler.Game.Puzzle

    import Riddler.GameFixtures

    @invalid_attrs %{name: nil, width: nil, height: nil}

    test "list_puzzles/0 returns all puzzles" do
      puzzle = puzzle_fixture()
      assert Game.list_puzzles() == [puzzle]
    end

    test "get_puzzle!/1 returns the puzzle with given id" do
      puzzle = puzzle_fixture()
      assert Game.get_puzzle!(puzzle.id) == puzzle
    end

    test "create_puzzle/1 with valid data creates a puzzle" do
      valid_attrs = %{name: "some name", width: 42, height: 42}

      assert {:ok, %Puzzle{} = puzzle} = Game.create_puzzle(valid_attrs)
      assert puzzle.name == "some name"
      assert puzzle.width == 42
      assert puzzle.height == 42
    end

    test "create_puzzle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_puzzle(@invalid_attrs)
    end

    test "update_puzzle/2 with valid data updates the puzzle" do
      puzzle = puzzle_fixture()
      update_attrs = %{name: "some updated name", width: 43, height: 43}

      assert {:ok, %Puzzle{} = puzzle} = Game.update_puzzle(puzzle, update_attrs)
      assert puzzle.name == "some updated name"
      assert puzzle.width == 43
      assert puzzle.height == 43
    end

    test "update_puzzle/2 with invalid data returns error changeset" do
      puzzle = puzzle_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_puzzle(puzzle, @invalid_attrs)
      assert puzzle == Game.get_puzzle!(puzzle.id)
    end

    test "delete_puzzle/1 deletes the puzzle" do
      puzzle = puzzle_fixture()
      assert {:ok, %Puzzle{}} = Game.delete_puzzle(puzzle)
      assert_raise Ecto.NoResultsError, fn -> Game.get_puzzle!(puzzle.id) end
    end

    test "change_puzzle/1 returns a puzzle changeset" do
      puzzle = puzzle_fixture()
      assert %Ecto.Changeset{} = Game.change_puzzle(puzzle)
    end
  end
end
