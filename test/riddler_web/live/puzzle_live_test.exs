defmodule RiddlerWeb.PuzzleLiveTest do
  use RiddlerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Riddler.GameFixtures

  @create_attrs %{name: "some name", width: 42, height: 42}
  @update_attrs %{name: "some updated name", width: 43, height: 43}
  @invalid_attrs %{name: nil, width: nil, height: nil}

  defp create_puzzle(_) do
    puzzle = puzzle_fixture()
    %{puzzle: puzzle}
  end

  describe "Index" do
    setup [:create_puzzle]

    test "lists all puzzles", %{conn: conn, puzzle: puzzle} do
      {:ok, _index_live, html} = live(conn, ~p"/admin/puzzles")

      assert html =~ "Listing Puzzles"
      assert html =~ puzzle.name
    end

    test "saves new puzzle", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/puzzles")

      assert index_live |> element("a", "New Puzzle") |> render_click() =~
               "New Puzzle"

      assert_patch(index_live, ~p"/admin/puzzles/new")

      assert index_live
             |> form("#puzzle-form", puzzle: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#puzzle-form", puzzle: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/puzzles")

      html = render(index_live)
      assert html =~ "Puzzle created successfully"
      assert html =~ "some name"
    end

    test "updates puzzle in listing", %{conn: conn, puzzle: puzzle} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/puzzles")

      assert index_live |> element("#puzzles-#{puzzle.id} a", "Edit") |> render_click() =~
               "Edit Puzzle"

      assert_patch(index_live, ~p"/admin/puzzles/#{puzzle}/edit")

      assert index_live
             |> form("#puzzle-form", puzzle: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#puzzle-form", puzzle: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/puzzles")

      html = render(index_live)
      assert html =~ "Puzzle updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes puzzle in listing", %{conn: conn, puzzle: puzzle} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/puzzles")

      assert index_live |> element("#puzzles-#{puzzle.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#puzzles-#{puzzle.id}")
    end
  end

  describe "Show" do
    setup [:create_puzzle]

    test "displays puzzle", %{conn: conn, puzzle: puzzle} do
      {:ok, _show_live, html} = live(conn, ~p"/admin/puzzles/#{puzzle}")

      assert html =~ "Show Puzzle"
      assert html =~ puzzle.name
    end

    test "updates puzzle within modal", %{conn: conn, puzzle: puzzle} do
      {:ok, show_live, _html} = live(conn, ~p"/admin/puzzles/#{puzzle}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Puzzle"

      assert_patch(show_live, ~p"/admin/puzzles/#{puzzle}/show/edit")

      assert show_live
             |> form("#puzzle-form", puzzle: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#puzzle-form", puzzle: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/admin/puzzles/#{puzzle}")

      html = render(show_live)
      assert html =~ "Puzzle updated successfully"
      assert html =~ "some updated name"
    end
  end
end
