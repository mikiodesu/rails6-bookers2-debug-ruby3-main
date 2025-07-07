class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @keyword = params[:keyword]
    @model = params[:model]
    @search_type = params[:search_type]

    if @model == "user"
      @results = search_for(User, "name")
    elsif @model == "book"
      @results = search_for(Book, "title")
    else
      @results = []
    end
  end

  private

  def search_for(model, column)
    case @search_type
    when "perfect"
      model.where("#{column} = ?", @keyword)
    when "forward"
      model.where("#{column} LIKE ?", "#{@keyword}%")
    when "backward"
      model.where("#{column} LIKE ?", "%#{@keyword}")
    when "partial"
      model.where("#{column} LIKE ?", "%#{@keyword}%")
    else
      model.none
    end
  end
end