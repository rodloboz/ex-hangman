defmodule Dictionary do

  @filename "../assets/words.txt"

  def word_list do
    @filename
    |> Path.expand(__DIR__)
    |> File.read!
    |> String.split(~r/\n/)
  end

  def random_word do
    word_list()
    |> Enum.random
  end
end
