describe HipchatSearcher::SearchProxy::Grep do
  def searcher(pattern, result, options={})
    described_class.new(pattern, result, options)
  end

  describe '#items' do
    subject { searcher(pattern, result).items }

    let(:pattern) { 'hoge' }
    let(:result) do
      response = File.read(File.join('spec', 'data', 'item-list.json'))
      HipchatSearcher::Result.new(response)
    end

    it { should be_instance_of Array }

    it 'should return array with Hashie::Mash objects' do
      subject.first.should be_instance_of ::Hashie::Mash
      subject.last.should  be_instance_of ::Hashie::Mash
    end
  end

  describe '#around_items' do
    describe 'you speciy :before_context option' do
      context 'when specify the range is included in the array' do
        subject { searcher(pattern, result, before_context: '3').around_items(3) }

        let(:pattern) { 'fuga' }
        let(:result)  { double(:result, items: %w|1 2 3 4 5 6|) }

        it 'should return the array of range to include index you specify' do
          should == %w|1 2 3 4|
        end
      end

      context 'when specify the range is exluded in the array' do
        subject { searcher(pattern, result, before_context: '3').around_items(1) }

        let(:pattern) { 'fuga' }
        let(:result)  { double(:result, items: %w|1 2 3 4 5 6|) }

        it 'should return the array includes range until index from first' do
          should == %w|1 2|
        end
      end
    end

    describe 'you specify :after_context option' do
      context 'when specify the range is included in the array' do
        subject { searcher(pattern, result, after_context: '3').around_items(1) }

        let(:pattern) { 'fuga' }
        let(:result)  { double(:result, items: %w|1 2 3 4 5 6|) }

        it 'should return the array of range to include index you specify' do
          should == %w|2 3 4 5|
        end
      end

      context 'when specify the range is exluded in the array' do
        subject { searcher(pattern, result, after_context: '3').around_items(4) }

        let(:pattern) { 'fuga' }
        let(:result)  { double(:result, items: %w|1 2 3 4 5 6|) }

        it 'should return the array includes range until the end from index' do
          should == %w|5 6|
        end
      end
    end

    describe 'you specify :context option' do
      context 'when specify the range is included in the array' do
        subject { searcher(pattern, result, context: '2').around_items(3) }

        let(:pattern) { 'fuga' }
        let(:result)  { double(:result, items: %w|1 2 3 4 5 6|) }

        it 'should return the array of range to surround index you specify' do
          should == %w|2 3 4 5 6|
        end
      end

      context 'when specify the range is exluded in the array' do
        subject { searcher(pattern, result, context: '5').around_items(3) }

        let(:pattern) { 'fuga' }
        let(:result)  { double(:result, items: %w|1 2 3 4 5 6|) }

        it 'should return the array includes range to surround as much as possible' do
          should == %w|1 2 3 4 5 6|
        end
      end
    end
  end

  describe '#search' do
    context 'when search_option --before_context' do
      subject { searcher(pattern, result, before_context: '1').search }

      let(:pattern) { 'inu' }
      let(:result) do
        response = File.read(File.join('spec', 'data', 'item-list-with-overlap.json'))
        HipchatSearcher::Result.new(response).tap do |r|
          r.room = "Joestars"
        end
      end
      let(:search_result) do
        "\e[4;39;49mJoestars\e[0m" + "\n" + \
        "  Date: 2014-06-10T08:36:09.281643+00:00" + "\n" + \
        "  @abdul: chirp chirp chirp" + "\n" + \
        "\n" + \
        "  Date: 2014-06-11T19:20:47.726182+00:00" + "\n" + \
        "  @lggy: \e[0;31;49minu\e[0m zuki no kodomo ha migoroshiniha dekine-ze" + "\n" + \
        "\n"
      end

      it 'should print the matched message and after context' do
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
      let(:search_result) do
        "\e[4;39;49mJoestars\e[0m" + "\n" + \
        "  Date: 2014-05-30T01:39:02.186319+00:00" + "\n" + \
        "  @noriaki: \e[0;31;49mrero\e[0m\e[0;31;49mrero\e[0m" + "\n" + \
        "\n" + \
        "  Date: 2014-06-09T11:29:10.209014+00:00" + "\n" + \
        "  @polnareff: a... arinomama ima okotta koto wo hanasu ze" + "\n" + \
        "\n"
      end

      it 'should print the matched message and after context' do
        expect do
          subject
        end.to output(search_result).to_stdout
      end
    end

    context 'when search_option --context' do
      subject { searcher(pattern, result, context: '2').search }

      let(:pattern) { 'chirp' }
      let(:result) do
        response = File.read(File.join('spec', 'data', 'item-list-with-overlap.json'))
        HipchatSearcher::Result.new(response).tap do |r|
          r.room = "Joestars"
        end
      end
      let(:search_result) do
        "\e[4;39;49mJoestars\e[0m" + "\n" + \
        "  Date: 2014-05-30T01:39:02.186319+00:00" + "\n" + \
        "  @noriaki: rerorero" + "\n" + \
        "\n" + \
        "  Date: 2014-06-09T11:29:10.209014+00:00" + "\n" + \
        "  @polnareff: a... arinomama ima okotta koto wo hanasu ze" + "\n" + \
        "\n" + \
        "  Date: 2014-06-10T08:36:09.281643+00:00" + "\n" + \
        "  @abdul: \e[0;31;49mchirp\e[0m \e[0;31;49mchirp\e[0m \e[0;31;49mchirp\e[0m" + "\n" + \
        "\n" + \
        "  Date: 2014-06-11T19:20:47.726182+00:00" + "\n" + \
        "  @lggy: inu zuki no kodomo ha migoroshiniha dekine-ze" + "\n" + \
        "\n"
      end

      it 'should print the matched message and surround context' do
        expect do
          subject
        end.to output(search_result).to_stdout
      end
    end

    context 'when match result overlaped and specify search options' do
      subject { searcher(pattern, result, after_context: '2').search }

      let(:pattern) { 'ze' }
      let(:result) do
        response = File.read(File.join('spec', 'data', 'item-list-with-overlap.json'))
        HipchatSearcher::Result.new(response).tap do |r|
          r.room = "Joestars"
        end
      end
      let(:search_result) do
        "\e[4;39;49mJoestars\e[0m" + "\n" + \
        "  Date: 2014-05-30T01:38:16.741565+00:00" + "\n" + \
        "  @jotaro: yareyare da\e[0;31;49mze\e[0m" + "\n" + \
        "\n" + \
        "  Date: 2014-05-30T01:39:02.186319+00:00" + "\n" + \
        "  @noriaki: rerorero" + "\n" + \
        "\n" + \
        "  Date: 2014-06-09T11:29:10.209014+00:00" + "\n" + \
        "  @polnareff: a... arinomama ima okotta koto wo hanasu \e[0;31;49mze\e[0m" + "\n" + \
        "\n" + \
        "  Date: 2014-06-10T08:36:09.281643+00:00" + "\n" + \
        "  @abdul: chirp chirp chirp" + "\n" + \
        "\n" + \
        "  Date: 2014-06-11T19:20:47.726182+00:00" + "\n" + \
        "  @lggy: inu zuki no kodomo ha migoroshiniha dekine-\e[0;31;49mze\e[0m" + "\n" + \
        "\n"
      end

      it 'should print the matched message without overlap' do
        expect do
          subject
        end.to output(search_result).to_stdout
      end
    end
  end

  describe '#puts_search_result' do
    def extended_items(path, pattern)
      hash  = JSON.parse(File.read(path))
      items = ::Hashie::Mash.new(hash).items
      items.map do |itm|
        itm.extend(HipchatSearcher::ItemExtention).tap do |i|
          i.pattern = Regexp.new(pattern)
        end
      end
    end

    context 'when only person in room' do
      subject { searcher(pattern, result).puts_search_result(item) }

      let(:pattern) { 'yare' }
      let(:result)  { double(:result, room: 'Joestars') }
      let(:item) do
        path = File.join('spec', 'data', 'item-list.json')
        extended_items(path, pattern).first
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
        path = File.join('spec', 'data', 'item-list-with-bot.json')
        extended_items(path, pattern).first
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
        path = File.join('spec', 'data', 'item-list.json')
        extended_items(path, pattern).last
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
        path = File.join('spec', 'data', 'item-list.json')
        extended_items(path, pattern).first
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
end
