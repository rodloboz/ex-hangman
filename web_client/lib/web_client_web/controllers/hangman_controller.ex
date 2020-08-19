defmodule WebClientWeb.HangmanController do
  use WebClientWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, _params) do
    game_id = Hangman.new_game()
    tally = Hangman.tally(game_id)
    conn
    |> put_session(:game_id, game_id)
    |> render("game.html", tally: tally)
  end

  def update(conn, params) do
    guess = params["make_move"]["guess"]
    tally =
      conn
      |> get_session(:game_id)
      |> Hangman.make_move(guess)
    put_in(conn.params["make_move"]["guess"], "")
    |> render("game.html", tally: tally)
  end
end
