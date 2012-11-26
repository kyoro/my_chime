class ApiController < ApplicationController

  def make_results(args)
    return render :json => args.to_json
  end

  def current_user
    token = params[:token]
    user = User.find_by_token(token)
    return user
  end

end
