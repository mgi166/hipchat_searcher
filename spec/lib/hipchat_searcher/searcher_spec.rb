require 'spec_helper'

describe HipchatSearcher::Searcher do
  def searcher(pattern, result, options={})
    described_class.new(pattern, result, options)
  end

  describe '#search' do
    context 'when matches pattern in messages' do
      subject { searcher(pattern, result).search }

      let(:pattern)  { 'yare' }
      let(:result) do
        response = File.read(File.join('spec', 'data', 'item-list.json'))
        HipchatSearcher::Result.new(response).tap do |r|
          r.room = "Joestars"
        end
      end
      let(:search_result) do
        "\e[4;39;49mJoestars\e[0m" + "\n" + \
        "  Date: 2014-05-30T01:38:16.741565+00:00" + "\n" + \
        "  @jotaro: \e[0;31;49myare\e[0m\e[0;31;49myare\e[0m daze" + "\n" + \
        "\n"
      end

      it 'should print roomname & search result' do
        expect do
          subject
        end.to output(search_result).to_stdout
      end
    end

    context 'when matches pattern in many messages' do
      subject { searcher(pattern, result).search }

      let(:pattern)  { 'ze' }
      let(:result) do
        response = File.read(File.join('spec', 'data', 'item-list.json'))
        HipchatSearcher::Result.new(response).tap do |r|
          r.room = "Joestars"
        end
      end
      let(:search_result) do
        "\e[4;39;49mJoestars\e[0m" + "\n" + \
        "  Date: 2014-05-30T01:38:16.741565+00:00" + "\n" + \
        "  @jotaro: yareyare da\e[0;31;49mze\e[0m" + "\n" \
        "\n" + \
        "  Date: 2014-06-09T11:29:10.209014+00:00" + "\n" + \
        "  @polnareff: a... arinomama ima okotta koto wo hanasu \e[0;31;49mze\e[0m" + "\n" + \
        "\n"
      end

      it 'should print roomname & search result' do
        expect do
          subject
        end.to output(search_result).to_stdout
      end
    end

    context 'when search_option --after_context' do
      subject { searcher(pattern, result, after_context: '1').search }

      let(:pattern) { 'rero' }
      let(:result) do
        response = File.read(File.join('spec', 'data', 'item-list-with-overlap.json'))
        HipchatSearcher::Result.new(response).tap do |r|
          r.room = "Joestars"
        end
      end

      it 'should print the matched message and after context' do
      end
    end

    context "when don't match pattern in messages" do
      subject { searcher(pattern, result).search }

      let(:pattern) { 'abcd' }
      let(:result) do
        response = File.read(File.join('spec', 'data', 'item-list.json'))
        HipchatSearcher::Result.new(response)
      end

      it { should be_nil }

      it 'should no output to stdout' do
        expect do
          subject
        end.to output('').to_stdout
      end
    end

    context "when pattern can't convert regexp" do
      subject { searcher(pattern, result).search }

      let(:pattern) { nil }
      let(:result) do
        response = File.read(File.join('spec', 'data', 'item-list.json'))
        HipchatSearcher::Result.new(response)
      end

      it 'should raise exception' do
        expect do
          subject
        end.to raise_error
      end
    end
  end

  describe '#puts_search_result' do
    context 'when only person in room' do
      subject { searcher(pattern, result).puts_search_result(item) }

      let(:pattern) { 'yare' }
      let(:result)  { double(:result, room: 'Joestars') }
      let(:item) do
        src  = File.read(File.join('spec', 'data', 'item-list.json'))
        hash = JSON.parse(src)
        ::Hashie::Mash.new(hash).items.first
      end

      let(:search_result) do
        "\e[4;39;49mJoestars\e[0m" + "\n" + \
        "  Date: 2014-05-30T01:38:16.741565+00:00" + "\n" + \
        "  @jotaro: \e[0;31;49myare\e[0m\e[0;31;49myare\e[0m daze" + "\n" + \
        "\n"
      end

      it 'should print message of search result' do
        expect do
          subject
        end.to output(search_result).to_stdout
      end
    end

    context 'when person and bot in room' do
      subject { searcher(pattern, result).puts_search_result(item) }

      let(:pattern) { 'mgi166' }
      let(:result)  { double(:result, room: 'Joestars') }
      let(:item) do
        src  = File.read(File.join('spec', 'data', 'item-list-with-bot.json'))
        hash = JSON.parse(src)
        ::Hashie::Mash.new(hash).items.first
      end

      let(:search_result) do
        "\e[4;39;49mJoestars\e[0m" + "\n" + \
        '  Date: 2014-06-17T08:14:48.305590+00:00' + "\n" + \
        "  @GitHub: \e[0;31;49mmgi166\e[0m commented on pull request 118 ..." + "\n\n"
      end

      it 'should print message of search result' do
        expect do
          subject
        end.to output(search_result).to_stdout
      end
    end

    context "when user options specified but the user don't speak this message" do
      subject { searcher(pattern, result, user: 'jotaro').puts_search_result(item) }

      let(:pattern) { 'ze' }
      let(:result)  { double(:result, room: 'Joestars') }
      let(:item) do
        src  = File.read(File.join('spec', 'data', 'item-list.json'))
        hash = JSON.parse(src)
        ::Hashie::Mash.new(hash).items.last
      end

      it 'should not print message' do
        expect do
          subject
        end.to output('').to_stdout
      end
    end

    context "when user options specified and the user speak this message" do
      subject { searcher(pattern, result, user: 'jotaro').puts_search_result(item) }

      let(:pattern) { 'ze' }
      let(:result)  { double(:result, room: 'Joestars') }
      let(:item) do
        src  = File.read(File.join('spec', 'data', 'item-list.json'))
        hash = JSON.parse(src)
        ::Hashie::Mash.new(hash).items.first
      end

      let(:search_result) do
        "\e[4;39;49mJoestars\e[0m" + "\n" + \
        "  Date: 2014-05-30T01:38:16.741565+00:00" + "\n" + \
        "  @jotaro: yareyare da\e[0;31;49mze\e[0m" + "\n" \
        "\n"
      end

      it 'should print message for specified user' do
        expect do
          subject
        end.to output(search_result).to_stdout
      end
    end
  end

  describe '#contents' do
    subject { searcher(pattern, result).contents(item) }

    let(:pattern) { 'ze' }
    let(:result)  { double(:result) }
    let(:item) do
      src  = File.read(File.join('spec', 'data', 'item-list.json'))
      hash = JSON.parse(src)
      ::Hashie::Mash.new(hash).items.first
    end

    it 'should return string for search result contents' do
      should == "  Date: 2014-05-30T01:38:16.741565+00:00" + "\n" + \
                "  @jotaro: yareyare da\e[0;31;49mze\e[0m" + "\n" \
                "\n"
    end
  end
end
