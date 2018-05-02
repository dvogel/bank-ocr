require 'minitest/autorun'

class AccountNumberGeometry
  def initialize(digits: 10)
    @char_width = digits * 3
  end

  # Returns an array of offsets into the grid that would represent the number
  # at the given position (0-9).
  def offsets(pos:)
    4.times.flat_map do |row|
      3.times.map do |col|
        (row * @char_width) + (pos * 3) + col
      end
    end
  end
end

class AccountNumberReader
  def initialize
    alphabet_text = IO.read("ex1.txt").chars.reject do |ch|
      ch == "\n"
    end
    alphabet_geometry = AccountNumberGeometry.new(digits: 10)
    # @patterns is a Hash mapping arrays of characters to the character represented.
    @patterns = build_patterns(text: alphabet_text, geometry: alphabet_geometry)
  end

  def build_patterns(text:, geometry:)
    patterns = {}
    10.times do |digit_pos|
      chars = geometry.offsets(pos: digit_pos).map do |offset|
        text[offset]
      end
      patterns[chars] = digit_pos.to_s
    end
    patterns
  end

  # Returns a Hash mapping each digit position (0-9) to an array of characters
  # found in the text for that position.
  def digit_chars(text:)
    grouped_by_pos = {}
    chars = text.chars.reject do |ch|
      ch == "\n"
    end
    chars.each_with_index do |ch, ix|
      digit_pos = (ix % 27) / 3
      (grouped_by_pos[digit_pos] ||= []) << ch
    end
    grouped_by_pos
  end

  # Compares the characters found in each 4x3 area of the text grid to a set of
  # known digits. Falls back to the question mark (?) character if the
  # characters are not recognized.
  def recognize(text:)
    recognized_chars = digit_chars(text: text).map do |pos, chars|
      @patterns[chars] || "?"
    end
    recognized_chars.join
  end
end

describe AccountNumberReader, "" do
  PrimaryExampleText = <<-END
    _  _     _  _  _  _  _ 
  | _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|
                           
  END

  before do
    @reader = AccountNumberReader.new
  end

  it "recognizes canonical example" do
    assert_equal "123456789", @reader.recognize(text: PrimaryExampleText)
  end

  it "recognizes another example" do
    input = <<-END
 _  _  _     _  _  _  _    
|_| _| _||_||_ |_   ||_|  |
 _||_  _|  | _||_|  ||_|  |
                           
    END
    assert_equal "923456781", @reader.recognize(text: input)
  end

  it "uses placeholders for unrecognized digits" do
    input = <<-END
 _  _  _     _     _  _    
|_| _| _|   |_      ||_|  |
 _||_  _|    _|     ||_|  |
                           
    END
    assert_equal "923?5?781", @reader.recognize(text: input)
  end
end




