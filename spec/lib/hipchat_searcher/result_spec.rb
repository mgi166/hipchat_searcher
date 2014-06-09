require 'spec_helper'

describe HipchatSearcher::Result do
  def result(response)
    described_class.new(response)
  end

  describe '#room_list' do
    subject { result(response).room_list }
    let(:response) { File.read('spec', 'data', 'room-list.json') }

    it 'should return room names' do
      should == []
    end
  end
end
