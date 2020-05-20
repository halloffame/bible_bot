module BibleBot
  # A Reference represents a range of verses.
  class Reference
    attr_reader :start_verse # @return [Verse]
    attr_reader :end_verse # @return [Verse]

    # Initialize a {Reference} from {Verse} IDs. If no end_verse_id is provided, it will
    # set end_verse to equal start_verse.
    #
    # @param start_verse_id [Integer]
    # @param end_verse_id [Integer]
    # @return [Reference]
    # @example
    #   BibleBot::Reference.from_verse_ids(1001001, 1001010) #=> (Gen 1:1-10)
    def self.from_verse_ids(start_verse_id, end_verse_id=nil)
      new(
        start_verse: Verse.from_id(start_verse_id),
        end_verse: Verse.from_id(end_verse_id || start_verse_id),
      )
    end

    # Parse text into an array of scripture References.
    #
    # By default, unless you specify `ignore_errors: true`, it will raise the following errors:
    # * {InvalidVerseError} - If a matching verse is not valid
    # * {InvalidReferenceError} - If verses are valid but reference is not
    #
    # @param text [String] ex: "John 1:1 is the first first but Romans 8:9-10 is another."
    # @param ignore_errors [Bool]
    # @return [Array<Reference>]
    def self.parse(text, ignore_errors: false)
      ReferenceMatch.scan(text).map do |ref_match|
        ref_match.reference(nil_on_error: ignore_errors)
      end.compact
    end


    # start_verse must be before end_verse otherwise it will raise an {InvalidReferenceError}
    #
    # @param start_verse [Verse]
    # @param end_verse [Verse]
    def initialize(start_verse:, end_verse: nil)
      @start_verse = start_verse
      @end_verse   = end_verse || start_verse

      raise InvalidReferenceError.new "Reference is not vaild: #{inspect}" unless valid?
    end

    # Returns a formatted string of the {Reference}.
    #
    # @return [String]
    # @example
    #   reference.formatted #=> "Genesis 2:4-5:9"
    def formatted
      formatted_verses = [start_verse.formatted(include_verse: !full_chapters?)]

      if end_verse && end_verse > start_verse && !(same_start_and_end_chapter? && full_chapters?)
        formatted_verses << end_verse.formatted(
          include_book: !same_start_and_end_book?,
          include_chapter: !same_start_and_end_chapter?,
          include_verse: !full_chapters?,
        )
      end

      formatted_verses.join('-')
    end

    # @return [Boolean]
    def same_start_and_end_book?
      start_verse.book == end_verse&.book
    end

    # @return [Boolean]
    def same_start_and_end_chapter?
      same_start_and_end_book? &&
      start_verse.chapter_number == end_verse&.chapter_number
    end

    # One or multiple full chapters.
    #
    # @return [Boolean]
    def full_chapters?
      start_verse.verse_number == 1 && end_verse&.last_verse_in_chapter?
    end

    # @return [string]
    def to_s
      "BibleBot::Reference — #{formatted}"
    end

    # Returns true if the given verse is within the start and end verse of the Reference.
    #
    # @param verse [Verse]
    # @return [Boolean]
    def includes_verse?(verse)
      return false unless verse.is_a?(Verse)

      start_verse <= verse && verse <= end_verse
    end

    # Return true if the two references contain any of the same verses.
    # @param other [Reference]
    # @return [Boolean]
    def intersects_reference?(other)
      return false unless other.is_a?(Reference)

      start_verse <= other.end_verse && end_verse >= other.start_verse
    end

    # Returns an array of all the verses contained in the Reference.
    #
    # @return [Array<Verse>]
    def verses
      return @verses if defined? @verses

      @verses = []
      verse = start_verse

      loop do
        @verses << verse
        break if end_verse.nil? || verse == end_verse
        verse = verse.next_verse
      end

      @verses
    end

    # @return [Hash]
    def inspect
      {
        start_verse: start_verse&.formatted,
        end_verse: end_verse&.formatted,
      }
    end

    private

    # This is private because it is called on initialize and raises an error if not valid
    # So any initialized Reference will always be valid.
    # @return [Boolean]
    def valid?
      start_verse && end_verse && end_verse >= start_verse
    end
  end
end
