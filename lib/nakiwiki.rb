module NakiWiki
  require "infoboxer"

  def self.get_rescue_nil wiki, query, &block
    wiki.get query, &block
  rescue ::RuntimeError   # Infoboxer raises RuntimeError
  end
  private_class_method :get_rescue_nil

  def self.page_summary page
    page.paragraphs.map do |par|
      par if par.children.any?{ |_| _.is_a?(::Infoboxer::Tree::Text) && !_.to_s.empty? }
    end.find(&:itself).text.strip.gsub(/\n+/, " ")
  end
  private_class_method :page_summary

  def self.wiki query, lang, not_found, see_also
    # https://en.wikipedia.org/wiki/List_of_Wikipedias
    wikipedia = ::Infoboxer.wikipedia lang
    return not_found unless page = get_rescue_nil(wikipedia, query){ |_| _.prop :pageterms } ||
                                   wikipedia.search(query, limit: 1){ |_| _.prop(:pageterms) }.first ||
                                   wikipedia.search(query, limit: 1){ |_| _.prop(:pageterms).what(:text) }.first
    "#{
      if about = page.templates(name: "About").first
        _, _, alt, *_ = about.unwrap.map(&:text)
        # TODO: propose the (disambiguation) page
        "(#{see_also}: #{alt}) " if alt
      end
    }#{
      label, description = page.source.fetch("terms").values_at("label", "description")
      unless description
        if short = page.templates(name: "Short description").first
          short.unwrap.text
        else
          page_summary page
        end
      else
        fail unless 1 == description.size
        fail unless 1 == label&.size
        if {"ru" => "страница значений в проекте Викимедиа"}[lang] == description[0] && !page.lookup(:Template, name: "Неоднозначность").empty?
           "что вы имели в виду? #{page.sections.map{ |_| [_.heading.to_s, _.lookup(:Wikilink).map(&:name)] }.to_h.keep_if{ |_, __| !__.empty? }.flat_map{ |k, v| v.map(&:inspect) }.uniq.join ", " }"
        else
          [label, description].join(" -- ")
        end
      end
    }"
  end

end
