class SearchController < ApplicationController
  def search
    @query = params[:q].presence
    redirect_to(root_url) && return if @query.blank?

    options = { page: params[:page], per_page: 10 }
    @papers = self.class.search_papers(@query, {}, options)
  end


  def self.search_papers(term, conditions, options = {})
    options =
      {
        where: conditions,
        fields: ['title^10', :contents],
        highlight: { tag: '<mark>' },
        aggs: [:department],
        execute: false,
        misspellings: false,
        include: [:department]
      }.merge(options)

    query = Paper.search(
      term,
      options
    ) do |body|
      # boost newer papers
      body[:query] = {
        function_score: {
          query: body[:query],
          functions: [
            { boost_factor: 1 },
            {
              gauss: {
                created_at: {
                  scale: '6w'
                }
              }
            }
          ],
          score_mode: 'sum'
        }
      }

      # use simple_query_string
      # NOT only works when WHITESPACE is enabled: https://github.com/elastic/elasticsearch/issues/9633
      body[:query][:function_score][:query] = {
        dis_max: {
          queries: [
            {
              simple_query_string: {
                fields: ['title.analyzed^10', 'contents.analyzed'],
                query: term,
                flags: 'AND|OR|NOT|PHRASE|WHITESPACE',
                default_operator: 'AND',
                analyzer: 'searchkick_search'
              }
            },
            {
              simple_query_string: {
                fields: ['title.analyzed^10', 'contents.analyzed'],
                query: term,
                flags: 'AND|OR|NOT|PHRASE|WHITESPACE',
                default_operator: 'AND',
                analyzer: 'searchkick_search2'
              }
            }
          ]
        }
      }

      body[:highlight][:fields]['title.analyzed'][:number_of_fragments] = 0
      body[:highlight][:fields]['contents.analyzed'] = {
        type: 'fvh',
        fragment_size: 250,
        number_of_fragments: 1,
        no_match_size: 250
      }
    end

    query.execute
  end

  def autocomplete
    q = params[:q]
    render json: Paper.search(q, fields: [{ 'title^1.5' => :text_start }, { title: :word_start }], limit: 5).map(&:autocomplete_data)
  end

  def opensearch
    response.headers['Content-Type'] = 'application/opensearchdescription+xml; charset=utf-8'
  end
end
