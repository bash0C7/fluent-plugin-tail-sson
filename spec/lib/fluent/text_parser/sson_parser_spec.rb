require 'spec_helper'

describe Fluent::TextParser::SSONParser do
  describe '#call' do
    let(:result)    {described_class.new.call(text)}

    context 'Valid sson log' do
      let(:text) {'(("time" 1362020400)("NAME" "KOSHIBA")("AGE" 32)("HOGE" "fuga"))'}

      context do
        let(:time) {result.first}
        it {time.should == 1362020400}
      end
      context do
        let(:hash) {result.last}
        it do
          hash.size.should == 3
          hash['NAME'].should == 'KOSHIBA'
          hash['AGE'].should == 32
          hash['HOGE'].should == 'fuga'
        end
      end
    end

    context 'Invalid sson log' do
      let(:text) {'(("time" 1362020400)("NAME" "KOSHIBA")("AGE" 32)("HOGE" "fuga"'}

      context do
        subject {result.first}
        it {should be_nil}
      end
      context do
        subject {result.last}
        it {should be_nil}
      end
    end

  end
end
