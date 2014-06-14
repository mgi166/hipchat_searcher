require 'spec_helper'

describe HipchatSearcher::Options do
  describe '#room?' do
    context 'description' do
      subject { described_class.new(hash) }
      let(:hash) { {'room' => 'room-name' } }

      it 'description' do
        p subject
      end
    end
  end
end
