require 'spec_helper'

describe Renderable, '#render' do
  before { subject.render('spec/renderable/example.conf.erb') }
  subject { Renderable.new(tmp_prefix / 'example.conf') }
  it "should have added the prefix" do
    (tmp_prefix / 'example.conf').read.should =~
      /# Generated by babushka-[\d\.]+ at [\d\-\:\s+]+, from [0-9a-f]{40}+\. [0-9a-f]{40}/
  end
  it "should have interpolated the erb" do
    (tmp_prefix / 'example.conf').read.should =~ /root #{tmp_prefix};/
  end
  describe Renderable, "#clean?" do
    it "should be clean" do
      subject.should be_clean
    end
    context "after shitting up the file" do
      before {
        shell "echo lulz >> #{subject.path}"
      }
      it "should not be clean" do
        subject.should_not be_clean
      end
    end
  end
end
