class HomeController < ApplicationController
  def index
    @query = params[:q]
    @results = SiteSearch.search @query unless @query.nil?
  end

  def about
  end

  def license
  end
end
