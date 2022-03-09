# frozen_string_literal: true

class DefaultController < ApplicationController
  def index
    render layout: false
  end

  def about
    @page_name = 'About'
  end

  def housing
    @page_name = 'Housing'
  end

  def policing
    @page_name = 'Policing'
  end

  def involved
    @page_name = 'Get Involved'
  end

  def timeline
    @page_name = 'History Timeline'
  end

  def data
    @page_name = 'Data On Systemic Racism'
  end

  def connections
    @connections = 'Explore Connections'
  end
end
