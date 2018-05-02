require 'minitest/autorun'

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

describe AccountNumberChecksum, "" do
  before do
    @calc = AccountNumberChecksum.new
  end

  it "canonical example" do
    account_number = "345882865"
    csum = @calc.calculate(account_number: account_number)
    assert_equal 231, csum

    is_valid = @calc.verify(account_number: account_number)
    assert_equal true, is_valid
  end

  it "user story 3" do
    account_number = "664371495"
    csum = @calc.calculate(account_number: account_number)
    assert_equal 222, csum

    is_valid = @calc.verify(account_number: account_number)
    assert_equal false, is_valid
  end

  it "OCR example" do
    account_number = "123456789"
    csum = @calc.calculate(account_number: account_number)
    assert_equal 165, csum

    is_valid = @calc.verify(account_number: account_number)
    assert_equal true, is_valid
  end

  it "all zeroes" do
    account_number = "000000000"
    csum = @calc.calculate(account_number: account_number)
    assert_equal 0, csum

    is_valid = @calc.verify(account_number: account_number)
    assert_equal true, is_valid
  end

  it "all ones" do
    account_number = "111111111"
    csum = @calc.calculate(account_number: account_number)
    assert_equal 45, csum

    is_valid = @calc.verify(account_number: account_number)
    assert_equal false, is_valid
  end
end

