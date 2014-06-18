require 'spec_helper'

describe HipchatSearcher::Searcher do
  def searcher(result)
    described_class.new(result)
  end

  describe '#search' do
    context 'when matches pattern in messages' do
      subject { searcher(result).search(pattern) }

      let(:pattern)  { 'yare' }
      let(:response) { File.read(File.join('spec', 'data', 'item-list.json')) }
      let(:result) do
        r = HipchatSearcher::Result.new(response)
        r.room = "Joestars"
        r
      end
      let(:search_result) do
        "Joestars" + "\n" + \
        "  Date: 2014-05-30T01:38:16.741565+00:00" + "\n" + \
        "  @jotaro: \e[4;39;49myare\e[0m\e[4;39;49myare\e[0m daze" + "\n" + \
        "\n"
      end

      it 'should print roomname & search result' do
        expect do
          subject
        end.to output(search_result).to_stdout
      end
    end

    context 'when matches pattern in many messages' do
      subject { searcher(result).search(pattern) }

      let(:pattern)  { 'ze' }
      let(:response) { File.read(File.join('spec', 'data', 'item-list.json')) }
      let(:result) do
        r = HipchatSearcher::Result.new(response)
        r.room = "Joestars"
        r
      end
      let(:search_result) do
        "Joestars" + "\n" + \
        "  Date: 2014-05-30T01:38:16.741565+00:00" + "\n" + \
        "  @jotaro: yareyare da\e[4;39;49mze\e[0m" + "\n" \
        "\n" + \
        "  Date: 2014-06-09T11:29:10.209014+00:00" + "\n" + \
        "  @polnareff: a... arinomama ima okotta koto wo hanasu \e[4;39;49mze\e[0m" + "\n" + \
        "\n"
      end

      it 'should print roomname & search result' do
        expect do
          subject
        end.to output(search_result).to_stdout
      end
    end

    context "when don't match pattern in messages" do
      subject { searcher(result).search(pattern) }

      let(:pattern)  { 'abcd' }
      let(:result)   { HipchatSearcher::Result.new(response) }
      let(:response) { File.read(File.join('spec', 'data', 'item-list.json')) }

      it { should be_nil }

      it 'should no output to stdout' do
        expect do
          subject
        end.to output('').to_stdout
      end
    end

    context "when pattern can't convert regexp" do
      subject { searcher(result).search(pattern) }

      let(:pattern)  { nil }
      let(:result)   { HipchatSearcher::Result.new(response) }
      let(:response) { File.read(File.join('spec', 'data', 'item-list.json')) }

      it 'should raise exception' do
        expect do
          subject
        end.to raise_error
      end
    end
  end

  describe '#puts_search_result' do
    subject { searcher(double(:result)).puts_search_result(pattern, item) }

    let(:pattern) { Regexp.new('yare') }
    let(:item) do
      src  = File.read(File.join('spec', 'data', 'item-list.json'))
      hash = JSON.parse(src)
      ::Hashie::Mash.new(hash).items.first
    end

    let(:search_result) do
      "  Date: 2014-05-30T01:38:16.741565+00:00" + "\n" + \
      "  @jotaro: \e[4;39;49myare\e[0m\e[4;39;49myare\e[0m daze" + "\n"
    end

    it 'should print string of search result' do
      expect do
        subject
      end.to output(search_result).to_stdout
    end
  end
end
