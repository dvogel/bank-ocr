class AccountNumberGeometry
  def initialize(digits: 10)
    @char_width = digits * 3
  end

  # Returns an array of offsets into the grid that would represent the number
  # at the given position.
  def offsets(pos:)
    4.times.flat_map do |row|
      3.times.map do |col|
        (row * @char_width) + (pos * 3) + col
      end
    end
  end
end

