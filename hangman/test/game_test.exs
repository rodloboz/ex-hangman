defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns Hangman.State structure" do
    game = Game.new_game()

    assert is_struct(game)
    assert game.__struct__ == Hangman.Game
  end

  test "new_game returns a state with 7 turns left" do
    game = Game.new_game()

    assert game.turns_left == 7
  end

  test "new_game returns a state of :initializing" do
    game = Game.new_game()

    assert game.game_state == :initializing
  end

  test "new_game returns a state with letters" do
    game = Game.new_game()

    assert length(game.letters) > 0
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [:won, :lost] do
      game =
        Game.new_game()
        |> Map.put(:game_state, state)
        |> Map.put(:turns_left, 6)

      assert ^game = Game.make_move(game, "a_guess")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")

    refute game.game_state == :already_used
  end

  test "second occurrence of letter is already used" do
    game = Game.new_game()

    game = Game.make_move(game, "x")
    refute game.game_state == :already_used

    game = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wiggle")
    game = Game.make_move(game, "w")

    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a bad guess is recognized" do
    game = Game.new_game("wiggle")
    game = Game.make_move(game, "x")

    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  # test "a guessed word is a won game" do
  #   game = Game.new_game("wiggle")
  #   { game, _tally } =
  #     for letter <- game.letters, into: game do
  #        Game.make_move(game, letter)
  #        |> elem(0)
  #     end

  #   assert game.game_state == :won
  #   assert game.turns_left == 7
  # end

  test "tally reveals guessed letters" do
    game = Game.new_game("wiggle")
    tally =
      Game.make_move(game, "g")
      |> Game.tally

    assert tally.letters == ["_", "_", "g", "g", "_", "_"]
  end
end
