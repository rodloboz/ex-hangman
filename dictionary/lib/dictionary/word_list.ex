defmodule Dictionary.WordList do

  @filename "../../assets/words.txt"
  @me __MODULE__

  def start_link do
    Agent.start_link(&all_words/0, name: @me)
  end

  def all_words do
    @filename
    |> Path.expand(__DIR__)
    |> File.read!
    |> String.split(~r/\n/)
  end

  def random_word do
    Agent.get(@me, &Enum.random/1)
  end
end
