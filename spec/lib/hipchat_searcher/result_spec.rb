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

  describe '#continue?' do
    context '#when items size less than 100' do
      subject { result(response).continue? }

      let(:response) { File.read(path) }
      let(:path) { File.join('spec', 'data', 'item-list.json') }

      it { should be_falsey }
    end

    context 'when items size equal 100' do
      subject { result(response).continue? }

      let(:response) { File.read(path) }
      let(:path) { File.join('spec', 'data', 'item-list-100.json') }

      it { should be_truthy }
    end
  end

  describe '#items' do
    context 'the value' do
      subject { result(response).items }

      let(:response) { File.read(path) }
      let(:path)     { File.join('spec', 'data', 'item-list.json') }

      it { should be_instance_of Array }
    end

    describe 'the item elements' do
      let(:item_element) { result(response).items.first }
      let(:response) { File.read(path) }
      let(:path)     { File.join('spec', 'data', 'item-list.json') }

      context 'class' do
        subject { item_element }

        it { should be_instance_of Hashie::Mash }
      end

      context '#date' do
        subject { item_element.date }

        it 'should return the value of "date"' do
          should == '2014-05-30T01:38:16.741565+00:00'
        end
      end

      context '#from' do
        subject { item_element.from }

        it { should be_instance_of Hashie::Mash }
      end

      context '#id' do
        subject { item_element.id }

        it 'should return the value of "id"' do
          should == 'aaaa-bbbb-cccc'
        end
      end

      context '#mentions' do
        subject { item_element.mentions }

        it 'should return the value of "mention" ' do
          should == []
        end
      end

      context '#item' do
        subject { item_element.message }

        it 'should return the value of "message"' do
          should == 'yareyare daze'
        end
      end
    end
  end

  describe '#rooms' do
    context 'the value' do
      subject { result(response).rooms }

      let(:response) { eval File.read(path) }
      let(:path)     { File.join('spec', 'data', 'room-list.txt') }

      it { should be_instance_of Array }
    end

    context 'the element' do
      let(:rooms)    { result(response).rooms.first }
      let(:response) { eval File.read(path) }
      let(:path)     { File.join('spec', 'data', 'room-list.txt') }

      it { rooms.should be_instance_of ::Hashie::Mash }

      it 'should have keys "id", "links", "name"' do
        rooms.keys.should == ['id', 'links', 'name']
      end
    end
  end
end
