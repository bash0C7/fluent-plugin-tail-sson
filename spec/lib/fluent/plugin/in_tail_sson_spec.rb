require 'spec_helper'

describe do
  let(:tmp_dir) {File.dirname(__FILE__) + "/../tmp"}
  
  before do
    FileUtils.rm_rf(tmp_dir)
    Fluent::Test.setup
  end
  
  before :each do
    FileUtils.mkdir_p(tmp_dir)
    File.open("#{tmp_dir}/tail.txt", "w") {|f|
      f.puts "test1_a	test1_b"
      f.puts "test2"
    }
  end

  after :each do
    FileUtils.rm_rf(tmp_dir)
  end

  let(:config) {
    %[
    path #{tmp_dir}/tail.txt
    tag t1
    rotate_wait 2s
    pos_file #{tmp_dir}/tail.pos
    format sson
    ]
  }

  let(:emits) {
    d = Fluent::Test::InputTestDriver.new(Fluent::TailInput).configure(config)
    d.run do
      sleep 1

      File.open("#{tmp_dir}/tail.txt", "a") {|f|
        logs.each {|log| f.puts log}
      }
      sleep 1
    end
    
    d.emits
  }
  
  context 'Valid sson' do
    let(:logs) {
      [
        '(("time" 1362020400)("NAME" "KOSHIBA")("AGE" 32)("HOGE" "fuga"))',
        '(("NAME" "OOSHIBA")("AGE" 23)("FUGA" "hoge"))'
      ]
    }

    context 'time is exist in log' do
      context do
        subject {emits.first[1]}
        it{should == 1362020400}
      end

      context do
        subject {emits.first[2]}
        it{should == {"NAME"=>"KOSHIBA", "AGE"=>32, "HOGE"=>"fuga"}}
      end
    end
    
    context 'time is not exist in log' do
      context do
        subject {emits.last[1]} #current_time
        it{should_not == 1362020400}
      end

      context do
        subject {emits.last[2]}
        it{should == {"NAME"=>"OOSHIBA", "AGE"=>23, "FUGA"=>"hoge"}}
      end
    end
  end

  context 'Invalid sson' do
    let(:logs) {
      [
        '"time" 1362020400)("NAME" "KOSHIBA")("AGE" 32)("HOGE" "fuga"))',
        '"((time" 1362020400)("NAME" "KOSHIBA")("AGE" 32)("HOGE" "fuga"'
      ]
    }

    context do
      subject {emits.first}
      it{should be_nil}
    end
    context do
      subject {emits.last}
      it{should be_nil}
    end
  end

end
