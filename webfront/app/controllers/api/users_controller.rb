require 'openssl'
require 'socket'
class Api::UsersController < ApiController
  def available
    id = params[:user_id]
    user = User.find_by_name(id)
    if user.nil?
      return make_results({:result => "ng"}) 
    else
      return make_results({:result => "ok"}) 
    end
  end

  def call
    id = params[:user_id]
    user = User.find_by_name(id)
    if user.nil?
      return make_results({:result => "ng"}) 
    end
    devices = []
    user.devices.each do |device|
      devices.push(device.token)
    end
    if devices.size <= 0
      return make_results({:result => "ok"}) 
    end


#    device = ['da94a045ce4376e1c148cae49f204a999ee3e9bd06c3fca77434d53f04d370a3']
    socket = TCPSocket.new('gateway.sandbox.push.apple.com',2195)
    context = OpenSSL::SSL::SSLContext.new('SSLv3')
    context.cert = OpenSSL::X509::Certificate.new(File.read('/home/kyoro/keys/apns-dev.pem'))
    context.key  = OpenSSL::PKey::RSA.new(File.read('/home/kyoro/keys/apns-dev-key-noenc.pem'))
    ssl = OpenSSL::SSL::SSLSocket.new(socket, context)
    ssl.connect
    payload = {
      :aps => {
        :alert => "",
        :badge => 0,
        :sound => "famima.mp3"
      }
    }.to_json;
    (message = []) << ['0'].pack('H') << [32].pack('n') << devices.pack('H*') << [payload.size].pack('n') << payload
    ssl.write(message.join(''))
    ssl.close
    socket.close
    return make_results({:result => "ok"}) 
  end

end
