require 'minitest/autorun'
require 'stringio'
require_relative './account_number_reader'
require_relative './account_number_checksum'

class FileReport
  def initialize(path:)
    @path = path
  end

  def generate(outstream:)
    reader = AccountNumberReader.new
    csum = AccountNumberChecksum.new
    File.open(@path, 'r') do |instream|
      instream.each_line.each_slice(4) do |entry_text|
        acct_num = reader.recognize(text: entry_text.join)
        label =
          if acct_num.include?("?")
            "ILL"
          elsif !csum.verify(account_number: acct_num)
            "ERR"
          else
            ""
          end
        outstream.write("#{acct_num} #{label}\n")
      end
    end
    outstream.flush
    nil
  end
end

describe FileReport, "" do
  it "provides canonical output" do
    sink = StringIO.new
    @report = FileReport.new(path: "ex3.txt")
    @report.generate(outstream: sink)
    assert_equal "000000051 \n49006771? ILL\n1234?678? ILL\n664371495 ERR\n", sink.string
  end
end
