class CitiesController < ApplicationController

  def index
    @cities = prepare_cities City.order('created_at DESC')
  end

  def create
    @city = City.new(params[:city])

    if @city.save
      flash[:notice] = "#{@city.name} city was added."
    else
      flash[:alert] = @city.errors.full_messages.join(". ")
    end

    redirect_to cities_url
  end

  private

  def prepare_cities(scope)
    @per_page = City.default_per_page
    total_count = scope.count
    rest_count = total_count > @per_page ? (total_count % @per_page) : 0
    @num_pages = total_count > @per_page ? (total_count / @per_page) : 1

    if params[:page]
      offset = params[:page].sub(/-.*/, '').to_i
      current_page = @num_pages - (offset - 1) / @per_page
      scope.page(current_page).per(@per_page).padding(rest_count)
    else
      scope.page(1).per(@per_page + rest_count)
    end
  end

end
