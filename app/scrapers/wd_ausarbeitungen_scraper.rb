require 'mechanize'
require 'addressable'
require 'date'

class WdAusarbeitungenScraper
  BASE_URL = 'http://www.bundestag.de/ausarbeitungen'

  def self.scrape_departments
    m = Mechanize.new
    mp = m.get BASE_URL

    departments = []

    mp.search('//div[@id="inhaltsbereich"]//ul/li//a').each do |link|
      name = link.text.strip

      path = link.attributes['href'].value
      url = Addressable::URI.parse(BASE_URL).join(path).normalize.to_s

      short_name = path.split('/').last

      departments << {
        short_name: short_name,
        subject: name,
        source_url: url
      }
    end

    departments
  end

  def self.scrape_department(department_url)
    m = Mechanize.new
    mp = m.get department_url

    reports = []

    mp.search('//div[@id="inhaltsbereich"]//ul/li').each do |item|
      meta = item.children[0].text.strip
      mm = meta.match(/\A(.+)\p{Z}+vom\p{Z}+([\d\.]+)\p{Z}*\z/)
      doctype = mm[1].strip.downcase
      date = Date.parse(mm[2])

      title = item.at_css('strong').text
      t = title.match(/[WP][DEF]\p{Z}*\d*.+?\p{Pd}?\p{Z}*([\d\/]+)\p{Z}*(.+)/i)
      if t.nil?
        STDERR.puts "Can't extract title: \"#{title}\" source: #{department_url}"
        next
      end

      reference = t[1].strip
      title = t[2].strip

      link = item.at_css('a')
      path = link.attributes['href'].value
      url = Addressable::URI.parse(department_url).join(path).normalize.to_s

      reports << {
        doctype: doctype,
        reference: reference,
        title: title,
        url: url,
        created_at: date
      }
    end

    reports
  end

  def self.scrape_all
    departments = scrape_departments
    departments.each do |department|
      department[:reports] = scrape_department(department[:url])
    end
    departments
  end
end