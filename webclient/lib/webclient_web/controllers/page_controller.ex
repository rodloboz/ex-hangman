defmodule WebclientWeb.PageController do
  use WebclientWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
