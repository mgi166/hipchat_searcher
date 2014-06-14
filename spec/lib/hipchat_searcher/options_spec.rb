require 'spec_helper'

describe HipchatSearcher::Options do
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
end
