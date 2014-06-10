require 'spec_helper'

describe HipchatSearcher::Result do
  def result(response)
    described_class.new(response)
  end

  describe '#room_list' do
    subject { result(response).room_list }

    let(:response) { eval File.read(path) }
    let(:path)     { File.join('spec', 'data', 'room-list.txt') }

    it 'should return room names' do
      should == ["sample-1", "sample-2", "sample-3"]
    end
  end

  describe '#message_list' do
    subject { result(response).message_list }

    let(:response) { File.read(path) }
    let(:path)     { File.join('spec', 'data', 'message_list.json') }

    it 'should be return messages' do
      should == ["yareyare daze", "rerorero", "a... arinomama ima okotta koto wo hanasu ze"]
    end
  end
end
