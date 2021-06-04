module BibleBot
  # Represents a single chapter of a given book in the bible
  class Chapter
    include Comparable

    attr_reader :book # @return [Book]
    attr_reader :chapter_number # @return [Integer]

    # Turns an Integer into a Chapter
    # Supports either 4, 5, 7, or 8 digit id.
    # If it is an 8 digit id, it will truncate the last 3
    # verse digits.
    # Returns nil if no valid chapter is found.
    #
    # @return [Chapter,nil]
    def self.from_id(id)
      return nil unless id.is_a? Integer

      # Trim out verse digits if they are included
      chapter_id     = id >= 1_000_000 ? id / 1000 : id
      book_id        = chapter_id / 1_000
      chapter_number = chapter_id % 1_000
      book           = BibleBot::Book.find_by_id(book_id)
      chapter        = new(book: book, chapter_number: chapter_number)

      chapter if chapter.valid?
    end

    def initialize(book:, chapter_number:)
      @book = book
      @chapter_number = chapter_number
    end

    # Similar to Verse ID, without the last 3 verse digits.
    # Returns a 4 or 5 digit Integer in the from of
    #
    #   |- book.id
    #   |   |- chapter_number
    #   XX_XXX
    #
    def id
      @id ||= "#{book.id}#{chapter_number.to_s.rjust(3,'0')}".to_i
    end

    # @return [String]
    def to_s
      "#{book.formatted_name} #{chapter_number}"
    end

    # The Comparable mixin uses this to define all the other comparable methods
    #
    # @param other [Chapter]
    # @return [Integer] Either -1, 0, or 1
    #   * -1: this chapter is less than the other chapter
    #   * 0: this chapter is equal to the other chapter
    #   * 1: this chapter is greater than the other chapter
    def <=>(other)
      id <=> other.id
    end

    # A reference containing the entire chapter
    # @return [Reference]
    def reference
      @reference ||= Reference.new(start_verse: start_verse, end_verse: end_verse)
    end

    # @return [Integer]
    def verse_count
      book.chapters[chapter_number - 1]
    end

    # @return [Verse]
    def start_verse
      @start_verse ||= Verse.from_id("#{book.id}#{chapter_number.to_s.rjust(3, '0')}001".to_i)
    end

    # @return [Verse]
    def end_verse
      @end_verse ||= Verse.from_id(
        "#{book.id}#{chapter_number.to_s.rjust(3, '0')}#{verse_count.to_s.rjust(3, '0')}".to_i
      )
    end

    # Returns next chapter. It will reach into the next book
    # until it gets to the last chapter in the bible,
    # at which point it will return nil.
    #
    # @return [Chapter, nil]
    def next_chapter
      return Chapter.new(book: book, chapter_number: chapter_number + 1) unless last_chapter_in_book?
      return Chapter.new(book: book.next_book, chapter_number: 1) if book.next_book
    end

    # @return [Boolean]
    def last_chapter_in_book?
      chapter_number == book.chapters.length
    end

    # @return [Boolean]
    def valid?
      book.is_a?(BibleBot::Book) &&
        chapter_number.is_a?(Integer) &&
        chapter_number >= 1 &&
        chapter_number <= book.chapters.length
    end
  end
end
