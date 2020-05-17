require 'spec_helper'

describe BibleBot::Reference do
  describe "parse" do
    test_cases = [
      {ref: "Matthew 1:1 - Mark 4:2", expected: ["Matthew 1:1-Mark 4:2"]},
      {ref: "Matthew 2 - Mark 4", expected: ["Matthew 2-Mark 4"]},
      {ref: "John 1:1", expected: ["John 1:1"]},
      {ref: "John 1:1 is the first first but Romans 8:9-10 is another.", expected: ["John 1:1", "Romans 8:9-10"]},
      {ref: "When Fiery Trials Come Genesis 35:16-29 Part 1", expected: ["Genesis 35:16-29"]},
      {ref: "No book to see here 4:5", expected: []},
      {ref: "Rom 1:6", expected: ["Romans 1:6"]},
      {ref: "Romans 1:6", expected: ["Romans 1:6"]},
      {ref: "Rm 1:8", expected: ["Romans 1:8"]},
      {ref: "Ge 1:1", expected: ["Genesis 1:1"]},
      {ref: "Gen 1:1", expected: ["Genesis 1:1"]},
      {ref: "Genesis", expected: []},
      {ref: "Genesis 5", expected: ["Genesis 5"]},
      {ref: "Genesis 5-10", expected: ["Genesis 5-10"]},
      {ref: "Genesis 1:1 - Exod 4", expected: ["Genesis 1-Exodus 4"]},
      {ref: "Genesis 3 - Genesis 4:3", expected: ["Genesis 3:1-4:3"]},
      {ref: "Ex", expected: []},
      {ref: "something 1 Genesis 1:1", expected: ["Genesis 1:1"]},
      {ref: "something 1 Exodus 1:1", expected: ["Exodus 1:1"]},
      {ref: "something 1 Leviticus 1:1", expected: ["Leviticus 1:1"]},
      {ref: "something 1 Numbers 1:1", expected: ["Numbers 1:1"]},
      {ref: "something 1 Deuteronomy 1:1", expected: ["Deuteronomy 1:1"]},
      {ref: "something 1 Joshua 1:1", expected: ["Joshua 1:1"]},
      {ref: "something 1 Judges 1:1", expected: ["Judges 1:1"]},
      {ref: "something 1 Ruth 1:1", expected: ["Ruth 1:1"]},
      {ref: "something 1 1 Samuel 1:1", expected: ["1 Samuel 1:1"]},
      {ref: "something 1 2 Samuel 1:1", expected: ["2 Samuel 1:1"]},
      {ref: "something 1 1 Kings 1:1", expected: ["1 Kings 1:1"]},
      {ref: "something 1 2 Kings 1:1", expected: ["2 Kings 1:1"]},
      {ref: "something 1 1 Chronicles 1:1", expected: ["1 Chronicles 1:1"]},
      {ref: "something 1 2 Chronicles 1:1", expected: ["2 Chronicles 1:1"]},
      {ref: "something 1 Ezra 1:1", expected: ["Ezra 1:1"]},
      {ref: "something 1 Nehemiah 1:1", expected: ["Nehemiah 1:1"]},
      {ref: "something 1 Esther 1:1", expected: ["Esther 1:1"]},
      {ref: "something 1 Job 1:1", expected: ["Job 1:1"]},
      {ref: "something 1 Psalms 1:1", expected: ["Psalm 1:1"]},
      {ref: "something 1 Proverbs 1:1", expected: ["Proverbs 1:1"]},
      {ref: "something 1 Ecclesiastes 1:1", expected: ["Ecclesiastes 1:1"]},
      {ref: "something 1 Song of Solomon 1:1", expected: ["Song of Solomon 1:1"]},
      {ref: "something 1 Isaiah 1:1", expected: ["Isaiah 1:1"]},
      {ref: "something 1 Jeremiah 1:1", expected: ["Jeremiah 1:1"]},
      {ref: "something 1 Lamentations 1:1", expected: ["Lamentations 1:1"]},
      {ref: "something 1 Ezekiel 1:1", expected: ["Ezekiel 1:1"]},
      {ref: "something 1 Daniel 1:1", expected: ["Daniel 1:1"]},
      {ref: "something 1 Hosea 1:1", expected: ["Hosea 1:1"]},
      {ref: "something 1 Joel 1:1", expected: ["Joel 1:1"]},
      {ref: "something 1 Amos 1:1", expected: ["Amos 1:1"]},
      {ref: "something 1 Obadiah 1:1", expected: ["Obadiah 1"]},
      {ref: "something 1 Jonah 1:1", expected: ["Jonah 1:1"]},
      {ref: "something 1 Micah 1:1", expected: ["Micah 1:1"]},
      {ref: "something 1 Nahum 1:1", expected: ["Nahum 1:1"]},
      {ref: "something 1 Habakkuk 1:1", expected: ["Habakkuk 1:1"]},
      {ref: "something 1 Zephaniah 1:1", expected: ["Zephaniah 1:1"]},
      {ref: "something 1 Haggai 1:1", expected: ["Haggai 1:1"]},
      {ref: "something 1 Zechariah 1:1", expected: ["Zechariah 1:1"]},
      {ref: "something 1 Malachi 1:1", expected: ["Malachi 1:1"]},
      {ref: "something 1 Matthew 1:1", expected: ["Matthew 1:1"]},
      {ref: "something 1 Mark 1:1", expected: ["Mark 1:1"]},
      {ref: "something 1 Luke 1:1", expected: ["Luke 1:1"]},
      {ref: "something 4 John 1:1", expected: ["John 1:1"]},
      {ref: "something 1 Acts 1:1", expected: ["Acts 1:1"]},
      {ref: "something 1 Romans 1:1", expected: ["Romans 1:1"]},
      {ref: "something 1 1 Corinthians 1:1", expected: ["1 Corinthians 1:1"]},
      {ref: "something 1 2 Corinthians 1:1", expected: ["2 Corinthians 1:1"]},
      {ref: "something 1 Galatians 1:1", expected: ["Galatians 1:1"]},
      {ref: "something 1 Ephesians 1:1", expected: ["Ephesians 1:1"]},
      {ref: "something 1 Philippians 1:1", expected: ["Philippians 1:1"]},
      {ref: "something 1 Colossians 1:1", expected: ["Colossians 1:1"]},
      {ref: "something 1 1 Thessalonians 1:1", expected: ["1 Thessalonians 1:1"]},
      {ref: "something 1 2 Thessalonians 1:1", expected: ["2 Thessalonians 1:1"]},
      {ref: "something 1 1 Timothy 1:1", expected: ["1 Timothy 1:1"]},
      {ref: "something 1 2 Timothy 1:1", expected: ["2 Timothy 1:1"]},
      {ref: "something 1 Titus 1:1", expected: ["Titus 1:1"]},
      {ref: "something 1 Philemon 1:1", expected: ["Philemon 1"]},
      {ref: "something 1 Hebrews 1:1", expected: ["Hebrews 1:1"]},
      {ref: "something 1 James 1:1", expected: ["James 1:1"]},
      {ref: "something 1 1 Peter 1:1", expected: ["1 Peter 1:1"]},
      {ref: "something 1 2 Peter 1:1", expected: ["2 Peter 1:1"]},
      {ref: "something 1 1 John 1:1", expected: ["1 John 1:1"]},
      {ref: "something 1 2 John 1:1", expected: ["2 John 1"]},
      {ref: "something 1 3 John 1:1", expected: ["3 John 1"]},
      {ref: "something 1 Jude 1:1", expected: ["Jude 1"]},
      {ref: "something 1 Jude 5", expected: ["Jude 5"]},
      {ref: "something 1 Revelation 1:1", expected: ["Revelation 1:1"]},
    ]

    test_cases.each do |t|
      it "Can parse #{t[:ref]}" do
        expect( Reference.parse( t[:ref] ).map(&:formatted) ).to eq t[:expected]
      end
    end

    describe "invalid references" do
      invalid_references = [
        ["Genesis 51:4", BibleBot::InvalidVerseError],
        ["Rom 1:99", BibleBot::InvalidVerseError],
        ["Rom 0:1", BibleBot::InvalidVerseError],
        ["Rom 1:0", BibleBot::InvalidVerseError],
        ["Romans 5:2-4:11", BibleBot::InvalidReferenceError],
      ]

      invalid_references.each do |ref, expected_error|
        it "raises error when parsing #{ref}" do
          expect{ Reference.parse(ref) }.to raise_error(expected_error)
        end
      end

      context "ignore_errors=true" do
        # TODO: Look into why it is matching the Genesis ref twice
        let(:ref) { "Genesis 51:4 and Psalm 1:1-4 and Rom 1:99 are not all valid references" }
        it "ignores errors" do
          expect{ Reference.parse(ref) }.to raise_error(BibleBot::InvalidVerseError)
          expect( Reference.parse(ref, ignore_errors: true).map(&:formatted) ).to eq(['Psalm 1:1-4'])
        end
      end
    end
  end

  describe "formatted" do
    [
      [1_001_001, nil, "Genesis 1:1"],
      [1_001_001, 1_001_001, "Genesis 1:1"],
      [1_001_001, 1_001_030, "Genesis 1:1-30"],
      [1_001_001, 1_001_031, "Genesis 1"], # Leaves out verses when range includes the entire chapter
      [1_001_001, 1_002_004, "Genesis 1:1-2:4"],
      [1_001_001, 1_002_025, "Genesis 1-2"],
      [1_002_003, 1_003_003, "Genesis 2:3-3:3"],
      [65_001_001, 65_001_006, "Jude 1-6"],
      [65_001_001, 65_001_025, "Jude"],
      [65_001_001, 66_001_015, "Jude 1-Revelation 1:15"],
      [1_050_001, 2_002_013, "Genesis 50:1-Exodus 2:13"],
      [1_001_001, 2_001_001, "Genesis 1:1-Exodus 1:1"],
    ].each do |start_verse_id, end_verse_id, expected_formated_value|
      describe "start_verse_id=#{start_verse_id} and end_verse_id=#{end_verse_id}" do
        subject { described_class.from_verse_ids(start_verse_id, end_verse_id).formatted }
        it { is_expected.to eq expected_formated_value }
      end
    end
  end

  describe "verses" do
    [
      [1_001_001, nil, 1],
      [1_001_001, 1_001_005, 5],
      [1_001_001, 1_002_005, 36],
      [1_001_001, 2_001_001, 1534],
    ].each do |start_verse_id, end_verse_id, expected_verse_count|
      describe "start_verse_id=#{start_verse_id} and end_verse_id=#{end_verse_id}" do
        subject { described_class.from_verse_ids(start_verse_id, end_verse_id).verses.count }
        it { is_expected.to eq expected_verse_count }
      end
    end
  end

  describe "include_verses?" do
    [
      [1_001_010, 2_001_001, 1_001_002, false],
      [1_001_010, 2_001_001, 1_001_010, true],
      [1_001_010, 2_001_001, 1_034_005, true],
      [1_001_010, 2_001_001, 2_001_001, true],
      [1_001_010, 2_001_001, 2_001_002, false],
      [1_001_010, 2_001_001, nil, false],
    ].each do |start_verse_id, end_verse_id, included_verse_id, expect_incuded|
      describe "start_verse_id=#{start_verse_id}, end_verse_id=#{end_verse_id}, included_verse_id=#{included_verse_id}" do
        let(:reference) { described_class.from_verse_ids(start_verse_id, end_verse_id) }
        subject { reference.includes_verse?(Verse.from_id(included_verse_id)) }
        it { is_expected.to eq expect_incuded }
      end
    end
  end

  describe "intersects_reference?" do
    [
      [1_001_010, nil, 1_001_010, nil, true],
      [1_001_010, 1_002_010, 1_002_011, 1_003_001, false],
      [1_001_010, 1_002_010, 1_002_010, 1_003_001, true],
      [1_001_010, 1_002_010, 1_002_009, 1_003_001, true],
      [1_001_010, 1_002_010, 1_001_001, 1_003_001, true],
      [1_001_010, 1_002_010, 1_001_001, 1_001_011, true],
      [1_001_010, 1_002_010, 1_001_001, 1_001_010, true],
      [1_001_010, 1_002_010, 1_001_001, 1_001_009, false],
    ].each do |ref1_start, ref1_end, ref2_start, ref2_end, intersect_expected|
      describe "ref1_start=#{ref1_start}, ref1_end=#{ref1_end}, ref2_start=#{ref2_start}, ref2_end=#{ref2_end}" do
        let(:reference1) { described_class.from_verse_ids(ref1_start, ref1_end) }
        let(:reference2) { described_class.from_verse_ids(ref2_start, ref2_end) }
        subject { reference1.intersects_reference? reference2 }
        it { is_expected.to eq intersect_expected }
      end
    end
  end

end
