defmodule Hangman.Application do

  alias Hangman.GamesSupervisor

  use Application

  def start(_type, _args) do
    GamesSupervisor.start_link([])
  end
end