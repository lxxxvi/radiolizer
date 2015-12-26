class AwardsController < ApplicationController
  def index
    @awards = Award.all.joins(:ceremony).order('ceremonies.created_at DESC')
  end
end
