require 'spec_helper'

describe HipchatSearcher::Result do
  def result(response)
    described_class.new(response)
  end

  describe '#new' do
    describe 'given valid response(a json like string)' do
      subject { result(response) }

      let(:response) { '{"google":"value1", "twitter":"value2"}' }

      it { should be_instance_of HipchatSearcher::Result }
    end

    describe 'given valid response(hash has key "items")' do
      subject { result(response) }

      let(:response) do
        {'items' => ['a', 'b', 'c'], 'links'=>'http://sample.co.jp', 'maxResult'=>100, 'startIndex'=>0}
      end

      it { should be_instance_of HipchatSearcher::Result }
    end

    describe 'given empty string as response' do
      subject { result(response) }

      let(:response) { '' }

      it 'should raise error' do
        expect do
          subject
        end.to raise_error(HipchatSearcher::Result::InvalidResponse)
      end
    end

    describe 'given a hash without "items" key as response' do
      subject { result(response) }

      let(:response) { {} }

      it 'should raise error' do
        expect do
          subject
        end.to raise_error(HipchatSearcher::Result::InvalidResponse)
      end
    end

    describe 'given other object as response' do
      subject { result(response) }

      let(:response) { nil }

      it 'should raise error' do
        expect do
          subject
        end.to raise_error(HipchatSearcher::Result::InvalidResponse)
      end
    end
  end

  describe '#room_list' do
    subject { result(response).room_list }

    let(:response) { eval File.read(path) }
    let(:path)     { File.join('spec', 'data', 'room-list.txt') }

    it { should be_instance_of Array }

    it 'should return room names' do
      should == ["sample-1", "sample-2", "sample-3"]
    end
  end

  describe '#message_list' do
    subject { result(response).message_list }

    let(:response) { File.read(path) }
    let(:path)     { File.join('spec', 'data', 'message_list.json') }

    it { should be_instance_of Array }

    it 'should be return messages' do
      should == ["yareyare daze", "rerorero", "a... arinomama ima okotta koto wo hanasu ze"]
    end
  end
end
