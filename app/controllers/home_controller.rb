# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :quotes

  def index; end

  def quotes
    @quotes = Quote.includes(:security).order('securities.type DESC', ticker: :asc)
  end
end
