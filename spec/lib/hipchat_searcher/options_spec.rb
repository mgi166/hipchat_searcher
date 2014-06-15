require 'spec_helper'

describe HipchatSearcher::Options do
  describe '#message_options' do
    context 'when self has "archived" key' do
      subject { described_class.new(hash).message_options }
      let(:hash) { {'d' => '2014-06-01' } }

      it 'should return hash include key "include-archived"' do
        should == { 'date' => '2014-06-01' }
      end
    end

    context "when self don't have 'archived' key" do
      subject { described_class.new(hash).message_options }
      let(:hash) { {'room' => 'room-name' } }

      it 'should return empty hash' do
        should be_empty
      end
    end
  end

  describe '#room_options' do
    context 'when self has "archived" key' do
      subject { described_class.new(hash).room_options }
      let(:hash) { {'archived' => true } }

      it 'should return hash include key "include-archived"' do
        should == {"include-archived" => true}
      end
    end

    context "when self don't have 'archived' key" do
      subject { described_class.new(hash).room_options }
      let(:hash) { {'d' => '2014-06-01' } }

      it 'should return empty hash' do
        should be_empty
      end
    end
  end

  describe '#room?' do
    context 'given hash has a "room" key as argument' do
      subject { described_class.new(hash).room? }
      let(:hash) { {'room' => 'room-name' } }

      it { should be_truthy }
    end

    context 'given hash has a "r" key as argument' do
      subject { described_class.new(hash).room? }
      let(:hash) { {'r' => 'room-name' } }

      it { should be_truthy }
    end

    context 'given hash have any other keys as argument' do
      subject { described_class.new(hash).room? }
      let(:hash) { {'other' => 'xxxx' } }

      it { should be_falsey }
    end
  end

  describe '#user?' do
    context 'given hash has a "user" key as argument' do
      subject { described_class.new(hash).user? }
      let(:hash) { {'user' => 'jotaro kujo' } }

      it { should be_truthy }
    end

    context 'given hash has a "u" key as argument' do
      subject { described_class.new(hash).user? }
      let(:hash) { {'u' => 'jojo' } }

      it { should be_truthy }
    end

    context 'given hash have any other keys as argument' do
      subject { described_class.new(hash).user? }
      let(:hash) { {'other' => 'xxxx' } }

      it { should be_falsey }
    end
  end

  describe '#date?' do
    context 'given hash has a "date" key as argument' do
      subject { described_class.new(hash).date? }
      let(:hash) { {'date' => '2014-06-1' } }

      it { should be_truthy }
    end

    context 'given hash has a "u" key as argument' do
      subject { described_class.new(hash).date? }
      let(:hash) { {'d' => '2014-06-1' } }

      it { should be_truthy }
    end

    context 'given hash have any other keys as argument' do
      subject { described_class.new(hash).date? }
      let(:hash) { {'other' => 'xxxx' } }

      it { should be_falsey }
    end
  end
end
