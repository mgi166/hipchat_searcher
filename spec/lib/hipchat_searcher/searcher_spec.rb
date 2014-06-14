require 'spec_helper'

describe HipchatSearcher::Searcher do
  def searcher(result)
    described_class.new(result)
  end

  describe '#search' do
    context 'when matches pattern in messages' do
      subject { searcher(result).search(pattern) }

      let(:pattern)  { 'yare' }
      let(:result)   { HipchatSearcher::Result.new(response) }
      let(:response) { File.read(File.join('spec', 'data', 'message_list.json')) }

      it 'should print matched string' do
        expect do
          subject
        end.to output("\e[4;39;49myare\e[0m\e[4;39;49myare\e[0m daze\n").to_stdout
      end
    end

    context "when don't match pattern in messages" do
      subject { searcher(result).search(pattern) }

      let(:pattern)  { 'abcd' }
      let(:result)   { HipchatSearcher::Result.new(response) }
      let(:response) { File.read(File.join('spec', 'data', 'message_list.json')) }

      it { should be_nil }

      it 'should no output to stdout' do
        expect do
          subject
        end.to output('').to_stdout
      end
    end

    context "when pattern can't convert regexp" do
      subject { searcher(result).search(pattern) }

      let(:pattern)  { nil }
      let(:result)   { HipchatSearcher::Result.new(response) }
      let(:response) { File.read(File.join('spec', 'data', 'message_list.json')) }

      it 'should raise exception' do
        expect do
          subject
        end.to raise_error
      end
    end
  end

  describe '#display' do
    subject { searcher(result).display(pattern, string) }

    let(:result) { double(:result) }
    let(:pattern) { 'fuga' }
    let(:string) { 'hogefugahoge' }

    it 'should add excape escape sequence on matched string' do
      should == "hoge\e[4;39;49mfuga\e[0mhoge"
    end
  end
end
