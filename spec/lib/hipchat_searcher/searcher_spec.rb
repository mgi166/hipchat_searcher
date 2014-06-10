require 'spec_helper'

describe HipchatSearcher::Searcher do
  def searcher(result)
    described_class.new(result)
  end

  describe '#search' do
    subject { searcher(result).search(pattern) }
    let(:result) { '' }
    let(:pattern) { 'abc' }

    it 'description' do
      p subject
    end
  end
end
