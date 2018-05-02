require_relative './account_number_geometry'

# Utility class, mainly used from the repl to print out test case numbers. For example:
#
#   NumberPrinter.new.print(number: "3210987654", outstream: $stdout)
#
class NumberPrinter
  def initialize
    @alphabet_text = IO.read("alphabet.txt").chars.reject do |ch|
      ch == "\n"
    end
    @alphabet_geometry = AccountNumberGeometry.new(digits: 10)
  end
 
  def print(number:, outstream:)
    lines = 4.times.map do
      []
    end
    number.chars.each do |digit|
      chars = @alphabet_geometry.offsets(pos: digit.to_i).map do |offset|
        @alphabet_text[offset]
      end
      chars.each_slice(3).map(&:join).to_enum.with_index do |str, ix|
        lines[ix] << str
      end
    end

    lines.each do |ln|
      ln.each do |str|
        outstream.write(str)
      end
      outstream.write("\n")
    end
    nil
  end
end


