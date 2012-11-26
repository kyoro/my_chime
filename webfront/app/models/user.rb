class User < ActiveRecord::Base
  has_many :devices

  def self.login(args)
    username = args[:username] || ''
    password = args[:password] || ''
    return User.find_by_name_and_password(username,password)
  end
end
