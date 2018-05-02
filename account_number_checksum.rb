class AccountNumberChecksum
  StandardLength = 9
  MinChar = "0".ord
  MaxChar = "9".ord

  def calculate(account_number:)
    csum = 0
    account_number.chars.each_with_index do |ch, ix|
      if ch.ord >= MinChar && ch.ord <= MaxChar
        coeff = StandardLength - ix
        csum += (coeff * ch.to_i)
      end
    end
    csum
  end

  def verify(account_number:)
    calculate(account_number: account_number) % 11 == 0
  end
end


