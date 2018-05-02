require 'minitest/autorun'
require_relative './account_number_reader'
require_relative './account_number_checksum'
require_relative './file_report'

describe AccountNumberReader do
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


describe AccountNumberChecksum do
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


describe FileReport do
  it "provides canonical output" do
    sink = StringIO.new
    @report = FileReport.new(path: "ex3.txt")
    @report.generate(outstream: sink)
    assert_equal "000000051 \n49006771? ILL\n1234?678? ILL\n664371495 ERR\n", sink.string
  end
end

