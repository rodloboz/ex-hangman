defmodule Hangman.GamesSupervisor do

  use DynamicSupervisor

  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start_game do
    spec = {Hangman.Server, nil}
    # spec = %{id: Hangman.Server, start: {Hangman.Server, :start_link, []}}
    { :ok, pid } = DynamicSupervisor.start_child(__MODULE__, spec)
    pid
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: []
    )
  end

end