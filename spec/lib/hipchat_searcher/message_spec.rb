require 'webmock/rspec'

describe HipchatSearcher::Message do
  def stub_request_with_headers(uri)
    stub_request(:get, uri).with(headers: headers)
  end

  let(:headers) do
    {
      'Accept'       => 'application/json',
      'Content-Type' => 'application/json',
    }
  end

  describe '#get_history' do
    context 'with no options' do
      before do
        stub_request_with_headers('https://api.hipchat.com/v2/room/id-12345/history?auth_token=abcd&date=recent&format=JSON&room_id=id-12345&timezone=UTC')
      end

      it 'should request to hipchat-api with default option of hipchat api' do
        message = described_class.new('abcd')
        message.get_history('id-12345', {})
      end
    end

    context 'with options' do
      before do
        stub_request_with_headers('https://api.hipchat.com/v2/room/id-12345/history?auth_token=abcd&date=2014-07-12&format=JSON&room_id=id-12345&timezone=JST')
      end

      it 'should request to hipchat-api with option overridden of hipchat api' do
        message = described_class.new('abcd')
        message.get_history('id-12345', {date: '2014-07-12', timezone: 'JST'})
      end
    end

    context 'when id must be escaped' do
      before do
        stub_request_with_headers('https://api.hipchat.com/v2/room/id%2012345/history?auth_token=abcd&date=recent&format=JSON&room_id=id%2012345&timezone=UTC')
      end

      it 'should request to url that is escaped' do
        message = described_class.new('abcd')
        message.get_history('id 12345', {})
      end
    end
  end

  describe '#history' do
    before do
      stub_request_with_headers('https://api.hipchat.com/v2/room/id-12345/history?auth_token=abcd&date=recent&format=JSON&room_id=id-12345&timezone=UTC').to_return(body: response)
    end

    let(:response) do
      path = File.join('spec', 'data', 'item-list.json')
      File.read(path)
    end

    it 'should return HipchatSearcher::Result instance' do
      message  = described_class.new('abcd')
      response = message.history('id-12345')
      response.should be_instance_of HipchatSearcher::Result
    end

    it 'when arguments is String should return the room name the same string of arguments' do
      message  = described_class.new('abcd')
      response = message.history('id-12345')
      response.room.should == 'id-12345'
    end

    it 'when arguments is Hashie::Mash object should return the room name objects given' do
      room     = Hashie::Mash.new(id: 'id-12345', name: 'room1')
      message  = described_class.new('abcd')
      response = message.history(room)
      response.room.should == 'room1'
    end
  end
end
