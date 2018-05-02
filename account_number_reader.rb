require_relative './account_number_geometry'

class AccountNumberReader
  def initialize
    alphabet_text = IO.read("alphabet.txt").chars.reject do |ch|
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
      # TODO: In order to find ambiguous matches, change this to determine all
      # possible matches for each digit. Return the result as an array of
      # arrays, where the inner array contains each valid digit.
      #
      # Use that array of arrays in FileReport. Generate candidates, test them
      # using checksum, and stop when multiple valid candidates are found.
      @patterns[chars] || "?"
    end
    recognized_chars.join
  end
end

