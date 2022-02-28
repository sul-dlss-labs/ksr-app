# frozen_string_literal: true

class SearchService
  attr_reader :query

  def initialize(query)
    @query = query
  end

  def all(threads: true, searchers: Settings.ENABLED_SEARCHERS)
    searches = searchers.index_with do |_searcher|
      nil
    end

    search_threads = searches.keys.shuffle.map do |search_method|
      # Use auto-loading outside the threadpool
      klass = "QuickSearch::#{search_method.camelize}Searcher".constantize

      Thread.new(search_method) do |_sm|
        searches[search_method] = one(klass, timeout: Settings.quick_search.http_timeout)
      rescue StandardError => e
        logger.info "FAILED SEARCH: #{search_method} | #{query} | #{e}"
      end
    end
    search_threads.each(&:join)

    searches
  end

  def one(searcher, timeout: 30)
    benchmark "%s #{searcher}" % CGI.escape(query.to_str) do
      klass = case searcher
              when Class
                searcher
              else
                "QuickSearch::#{searcher.camelize}Searcher".constantize
              end

      client = HTTP.timeout(timeout)

      klass.new(client, query).tap(&:search)
    end
  end

  private

  BenchmarkLogger = ActiveSupport::Logger.new(Rails.root.join('log/benchmark.log'))
  BenchmarkLogger.formatter = Logger::Formatter.new
  def benchmark(message)
    result = nil
    ms = Benchmark.ms { result = yield }
    BenchmarkLogger.info format('%s (%.1fms)', message, ms)
    result
  end

  def logger
    Rails.logger
  end
end
