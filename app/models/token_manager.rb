require 'digest/md5'

class TokenManager
	
	def initialize(user_id, security)
		@user_id = user_id
		@security = security
		@@token ||= File.read("config/seed.rb")
	end

	def valid?
		not @user_id.nil? and (@security.is_nil? || @security.is_blank? || @security === gera_hash)
	end
	
	private 
	def gera_hash
	  	Digest::MD5.hexdigest("#{@@token}::#{@user_id}")
	end
end