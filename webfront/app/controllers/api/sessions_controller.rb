require 'pp'
class Api::SessionsController < ApiController
  def create
    username = params[:username]
    password = params[:password]
    device_token = params[:device_token]
    
    if username.blank? || password.blank? || device_token.blank?
      return make_results({:authenticated => "ng"}) 
    end

    device = Device.find_by_token(device_token)
    if device.nil?
      device = Device.new
      device.token = device_token
      device.save
    end
    user = User.login(:username => username, :password => password)
    if user.nil?
      return make_results({:authenticated => "ng"}) 
    else
      device.user = user
      device.save
      token = user.token
      return make_results({:authenticated => "ok", :token => token}) 
    end
  end

  def logout
    user = current_user
    pp params
    if user.nil?
      return make_results({:result => "ng"}) 
    end
    pp "aaaaaaaaaaaaa"
    device_token = params[:device_token]
    device = Device.find_by_token(device_token)
    if device.nil?
      return make_results({:result => "ng"}) 
    end
    pp "bbbbbbbbbbb"
    device.user = nil
    device.save
    return make_results({:result => "ok"}) 
  end

end
