defmodule Hangman.Game do
  alias Hangman.Game

  defstruct [
    turns_left: 7,
    game_state: :initializing,
    letters:    [],
    used:       MapSet.new(),
  ]

  def new_game(word) do
    %Game{
      letters: word |> String.codepoints
    }
  end

  def new_game do
    new_game(Dictionary.random_word)
  end

  def make_move(game = %Game{ game_state: state }, _guess) when state in [:won, :lost] do
    game
  end

  def make_move(game = %Game{}, guess) do
    MapSet.member?(game.used, guess)
    |> accept_move(game, guess)
  end

  def tally(game) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters: game.letters |> reveal_guessed(game.used)
    }
  end

  # Private functions

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

  defp score_guess(game =  %Game{ turns_left: 1 }, _guess, _not_good_guess) do
    Map.put(game, :game_state, :lost)
  end

  defp score_guess(game =  %Game{ turns_left: turns_left }, _guess, _not_good_guess) do
   %{
      game |
      game_state: :bad_guess,
      turns_left: turns_left - 1
    }
  end

  defp check_win(true), do: :won
  defp check_win(_),    do: :good_guess

  defp reveal_guessed(letters, used) do
    letters
    |> Enum.map(&reveal_letter(&1, MapSet.member?(used, &1)))
  end

  defp reveal_letter(letter, _in_word = true), do: letter
  defp reveal_letter(_letter, _not_in_word = false), do: "_"
end