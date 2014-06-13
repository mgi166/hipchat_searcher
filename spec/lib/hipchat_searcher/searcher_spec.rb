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

      it 'should return matched messages' do
        should == ['yareyare daze']
      end
    end

    context "when don't match pattern in messages" do
      subject { searcher(result).search(pattern) }

      let(:pattern)  { 'abcd' }
      let(:result)   { HipchatSearcher::Result.new(response) }
      let(:response) { File.read(File.join('spec', 'data', 'message_list.json')) }

      it 'should return empty array' do
        should be_empty
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
end
