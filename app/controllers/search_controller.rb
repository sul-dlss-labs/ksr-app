# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    params[:q] ||= 'housing AND polic* AND Bay Area'
    @search_form_placeholder = I18n.t 'defaults_search.search_form_placeholder'
    @page_title = I18n.t 'defaults_search.display_name'
    @module_callout = I18n.t 'defaults_search.module_callout'
    @query = params_q_scrubbed
    @searches = search_service.all
    @found_types = @searches.select { |_key, searcher| searcher && searcher.results.present? }.keys
  end

  # The following searches for individual sections of the page.
  # This allows us to do client-side requests in cases where the original server-side
  # request times out or otherwise fails.
  def xhr_search
    endpoint = params[:endpoint]

    @query = params_q_scrubbed

    searcher = search_service.one(endpoint)

    respond_to do |format|
      format.html do
        render json: { endpoint => render_to_string(
          partial: 'search/xhr_response',
          layout: false,
          locals: { module_display_name: t("#{endpoint}_search.display_name"),
                    searcher: searcher,
                    search: '',
                    service_name: endpoint }
        ) }
      end

      format.json do
        # prevents openstruct object from results being nested inside tables
        # See: http://stackoverflow.com/questions/7835047/collecting-hashes-into-openstruct-creates-table-entry
        result_list = []
        searcher.results.each do |result|
          result_list << result.to_h
        end

        render json: { endpoint: endpoint,
                       total: searcher.total,
                       results: result_list }
      end
    end
  end

  private

  def params_q_scrubbed
    params[:q]&.scrub
  end

  def search_service
    SearchService.new(@query)
  end
end
