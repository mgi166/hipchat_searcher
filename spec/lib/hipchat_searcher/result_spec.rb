require 'spec_helper'

describe HipchatSearcher::Result do
  def result(response)
    described_class.new(response)
  end

  describe '#room_list' do
    subject { result(response).room_list }
    let(:response) { eval File.read(path) }
    let(:path)     { File.join('spec', 'data', 'room-list.json') }

    it 'should return room names' do
      should == ["sample-1", "sample-2", "sample-3"]
    end
  end
end
