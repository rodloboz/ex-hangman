defmodule Hangman.Game do
  alias Hangman.Game

  defstruct [
    turns_left: 7,
    game_state: :initializing,
    letters:    [],
    used:       MapSet.new(),
  ]

  def new_game do
    %Game{
      letters: letters()
    }
  end

  def make_move(game = %Game{ game_state: state }, _guess) when state in [:won, :lost] do
    { game, tally(game) }
  end

  def make_move(game = %Game{}, guess) do
    game =
      MapSet.member?(game.used, guess)
      |> accept_move(game, guess)
    { game, tally(game) }
  end

  defp accept_move(_already_guessed = true, game, _guess) do
    Map.put(game, :game_state, :already_used)
  end

  defp accept_move(_already_guessed, game, guess) do
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score_guess(guess, Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _guess, _good_guess = true) do
    new_state =
      MapSet.new(game.letters)
      |> MapSet.subset?(game.used)
      |> check_win
    Map.put(game, :game_state, new_state)
  end

  defp score_guess(game, _guess, _not_good_guess) do
    game
  end

  defp check_win(true), do: :won
  defp check_win(_),    do: :good_guess

  defp letters do
    Dictionary.random_word
    |> String.codepoints
  end

  defp tally(_game) do
    123
  end
end