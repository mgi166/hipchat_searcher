require 'webmock/rspec'

describe HipchatSearcher::Room do
  describe '#get_all_room' do
    context 'with no options' do
      before do
        stub_request(:get, 'https://api.hipchat.com/v2/room?auth_token=abcde')
      end

      it 'should request to hipchat api' do
        room = described_class.new('abcde')
        room.get_all_room
      end
    end

    context 'when response code 400 from hipchat api' do
      before do
        stub_request(:get, 'https://api.hipchat.com/v2/room?auth_token=abcde')
          .to_return(status: 401)
      end

      it 'should raise error HipChat::Unauthorized' do
        room = described_class.new('abcde')
        expect do
          room.get_all_room
        end.to raise_error HipChat::Unauthorized
      end
    end

    context 'when response code 404 from hipchat api' do
      before do
        stub_request(:get, 'https://api.hipchat.com/v2/room?auth_token=abcde')
          .to_return(status: 404)
      end

      it 'should raise error HipChat::UnknownRoom' do
        room = described_class.new('abcde')
        expect do
          room.get_all_room
        end.to raise_error HipChat::UnknownRoom
      end
    end

    context 'when response code other type from hipchat api' do
      before do
        stub_request(:get, 'https://api.hipchat.com/v2/room?auth_token=abcde')
          .to_return(status: 400)
      end

      it 'should raise error HipChat::UnknownResponseCode' do
        room = described_class.new('abcde')
        expect do
          room.get_all_room
        end.to raise_error HipChat::UnknownResponseCode
      end
    end
  end
end
