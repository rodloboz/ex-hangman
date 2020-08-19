defmodule TextClient.Player do

  alias TextClient.{Mover, Prompter, Summary, State}

  def play(%State{ tally: %{ game_state: :won }}) do
    exit_with_message("Congratulations, you WON!!!")
  end

  def play(%State{ tally: %{ game_state: :lost }}) do
    exit_with_message("Sorry, you LOST.")
  end

  def play(game = %State{ tally: %{ game_state: :good_guess }}) do
    game |> continue_with_message("Good guess!")
  end

  def play(game = %State{ tally: %{ game_state: :bad_guess }}) do
    game |> continue_with_message("Sorry, that isn't in the word.")
  end

  def play(game = %State{ tally: %{ game_state: :already_used }}) do
    game |> continue_with_message("Oops, you've already used that letter!")
  end

  def play(game = %State{}) do
    continue(game)
  end

  defp continue_with_message(game, msg) do
    IO.puts msg
    continue(game)
  end

  defp continue(game) do
    game
    |> Summary.display
    |> Prompter.accept_move
    |> Mover.move
    |> play
  end

  defp exit_with_message(msg) do
    IO.puts msg
    exit(:normal)
  end
end