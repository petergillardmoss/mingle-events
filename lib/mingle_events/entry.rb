module MingleEvents

  # A Ruby wrapper around an Atom entry, particularly an Atom entry
  # representing an event in Mingle.
  class Entry

    # Construct with the wrapped Nokogiri Elem for the entry
    def initialize(entry_element)
      @entry_element = entry_element
    end

    # The raw entry XML from the Atom feed
    def raw_xml
      @raw_xml ||= @entry_element.to_s
    end

    # The Atom entry's id value. This is the one true identifier for the entry,
    # and therefore the event.
    def entry_id
      @entry_id ||= @entry_element.at('id').inner_text
    end
    alias :event_id :entry_id

    # The Atom entry's title
    def title
      @title ||= @entry_element.at('title').inner_text
    end

    # The time at which entry was created, i.e., the event was triggered
    def updated
      @updated ||= Time.parse(@entry_element.at('updated').inner_text)
    end

    # The user who created the entry (triggered the event), i.e., changed project data in Mingle
    def author
      @author ||= Author.new(@entry_element.at('author'))
    end

    # The set of Atom categoies describing the entry
    def categories
      @categories ||= @entry_element.search('category').map do |category_element|
        Category.new(category_element.attribute('term').text, category_element.attribute('scheme').text)
      end
    end

    # Any changes related to the event (if any).
    def changes
      @changes ||= @entry_element.search('change').map do |change_element|
        Change.new
      end
    end

    # Whether the entry/event was sourced by a Mingle card
    def card?
      categories.any?{|c| c == Category::CARD}
    end

    # The number of the card that sourced this entry/event. If the entry is not a card event
    # an error will be thrown. The source of this data is perhaps not so robust and we'll need
    # to revisit this in the next release of Mingle.
    def card_number
      raise "You cannot get the card number for an event that is not sourced by a card!" unless card?
      @card_number ||= parse_card_number
    end

    # The version number of the card or page that was created by this event. (For now, only
    # working with cards.)
    def version
      @version ||= CGI.parse(URI.parse(card_version_resource_uri).query)['version'].first.to_i
    end

    # The resource URI for the card version that was created by this event. Throws error if not card event.
    def card_version_resource_uri
      raise "You cannot get card version data for an event that is not sourced by a card!" unless card?
      @card_version_resource_uri ||= parse_card_version_resource_uri
    end

    private

    def parse_card_number
      card_number_element = @entry_element.at(
        "link[@rel='http://www.thoughtworks-studios.com/ns/mingle#event-source'][@type='application/vnd.mingle+xml']"
      )
      # TODO: improve this bit of parsing :)
      card_number_element.attribute('href').text.split('/').last.split('.')[0..-2].join.to_i
    end

    def parse_card_version_resource_uri
      card_number_element = @entry_element.at(
        "link[@rel='http://www.thoughtworks-studios.com/ns/mingle#version'][@type='application/vnd.mingle+xml']"
      )
      card_number_element.attribute('href').text
    end

  end
end
