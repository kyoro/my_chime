class PagesController < ApplicationController

  def index
    return render :text => params.to_s
  end

end
