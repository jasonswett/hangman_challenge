class Game
  attr_reader :word, :correct_guesses, :incorrect_guesses

  def initialize(word)
    @word = word
    @correct_guesses = []
    @incorrect_guesses = []
  end

  def status
    output_items = [cloaked_word]

    if player_has_won?
      output_items << "YOU WIN!"
    elsif player_has_lost?
      output_items << "YOU LOSE!"
    else
      output_items << "life left: #{life_left}"

      if incorrect_guesses.any?
        output_items << "incorrect guesses: #{incorrect_guesses.join("")}"
      end
    end

    output_items.join(" ")
  end

  private

  def cloaked_word
    word.cloaked(@correct_guesses)
  end

  def life_left
    6 - incorrect_guesses.count
  end

  def player_has_won?
    !cloaked_word.include?("_")
  end

  def player_has_lost?
    life_left <= 0
  end
end

class Word
  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end

  def contains?(guess)
    @value.include?(guess)
  end

  def cloaked(correct_guesses)
    @value.split("").map do |letter|
      if correct_guesses.include?(letter)
        letter
      else
        "_"
      end
    end.join
  end
end

commands = File.read("inputs.txt").split("\n")
game = nil

commands.each do |command|
  next unless command.to_s.length > 0

  if command.length > 1
    game = Game.new(Word.new(command))
    correct_guesses = []
  else
    guess = command

    if game.word.contains?(guess)
      game.correct_guesses << guess
    else
      game.incorrect_guesses << guess
    end
  end

  puts game.status
end
