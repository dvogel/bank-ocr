class AccountNumberGeometry
  DigitCharWidth = 3
  DigitCharHeight = 4

  def initialize(digits:)
    @char_width = digits * DigitCharWidth
  end

  attr_reader :char_width

  def digit_char_width
    DigitCharWidth
  end

  # Returns an array of offsets into the grid that would represent the number
  # at the given position.
  def offsets(pos:)
    # TODO: The digit dimensions should also be variable.
    DigitCharHeight.times.flat_map do |row|
      DigitCharWidth.times.map do |col|
        (row * @char_width) + (pos * DigitCharWidth) + col
      end
    end
  end

  # Givens an array of characters, inserts line endings where they would have
  # been when read in.
  def format(chars)
    chars.each_slice(digit_char_width).map(&:join).join("\n")
  end
end

