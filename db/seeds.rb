if Rails.env.development?
  require 'time'

  departments = [
    ["wd1", "Geschichte, Zeitgeschichte und Politik", "http://www.bundestag.de/dokumente/analysen/wd1", "wd1"],
    ["wd2", "Auswärtiges, Völkerrecht, wirtschaftliche Zusammenarbeit und Entwicklung, Verteidigung, Menschenrechte und humanitäre Hilfe", "http://www.bundestag.de/dokumente/analysen/wd2", "wd2"],
    ["wd3", "Verfassung und Verwaltung", "http://www.bundestag.de/dokumente/analysen/wd3", "wd3"],
    ["wd4", "Haushalt und Finanzen", "http://www.bundestag.de/dokumente/analysen/wd4", "wd4"],
    ["wd5", "Wirtschaft und Verkehr, Ernährung und Landwirtschaft", "http://www.bundestag.de/dokumente/analysen/wd5", "wd5"],
    ["wd6", "Arbeit und Soziales", "http://www.bundestag.de/dokumente/analysen/wd6", "wd6"],
    ["wd7", "Zivil-, Straf- und Verfahrensrecht, Bau und Stadtentwicklung", "http://www.bundestag.de/dokumente/analysen/wd7", "wd7"],
    ["wd8", "Umwelt, Naturschutz, Reaktorsicherheit, Bildung und Forschung", "http://www.bundestag.de/dokumente/analysen/wd8", "wd8"],
    ["wd9", "Gesundheit, Familie, Senioren, Frauen und Jugend", "http://www.bundestag.de/dokumente/analysen/wd9", "wd9"],
    ["wd10", "Kultur, Medien und Sport", "http://www.bundestag.de/dokumente/analysen/wd10", "wd10"],
    ["pe6", "Europa", "http://www.bundestag.de/dokumente/analysen/pe6", "pe6"],
  ]

  departments.each do |short_name, subject, source_url, slug|
    Department.create(short_name: short_name, subject: subject, source_url: source_url, slug: slug)
  end

  (1..25).each do |i|
    Paper.create(
      reference: "0#{rand(10..100)}/#{rand(100)}",
      title: "Titel #{i}",
      url: "https://example.com",
      department_id: rand(1..departments.length()),
      contents: ["TTIP", "Terrorismus"].sample,
      page_count: rand(1..100),
      downloaded_at: Time.now
    )
  end
end
