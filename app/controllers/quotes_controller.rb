class QuotesController < ApplicationController
  # GET /quotes/random
  # GET /quotes/random.json
  def random
    cache_service = CacheQuotes.new(orderby: 'rand', records_per_page: 1).cache
    if cache_service.success
      @quotes = cache_service.cached_object
    else
      @quotes = Quote.order("RANDOM()").limit(1)
    end
  end
end