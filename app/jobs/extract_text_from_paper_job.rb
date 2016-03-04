class ExtractTextFromPaperJob < ApplicationJob
  queue_as :meta

  def perform(paper, options = {})
    options.reverse_merge!(method: :all)
    logger.info "Extracting Text of the Paper [#{paper.department.short_name} #{paper.reference}]"
    text = nil

    methods = [:tika, :ocrspace, :local]
    methods = [options[:method]] unless options[:method] == :all

    methods.each do |method|
      begin
        text = extract(method, paper)
        break unless text.blank?
      rescue => e
        logger.warn e
      end
    end

    fail "Can't extract text from Paper [#{paper.department.short_name} #{paper.reference}]" if text.blank?

    text = self.class.clean_text(text)

    paper.contents = text
    paper.save!
  end

  def extract(method, paper)
    case method
    when :tika
      extract_tika(paper) unless Rails.configuration.x.tika_server.blank?
    when :ocrspace
      extract_ocrspace(paper)
    when :local
      extract_local(paper)
    end
  end

  def extract_local(paper)
    fail "No local copy of the PDF of Paper [#{paper.department.short_name} #{paper.reference}] found" unless File.exist?(paper.local_path)

    tempdir = Dir.mktmpdir
    Docsplit.extract_text(paper.local_path, ocr: false, output: tempdir)
    filename = paper.local_path.basename('.*').to_s
    resultfile = "#{tempdir}/#{filename}.txt"
    return false unless File.exist?(resultfile)
    File.read resultfile
  ensure
    FileUtils.remove_entry_secure tempdir if File.exist?(tempdir)
  end

  def tika_endpoint
    Addressable::URI.parse(Rails.configuration.x.tika_server).join('./tika').normalize.to_s
  end

  def extract_tika(paper)
    fail "No local copy of the PDF of Paper [#{paper.department.short_name} #{paper.reference}] found" unless File.exist?(paper.local_path)
    pdf_contents = File.new(paper.local_path).read
    response = Excon.put(tika_endpoint,
                 body: pdf_contents,
                 headers: { 'Content-Type' => 'application/pdf', 'Accept' => 'text/plain' })
    fail "Couldn't get response, status: #{response.status}" if response.status != 200
    # reason for force_encoding: https://github.com/excon/excon/issues/189
    text = response.body.force_encoding('utf-8').strip
    # remove weird pdf control things
    text.gsub(/\n\n<<\n.+\n>> (?:setdistillerparams|setpagedevice)/m, '')
  end

  def extract_ocrspace(paper)
    response = Excon.post('https://api.ocr.space/parse/image',
                          body: URI.encode_www_form(apikey: 'helloworld', url: paper.url, language: 'ger'),
                          headers: { 'Content-Type' => 'application/x-www-form-urlencoded', 'Accept' => 'application/json' })
    fail "Couldn't get response, status: #{response.status}" if response.status != 200
    data = JSON.parse response.body
    fail "Error from ocr.space: #{data['ErrorMessage']}, #{data['ErrorDetails']}" if data['OCRExitCode'] > 1 || data['IsErroredOnProcessing'] != false
    text = []
    data['ParsedResults'].each do |result|
      text << result['ParsedText'].strip
    end
    text.join("\n\n")
  end

  def self.clean_text(text)
    # windows newlines
    text.gsub!(/\r\n/, "\n")
    # "be-\npflanzt" -> "bepflanzt\n", "be- \npflanzt" -> "bepflanzt\n"
    text.gsub!(/(\p{L}+)\-\p{Zs}*\r?\n\n?(\p{Ll}+)/m, "\\1\\2\n")
    # soft hyphen
    text.gsub!(/\u00AD/, '')
    # utf8 replacement char
    text.gsub!(/\uFFFD/, ' ')
    # private use area
    text.gsub!(/\p{InPrivate_Use_Area}/, ' ')
    text
  end
end