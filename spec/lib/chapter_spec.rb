require 'spec_helper'

describe BibleBot::Chapter do
  describe "from_id" do
    [
      {id: 1_001, expected: "Genesis 1"},
      {id: 1_050, expected: "Genesis 50"},
      {id: 19_150, expected: "Psalm 150"},
      {id: 66_020, expected: "Revelation 20"},
      {id: 67_001, expected: nil},
    ].each do |t|
      context "id=#{t[:id]}" do
        it "It finds #{t[:expected]}" do
          chapter = described_class.from_id(t[:id])

          if t[:expected] == nil
            expect(chapter).to be nil
          else
            expect(chapter).to be_a BibleBot::Chapter
            expect(chapter.to_s).to eq t[:expected]
          end
        end
      end
    end
  end

  describe "reference" do
    let(:chapter) { BibleBot::Chapter.from_id(62_001) }

    it "returns reference" do
      expect(chapter.reference.inspect).to include(start_verse: "1 John 1:1", end_verse: "1 John 1:10")
    end
  end

  describe "last_chatper_in_book?" do
    it "returns false for Genesis 49" do
      expect(BibleBot::Chapter.from_id(1_049).last_chapter_in_book?).to be(false)
    end

    it "returns  true for Genesis 50" do
      expect(BibleBot::Chapter.from_id(1_050).last_chapter_in_book?).to be(true)
    end
  end
end
