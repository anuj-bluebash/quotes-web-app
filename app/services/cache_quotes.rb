class CacheQuotes
  Result = ImmutableStruct.new(:success,
                               :remote_object,
                               :cached_object,
                               :error_messages)

  END_POINT = 'http://quotesondesign.com/wp-json/posts'

  attr_writer :orderby, :records_per_page

  def initialize(args)
    @orderby = args[:orderby]
    @records_per_page = args[:records_per_page]
  end

  def cache
    conn = Faraday.new(:url => END_POINT) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    filter_params = { orderby: @orderby, posts_per_page: @records_per_page }

    response =  conn.get do |req| 
                  req.params['filter'] = filter_params
                end.body
    remote_object = JSON.parse(response)

    if remote_object.present?
      cached_object = remote_object.map do |record|
                      quote = Quote.find_or_create_by(id: record['ID'])
                      quote.title = record['title']
                      quote.content = record['content']
                      quote.link = record['link']
                      quote.save
                      quote
                    end

      Result.new(success: true,
                 remote_object: remote_object,
                 cached_object: cached_object)
    else
      raise I18n.t('invalid_api_response')
    end

  rescue => e
    return Result.new(success: false,
                      error_messages: e.message || e.original_message)
  end
end
