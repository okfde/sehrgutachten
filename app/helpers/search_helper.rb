module SearchHelper
  # look into actionview / atom_feed_helper
  def search_feed_id(query, page = nil)
    schema_date = "2005" # The Atom spec copyright date
    "tag:#{request.host},#{schema_date}:#{request.fullpath.split('.')[0]},query:#{query}" + (!page.nil? ? ",page:#{page}" : '')
  end
end