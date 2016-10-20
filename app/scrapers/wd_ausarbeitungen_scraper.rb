require 'mechanize'
require 'addressable'
require 'date'

class WdAusarbeitungenScraper
  BASE_URL = 'https://www.bundestag.de/ajax/filterlist/de/-/474644'
  PER_PAGE = 500

  def self.hash_url(params)
    params_for_hash = params.gsub(/[^a-zA-Z0-9]*/, '')
    hash = Digest::MD5.hexdigest(params_for_hash)
    "/h_#{hash}?#{params}"
  end

  def self.paged_url(page = 0)
    params = "limit=#{PER_PAGE}&noFilterSet=true"
    params += "&offset=#{page * PER_PAGE}" if page != 0
    "#{BASE_URL}#{hash_url(params)}"
  end

  def self.scrape_all
    m = Mechanize.new
    mp = m.get BASE_URL
    page = 0
    reports = []

    loop do
      page += 1
      content = scrape_current_page(mp, page)
      break if content.nil?
      reports.concat content
      mp = m.get paged_url(page)
    end

    reports
  end

  def self.scrape_page(page = 0)
    m = Mechanize.new
    mp = m.get paged_url(page)
    scrape_current_page(mp, page)
  end

  def self.scrape_current_page(mp, page)
    reports = []

    if mp.search('//h3').size > 0 || mp.search('//table').size == 0
      return nil
    end

    mp.search('//table/tbody/tr').each do |item|
      date_text = item.at_css('[data-th="Datum"] p').text.strip
      date = Date.parse(clean_date(date_text))

      doctype = item.at_css('[data-th="Dokumenttyp"] p').text.strip
      next if doctype.starts_with?('Aktueller Begriff') || doctype == 'Infobrief'

      title_el = item.at_css('[data-th="Dokument"] p strong')
      title_el.css('br').each { |br| br.replace ' ' }
      title = title_el.text.strip
      t = title.match(/([WP][DEF]\p{Z}*\d*).+?\p{Pd}?\p{Z}*([\d\/]+)\p{Z}*(.+)/i)
      if t.nil?
        STDERR.puts "Can't extract title:\"#{title}\" doctype:\"#{doctype}\" page:#{page}"
        next
      end

      department = t[1].strip.gsub(/\p{Z}/, '').downcase
      reference = t[2].strip
      title = t[3].strip

      link = item.at_css('a')
      path = link.attributes['href'].value
      addr = Addressable::URI.parse(BASE_URL).join(path).normalize
      addr.scheme = 'https'
      url = addr.to_s

      reports << {
        doctype: doctype,
        department: department,
        reference: reference,
        title: title,
        url: url,
        created_at: date
      }
    end

    reports
  end

  def self.clean_date(d)
    months = {
      'januar' => 1, 'februar' => 2, 'märz' => 3, 'april' => 4,
      'mai' => 5, 'juni' => 6, 'juli' => 7, 'august' => 8,
      'september' => 9, 'oktober' => 10, 'november' => 11, 'dezember' => 12
    }
    d = d.strip.downcase.gsub(/^(\d+)\s/, '\1. ')
    months.keys.each do |german|
      d = d.gsub(german, "#{months[german]}.")
    end
    d.gsub(/\s/, '')
  end
end