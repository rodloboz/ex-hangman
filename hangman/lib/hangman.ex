defmodule Hangman do

  alias Hangman.GamesSupervisor

  def new_game do
    GamesSupervisor.start_game
  end

  def tally(game_pid) do
    GenServer.call(game_pid, { :tally })
  end

  def make_move(game_pid, guess) do
    GenServer.call(game_pid, { :make_move, guess })
  end

end
